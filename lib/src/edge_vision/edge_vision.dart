import 'dart:async';

import 'package:image/image.dart' as i;

import 'default_settings.dart';
import 'edge_vision_functions.dart';
import 'edge_vision_isolated.dart';
import 'edge_vision_settings.dart';
import 'edges.dart';

typedef OnImagePrepare = void Function(i.Image image);

enum EdgeVisionLogLevel {
  all,
  preparing,
  recognition,
  nothing;

  bool get logRecognition => this == EdgeVisionLogLevel.all || this == EdgeVisionLogLevel.recognition;
  bool get logPreparing => this == EdgeVisionLogLevel.all || this == EdgeVisionLogLevel.preparing;
}

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

  static Future<EdgeVision> isolated({Set<EdgeVisionSettings>? settings, EdgeProcessingMode processingMode = EdgeProcessingMode.oneByOne}) async {
    final EdgeVisionIsolated edgeVision = EdgeVisionIsolated();
    await edgeVision.init(settings: settings);
    return edgeVision;
  }

  final List<EdgeVisionSettings> _settings;

  EdgeVisionSettings? _bestSettings;
  int _settingsIndex = 0;
  EdgeProcessingMode _processingMode;

  static EdgeVisionLogLevel logLevel = EdgeVisionLogLevel.all;

  FutureOr<void> updateConfiguration({
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

  FutureOr<Edges> findImageEdges({
    required i.Image image,
    bool isImagePrepared = false,
    OnImagePrepare? onImagePrepare,
  }) {
    if (_processingMode.isAllInOne) {
      late Edges lastRecognizedEdges;
      for (final EdgeVisionSettings settings in _settings) {
        lastRecognizedEdges = _findImageEdgesWithSettings(
          image: image,
          settings: settings,
          isImagePrepared: isImagePrepared,
          onImagePrepare: onImagePrepare,
        );
        if (lastRecognizedEdges.corners.isNotEmpty) {
          return lastRecognizedEdges;
        }
      }
      return lastRecognizedEdges;
    }
    final EdgeVisionSettings settings = _pickSettings();
    final Edges edges = _findImageEdgesWithSettings(
      image: image,
      settings: settings,
      isImagePrepared: isImagePrepared,
      onImagePrepare: onImagePrepare,
    );
    if (edges.unrecognizedReason != null || edges.corners.isEmpty) {
      _bestSettings = null;
      _shiftSettings();
    } else {
      _bestSettings = settings;
    }
    return edges;
  }

  FutureOr<void> resetSettings() {
    _settingsIndex = 0;
    _bestSettings = null;
  }

  FutureOr<void> dispose() {}

  Edges _findImageEdgesWithSettings({
    required i.Image image,
    required EdgeVisionSettings settings,
    bool isImagePrepared = false,
    OnImagePrepare? onImagePrepare,
  }) {
    final i.Image preparedImage;
    if (isImagePrepared) {
      preparedImage = image;
    } else {
      // ignore: discarded_futures
      preparedImage = _prepareImage(image: image) as i.Image;
      onImagePrepare?.call(preparedImage);
    }

    return findImageEdgesSync(image: preparedImage, settings: settings, originalImageWidth: image.width, originalImageHeight: image.height);
  }

  FutureOr<i.Image> _prepareImage({required i.Image image}) => prepareImageSync(image: image, settings: _pickSettings());

  EdgeVisionSettings _pickSettings() {
    if (_settings.length == 1) {
      return _settings.first;
    }

    return _bestSettings ?? _settings[_settingsIndex];
  }

  void _shiftSettings() {
    if (_bestSettings != null) {
      return;
    }

    _settingsIndex++;
    if (_settingsIndex == _settings.length) {
      _settingsIndex = 0;
    }
  }
}
