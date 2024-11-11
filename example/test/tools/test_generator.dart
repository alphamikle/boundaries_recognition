import 'dart:io';

import 'package:boundaries_detector/src/utils/dataset.dart';
import 'package:path/path.dart';

String template(String imagePath) {
  return '''
import '../tools/test_creator.dart';

Future<void> main() async {
  await singleImageTestCreator('$imagePath');
}
''';
}

void main() {
  int index = 0;
  final int count = dataset.length;
  for (final String imagePath in dataset) {
    final String code = template(imagePath);
    final String testFilename = imagePath.replaceAll('/', '_').replaceAll(':', '').replaceAll('.jpg', '');
    final File file = File(join(current, 'test', 'generated_test', '${index++}_of_${count}_${testFilename}_test.dart'));
    final Directory directory = file.parent;

    if (directory.existsSync() == false) {
      directory.createSync(recursive: true);
    }
    file.writeAsStringSync(code);
  }
  print('${dataset.length} test files were created!');
}
