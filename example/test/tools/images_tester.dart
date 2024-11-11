import 'dart:ui';

import 'package:boundaries_detector/src/boundaries/logic/model/image_result.dart';
import 'package:boundaries_detector/src/boundaries/ui/component/simple_image_frame.dart';
import 'package:boundaries_detector/src/utils/bench.dart';
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

Future<void> imagesTester({
  required String id,
  required EdgeVisionSettings initial,
  required EdgeVisionSettings target,
  required EdgeVisionSettings step,
  required WidgetTester tester,
  FoundImages? imagesToProcess,
  FoundImage? imageToProcess,
}) async {
  if (imagesToProcess == null && imageToProcess == null) {
    throw ArgumentError('imagesToProcess or either imageToProcess should not be a null');
  }

  int maxSucceededImages = 0;

  final List<Image> images = imagesToProcess?.$1 ?? [imageToProcess!.$1];
  final List<String> names = imagesToProcess?.$2 ?? [imageToProcess!.$2];

  final int totalImages = images.length;
  EdgeVisionSettings? bestSettings;

  final int totalIterations = await calculateIterationsAmountV2(initial: initial, target: target, step: step);

  await iterateOverSettings(
    initial: initial,
    target: target,
    step: step,
    total: totalIterations,
    callback: (EdgeVisionSettings settings, int index, int total) async {
      EdgeVision.logLevel = EdgeVisionLogLevel.nothing;
      final EdgeVision edgeVision = EdgeVision(settings: {settings});
      int succeededImages = 0;

      final String settingsName = 'settings_${index}_of_$total';

      start('Processing $totalImages');
      for (int i = 0; i < images.length; i++) {
        final Image image = images[i];
        final String imageName = names[i];
        late Image preparedImage;
        final Edges result = await edgeVision.findImageEdges(image: image, onImagePrepare: (Image image) => preparedImage = image);

        if (result.corners.isNotEmpty) {
          succeededImages++;

          final SimpleImageFrame simpleImageFrame = SimpleImageFrame(
            result: ImageResult(
              name: '',
              originalImage: encodeJpg(image),
              decodedImage: image,
              processedImage: encodeJpg(preparedImage),
              edges: result,
              originalImageWidth: image.width,
              originalImageHeight: image.height,
              processedImageWidth: preparedImage.width,
              processedImageHeight: preparedImage.height,
            ),
          );

          final Image widgetImage = await screenshot(widget: simpleImageFrame, size: Size(1200, 1600));

          final String imageFullPath = join('output_images', id, settingsName, imageName).replaceAll(' ', '_').replaceAll(':', '').toLowerCase();

          await saveImageAsFile(widgetImage, imageFullPath);
        }
      }

      final double timeConsumed = stop('Processing $totalImages', silent: true);

      if (succeededImages > maxSucceededImages) {
        maxSucceededImages = succeededImages;
        bestSettings = settings;
      }

      if (succeededImages > 0) {
        final String resultsName = 'results_${index}_of_$total';
        final String resultsFullPath = join('output_images', id, settingsName, resultsName).replaceAll(' ', '_').replaceAll(':', '').toLowerCase();

        final String jsonFullPath = join('output_images', id, settingsName, settingsName).replaceAll(' ', '_').replaceAll(':', '').toLowerCase();
        await saveJsonAsFile(settings.toJson(), jsonFullPath);

        final Map<String, Object> results = {
          'totalSettings': total,
          'succeededImages': succeededImages,
          'totalImages': totalImages,
          'imagesInTest': names,
          'processingTimeMs': timeConsumed,
          'successRate': (succeededImages / totalImages) * 100,
        };
        await saveJsonAsFile(results, resultsFullPath);
      }

      print(
        'Operation $index / $total (${(index / total * 100).toStringAsFixed(2)}%) ended within ${timeConsumed}ms; Success: $succeededImages / $totalImages or ${(succeededImages / totalImages * 100).toStringAsFixed(2)}% ',
      );
    },
  );

  print(
    '[$id] Best result: $maxSucceededImages / $totalImages or ${(maxSucceededImages / totalImages * 100).toStringAsFixed(2)}% with these settings: $bestSettings',
  );

  if (bestSettings != null) {
    const String bestSettingsName = 'best_settings';
    final String bestSettingsFullPath = join('output_images', id, bestSettingsName).replaceAll(' ', '_').replaceAll(':', '').toLowerCase();
    await saveJsonAsFile(bestSettings!.toJson(), bestSettingsFullPath);
  }
}
