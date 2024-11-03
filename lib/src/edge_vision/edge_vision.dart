import 'package:image/image.dart' as i;

import '../tools/settings_extension.dart';
import 'default_settings.dart';
import 'edge_vision_functions.dart';
import 'edges.dart';
import 'settings.dart';

class EdgeVision {
  factory EdgeVision({Set<Settings>? settings}) {
    if (settings?.isEmpty ?? false) {
      throw ArgumentError('settings should not be empty or should be a null');
    }

    return EdgeVision._(settings: (settings ?? defaultSettings).toList());
  }

  EdgeVision._({
    required List<Settings> settings,
  }) : _settings = settings;

  final List<Settings> _settings;

  Settings? _averageSettings;
  int _settingsIndex = 0;

  Edges findImageEdges({
    required i.Image image,
    bool preparedImage = false,
  }) {
    final Settings settings = _pickSettings();

    if (preparedImage == false) {
      image = prepareImage(image: image);
    }

    final Edges results = findImageEdgesSync(image: image, settings: settings);

    if (results.corners.isEmpty) {
      _shiftSettings();
    }

    return results;
  }

  i.Image prepareImage({
    required i.Image image,
  }) {
    final Settings settings = _pickSettings();
    return prepareImageSync(image: image, settings: settings);
  }

  void resetSettings() {
    _settingsIndex = 0;
    _averageSettings = null;
  }

  Settings _pickSettings() {
    return _averageSettings ?? _settings[_settingsIndex];
  }

  void _shiftSettings() {
    if (_averageSettings != null) {
      return;
    }

    _settingsIndex++;
    if (_settingsIndex >= _settings.length) {
      _settingsIndex = 0;
      _averageSettings = _settings.average();
    }
  }
}
