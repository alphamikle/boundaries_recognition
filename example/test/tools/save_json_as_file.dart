import 'dart:convert';
import 'dart:io';

Future<void> saveJsonAsFile(Object json, String filePath) async {
  if (json is! Map && json is! List) {
    throw ArgumentError('json argument should be a List<Object> or Map<String, Object>');
  }

  final File file = File('$filePath.json');

  if (await file.exists()) {
    return;
  }

  final Directory directory = file.parent;

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  await file.writeAsString(JsonEncoder.withIndent('  ').convert(json));
}
