import 'dart:convert';
import 'dart:io';

import 'package:boundaries_detector/src/utils/dataset.dart';
import 'package:boundaries_detector/src/utils/image_params_extractor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

import 'tools/constants.dart';

void main() {
  test(
    'Find Unrecognized Images',
    () async {
      final Directory testImagesDir = Directory(join(current, outputDirName, outputImagesDirName));
      final List<FileSystemEntity> testImages = testImagesDir.listSync();

      final Map<ImageParams, bool> foundStatuses = {};

      for (final String imagePath in dataset) {
        final ImageParams params = extractImageParams(imagePath).copyWith(size: '');
        foundStatuses[params] = false;
      }

      for (final FileSystemEntity file in testImages) {
        if (file is File) {
          final ImageParams params = extractImageParams(file.path);
          foundStatuses[params] = true;
        }
      }

      final Set<String> notRecognizedImagesPaths = {};

      // assets/cards/300x400/white_dark_5.jpg
      for (final MapEntry(:key, :value) in foundStatuses.entries) {
        if (value == false) {
          notRecognizedImagesPaths.add(_imageParamsToOriginalPath(key));
        }
      }

      final int notFoundAmount = notRecognizedImagesPaths.length;
      final int totalAmount = foundStatuses.length;
      final int foundAmount = totalAmount - notFoundAmount;

      print('Not found images: $notFoundAmount / $totalAmount; Accuracy: ${foundAmount / totalAmount * 100}%');

      final File outputFile = File(join(current, outputDirName, 'not_recognized_images.json'));
      outputFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(notRecognizedImagesPaths.toList()));

      final Directory originalImagesDir = Directory(join(current, 'assets', 'cards', '300x400'));
      final List<File> originalImages = originalImagesDir.listSync().whereType<File>().where((it) => it.path.contains('.jpg')).toList();

      final Directory unrecognizedImagesDir = Directory(join(current, outputDirName, outputUnrecognizedImagesDirName));

      if (unrecognizedImagesDir.existsSync() == false) {
        unrecognizedImagesDir.createSync(recursive: true);
      }

      for (final File file in originalImages) {
        final ImageParams params = extractImageParams(file.path);
        final String originalPath = _imageParamsToOriginalPath(params);
        if (notRecognizedImagesPaths.contains(originalPath)) {
          final String imageName = _imageParamsToOriginalPath(params, nameOnly: true);

          file.copySync(join(current, outputDirName, outputUnrecognizedImagesDirName, imageName));
        }
      }

      File(join(current, outputDirName, 'score.md')).writeAsStringSync('''
Recognized images: $foundAmount
Unrecognized images: $notFoundAmount
Total images: $totalAmount
Recognition score: ${foundAmount / totalAmount * 100}%
''');
    },
  );
}

String _imageParamsToOriginalPath(ImageParams params, {bool nameOnly = false}) {
  return [
    if (nameOnly == false) 'assets/cards/300x400/',
    params.card,
    '_',
    params.background,
    '_',
    params.index,
    '.jpg',
  ].join();
}
