import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart';
import 'package:test/test.dart' as dart_test;

import 'generate_test_id.dart';
import 'images_finder.dart';
import 'images_tester.dart';
import 'settings.dart';

void testCreator(Set<String> imageColors, Set<String> backgroundColors) {
  dart_test.test(
    generateId(imageColors, backgroundColors),
    timeout: Timeout.none,
    () async {
      final List<Image> imagesToProcess = await findImages(imageColors, backgroundColors);

      await imagesTester(
        id: generateId(imageColors, backgroundColors),
        imagesToProcess: imagesToProcess,
        initialSettings: initialSettings,
        endSettings: endSettings,
        stepSettings: stepSettings,
      );
    },
  );
}
