import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

Future<void> saveImageAsFile(img.Image image, String filePath) async {
  final File file = File('$filePath.jpg');
  final Directory directory = file.parent;

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final Uint8List bytes = img.encodeJpg(image, quality: 40);

  await file.writeAsBytes(bytes);
}
