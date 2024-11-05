import 'package:boundaries_detector/src/utils/bench.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:image/image.dart';

import 'settings_iterator.dart';

typedef Score = (int maxSucceededImages, int totalImages, EdgeVisionSettings bestSettings);

Future<void> imagesTester({
  required String id,
  required List<Image> imagesToProcess,
  required EdgeVisionSettings initialSettings,
  required EdgeVisionSettings endSettings,
  required EdgeVisionSettings stepSettings,
}) async {
  int maxSucceededImages = 0;
  final int totalImages = imagesToProcess.length;
  EdgeVisionSettings? bestSettings;

  await iterateOverSettings(
    initial: initialSettings,
    target: endSettings,
    step: stepSettings,
    callback: (EdgeVisionSettings settings, int index, int total) async {
      final EdgeVision edgeVision = EdgeVision(settings: {settings}, processingMode: EdgeProcessingMode.allInOne);
      int succeededImages = 0;

      start('Processing ${imagesToProcess.length}');
      for (final Image image in imagesToProcess) {
        final Edges result = edgeVision.findImageEdges(image: image);

        if (result.corners.isNotEmpty) {
          succeededImages++;
        }
      }
      final double timeConsumed = stop('Processing ${imagesToProcess.length}', silent: true);

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
