import 'package:flutter_test/flutter_test.dart';

import 'generate_test_id.dart';
import 'image_tester.dart';
import 'images_finder.dart';
import 'images_tester.dart';
import 'settings/iterable_settings.dart';

Future<void> testCreator(Set<String> imageColors, Set<String> backgroundColors) async {
  final String id = generateId(imageColors, backgroundColors);
  print('Going to test $id');

  final FoundImages imagesToProcess = await findImages(imageColors, backgroundColors);

  print('Found ${imagesToProcess.$1.length} images to test');

  testWidgets(
    id,
    timeout: Timeout.none,
    (WidgetTester tester) async {
      await tester.runAsync(
        () async {
          await imagesTester(
            id: id,
            imagesToProcess: imagesToProcess,
            initial: initialSettings,
            target: targetSettings,
            step: stepSettings,
            tester: tester,
          );
        },
      );
    },
  );
}

Future<void> singleImageTestCreator(String imagePath) async {
  final FoundImage image = await findImage(imagePath);

  testWidgets(
    imagePath,
    timeout: Timeout.none,
    (WidgetTester tester) async {
      await tester.runAsync(
        () async {
          await imageTester(
            id: imagePath,
            imageToProcess: image,
            initial: initialSettings,
            target: targetSettings,
            step: stepSettings,
            tester: tester,
          );
        },
      );
    },
  );
}
