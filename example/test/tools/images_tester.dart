import 'package:boundaries_detector/src/boundaries/logic/model/image_result.dart';
import 'package:boundaries_detector/src/boundaries/ui/component/simple_image_frame.dart';
import 'package:boundaries_detector/src/utils/bench.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';

import 'images_finder.dart';
import 'save_image_as_file.dart';
import 'settings_iterator.dart';
import 'widget_to_image.dart';

typedef Score = (int maxSucceededImages, int totalImages, EdgeVisionSettings bestSettings);

Future<void> imagesTester({
  required String id,
  required FoundImages imagesToProcess,
  required EdgeVisionSettings initialSettings,
  required EdgeVisionSettings endSettings,
  required EdgeVisionSettings stepSettings,
}) async {
  int maxSucceededImages = 0;

  final int totalImages = imagesToProcess.$1.length;
  EdgeVisionSettings? bestSettings;

  await iterateOverSettings(
    initial: initialSettings,
    target: endSettings,
    step: stepSettings,
    callback: (EdgeVisionSettings settings, int index, int total) async {
      EdgeVision.logLevel = EdgeVisionLogLevel.nothing;
      final EdgeVision edgeVision = EdgeVision(settings: {settings});
      int succeededImages = 0;

      start('Processing $totalImages');

      final List<Image> images = imagesToProcess.$1;
      final List<String> names = imagesToProcess.$2;

      for (int i = 0; i < images.length; i++) {
        final Image image = images[i];
        final String imageName = names[i];
        late Image preparedImage;
        final Edges result = edgeVision.findImageEdges(image: image, onImagePrepare: (Image image) => preparedImage = image);

        if (result.corners.isNotEmpty) {
          succeededImages++;

          final simpleImageFrame = SimpleImageFrame(
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

          final Image widgetImage = await widgetToImage(simpleImageFrame);

          final String fullPath = join('output_images', id, '${index}_$imageName');

          await saveImageAsFile(widgetImage, fullPath);
        }
      }
      final double timeConsumed = stop('Processing $totalImages', silent: true);

      if (succeededImages > maxSucceededImages) {
        maxSucceededImages = succeededImages;
        bestSettings = settings;
      }

      print(
        'Operation $index / $total (${(index / total * 100).toStringAsFixed(2)}%) ended within ${timeConsumed}ms; Success: $succeededImages / $totalImages or ${(succeededImages / totalImages * 100).toStringAsFixed(2)}% ',
      );
    },
  );

  print(
    '[$id] Best result: $maxSucceededImages / $totalImages or ${(maxSucceededImages / totalImages * 100).toStringAsFixed(2)}% with these settings: $bestSettings',
  );
}
