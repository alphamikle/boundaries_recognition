import 'dart:convert';
import 'dart:io';

import 'package:boundaries_detector/src/utils/types.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';

import '../lib/src/utils/edge_settings_extensions.dart';

final Set<EdgeVisionSettings> uniqueSettings = {};

void main() {
  test('Find Unique Settings', () async {
    final Directory settingsDir = Directory(join(current, 'one_by_one_tests', 'settings'));
    final List<FileSystemEntity> files = settingsDir.listSync();

    int index = 0;

    for (final FileSystemEntity entity in files) {
      if (entity is File && entity.path.contains('settings')) {
        final String content = entity.readAsStringSync();
        final Json json = jsonDecode(content) as Json;
        final EdgeVisionSettings settings = EdgeVisionSettings.fromJson(json);
        if (uniqueSettings.contains(settings) == false) {
          uniqueSettings.add(settings);
        }
      }
    }

    index = 0;
    for (final EdgeVisionSettings settings in uniqueSettings) {
      index++;
      final String uniqueSettingsPath = join(current, 'one_by_one_tests', 'unique_settings', 'best_settings_$index.dart');
      final File uniqueSettingsFile = File(uniqueSettingsPath);
      if (uniqueSettingsFile.parent.existsSync() == false) {
        uniqueSettingsFile.parent.createSync(recursive: true);
      }
      uniqueSettingsFile.writeAsStringSync(settings.toCode('bestSettings$index'));
    }

    print('$index unique settings found!');
  });
}
