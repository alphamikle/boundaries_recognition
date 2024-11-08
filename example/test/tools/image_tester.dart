import 'dart:ui';

import 'package:boundaries_detector/src/boundaries/logic/model/image_result.dart';
import 'package:boundaries_detector/src/boundaries/ui/component/simple_image_frame.dart';
import 'package:boundaries_detector/src/utils/bench.dart';
import 'package:boundaries_detector/src/utils/image_params_extractor.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

import 'images_finder.dart';
import 'save_image_as_file.dart';
import 'save_json_as_file.dart';
import 'screenshot.dart';
import 'settings/settings_iterator.dart';

typedef Score = (int maxSucceededImages, int totalImages, EdgeVisionSettings bestSettings);

bool _isAnglesValid(Edges edges, double diff) {
  final double? leftTop = edges.leftTopAngle;
  final double? rightTop = edges.rightTopAngle;
  final double? rightBottom = edges.rightBottomAngle;
  final double? leftBottom = edges.leftBottomAngle;

  if (leftTop == null || rightTop == null || rightBottom == null || leftBottom == null) {
    return false;
  }

  bool isValid(double angle) {
    return (angle - 90).abs() <= diff;
  }

  return isValid(leftTop) && isValid(rightTop) && isValid(rightBottom) && isValid(leftBottom);
}

Future<void> imageTester({
  required String id,
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
  required WidgetTester tester,
  required FoundImage imageToProcess,
}) async {
  final Image image = imageToProcess.$1;
  final String imagePath = imageToProcess.$2;
  final ImageParams(:card, :background, index: imageIndex) = extractImageParams(imagePath);

  final int totalIterations = await calculateIterationsAmountV2(initial: initial, target: target, step: step);

  await iterateOverSettings(
    initial: initial,
    target: target,
    step: step,
    total: totalIterations,
    callback: (EdgeVisionSettings settings, int index, int total) async {
      EdgeVision.logLevel = EdgeVisionLogLevel.nothing;

      start('Processing');

      final EdgeVision edgeVision = EdgeVision(settings: {settings});
      late Image preparedImage;
      final Edges result = edgeVision.findImageEdges(image: image, onImagePrepare: (Image image) => preparedImage = image);
      final double? square = result.relativeSquare;
      final bool success = result.corners.isNotEmpty && _isAnglesValid(result, 5) && square != null && square > 0.35 && square < 0.85;

      if (success) {
        final SimpleImageFrame widget = SimpleImageFrame(
          result: ImageResult(
            name: '',
            originalImage: encodeJpg(image),
            decodedImage: image,
            processedImage: encodeJpg(preparedImage),
            edges: result,
            processedImageWidth: preparedImage.width,
            processedImageHeight: preparedImage.height,
          ),
        );

        Image widgetImage = await screenshot(widget: widget, size: Size(1200, 1600));
        widgetImage = widgetImage.resize(720, 540);

        final String filename = '${card}_on_${background}_${imageIndex}_test_${index}_of_$total';

        final String imageFullPath = join('one_by_one_tests', 'images', 'image_$filename').replaceAll(' ', '_').replaceAll(':', '').toLowerCase();
        final String settingsFullPath = join('one_by_one_tests', 'settings', 'settings_$filename').replaceAll(' ', '_').replaceAll(':', '').toLowerCase();
        final String resultsFullPath = join('one_by_one_tests', 'results', 'results_$filename').replaceAll(' ', '_').replaceAll(':', '').toLowerCase();

        await saveImageAsFile(widgetImage, imageFullPath);
        await saveJsonAsFile(settings.toJson(), settingsFullPath);
        await saveJsonAsFile(result.toJson(), resultsFullPath);
      }

      final double timeConsumed = stop('Processing', silent: true);

      print(
        'Operation $index / $total (${(index / total * 100).toStringAsFixed(2)}%) ended within ${timeConsumed}ms; Success: $success',
      );
    },
  );
}
