import 'package:image/image.dart' as i;

import '../tools/settings_extension.dart';
import 'default_settings.dart';
import 'edge_vision_functions.dart';
import 'edges.dart';
import 'settings.dart';

typedef OnImagePrepare = void Function(i.Image image);

enum EdgeProcessingMode {
  oneByOne,
  allInOne;

  bool get isOneByOne => this == EdgeProcessingMode.oneByOne;
  bool get isAllInOne => this == EdgeProcessingMode.allInOne;
}

class EdgeVision {
  factory EdgeVision({Set<EdgeVisionSettings>? settings, EdgeProcessingMode processingMode = EdgeProcessingMode.oneByOne}) {
    if (settings?.isEmpty ?? false) {
      throw ArgumentError('settings should not be empty or should be a null');
    }

    return EdgeVision._(
      settings: (settings ?? defaultSettings).toList(),
      processingMode: processingMode,
    );
  }

  EdgeVision._({required List<EdgeVisionSettings> settings, required EdgeProcessingMode processingMode})
      : _settings = settings,
        _processingMode = processingMode;

  final List<EdgeVisionSettings> _settings;

  EdgeVisionSettings? _bestSettings;
  int _settingsIndex = 0;
  EdgeProcessingMode _processingMode;

  void updateConfiguration({
    Set<EdgeVisionSettings>? settings,
    EdgeProcessingMode? processingMode,
  }) {
    if (settings != null) {
      if (settings.isEmpty) {
        throw ArgumentError('settings should not be empty or should be a null');
      }
      _settings.clear();
      _settings.addAll(settings);
      _bestSettings = null;
      _settingsIndex = 0;
    }
    if (processingMode != null) {
      _processingMode = processingMode;
    }
  }

  Edges findImageEdges({
    required i.Image image,
    bool isImagePrepared = false,
    OnImagePrepare? onImagePrepare,
  }) {
    late Edges results;
    bool needToIterateOverSettings = true;

    while (needToIterateOverSettings) {
      print('Trying [$_settingsIndex] settings');

      final EdgeVisionSettings settings = _pickSettings();
      i.Image preparedImage;

      if (isImagePrepared) {
        preparedImage = image.clone(noAnimation: true);
      } else {
        preparedImage = _prepareImage(image: image);
        onImagePrepare?.call(preparedImage);
      }

      results = findImageEdgesSync(image: preparedImage, settings: settings);

      if (results.corners.isEmpty) {
        _shiftSettings();
        if (_processingMode.isOneByOne || _bestSettings != null) {
          needToIterateOverSettings = false;
        }
      } else {
        _bestSettings = settings;
        needToIterateOverSettings = false;
      }
    }

    return results;
  }

  i.Image _prepareImage({
    required i.Image image,
  }) {
    final EdgeVisionSettings settings = _pickSettings();
    return prepareImageSync(image: image, settings: settings);
  }

  void resetSettings() {
    _settingsIndex = 0;
    _bestSettings = null;
  }

  EdgeVisionSettings _pickSettings() {
    return _bestSettings ?? _settings[_settingsIndex];
  }

  void _shiftSettings() {
    if (_bestSettings != null) {
      return;
    }

    _settingsIndex++;
    if (_settingsIndex >= _settings.length) {
      _settingsIndex = 0;
      _bestSettings = _settings.average();
    }
  }
}
