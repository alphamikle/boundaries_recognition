import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:isolator/isolator.dart';

import '../../edge_vision.dart';
import '../tools/bench.dart';
import 'edge_vision_backend.dart';

enum EdgeVisionEvents {
  findEdges,
  resetSettings,
  updateConfiguration,
  prepareImage,
}

class EdgeVisionIsolated with Frontend implements EdgeVision {
  Future<void> init({
    Set<EdgeVisionSettings>? settings,
    EdgeProcessingMode processingMode = EdgeProcessingMode.oneByOne,
  }) async {
    await initBackend(
      initializer: EdgeVisionBackend.isolate,
      data: (
        settings: settings ?? {averageSettings},
        processingMode: processingMode,
      ),
    );
  }

  final Map<String, OnImagePrepare> _prepareCallbacks = {};

  @override
  Future<Edges> findImageEdges({required Image image, bool isImagePrepared = false, OnImagePrepare? onImagePrepare}) async {
    final String? imagePrepareId = onImagePrepare == null ? null : Random().nextDouble().toString();
    if (imagePrepareId != null && onImagePrepare != null) {
      _prepareCallbacks[imagePrepareId] = onImagePrepare;
    }
    start('Creating argument');
    final FindEdgesArgument argument = (
      image: TransferableTypedData.fromList([image.buffer.asUint8List()]),
      isImagePrepared: isImagePrepared,
      imagePrepareId: imagePrepareId,
      width: image.width,
      height: image.height,
    );
    stop('Creating argument');

    start('Async Handling image');
    final Maybe<Edges?> result = await run(event: EdgeVisionEvents.findEdges, data: argument, timeout: const Duration(seconds: 5));
    stop('Async Handling image');
    if (result.hasValue == false) {
      throw Exception('Finding edges failed');
    }
    return result.value!;
  }

  @override
  Future<void> resetSettings() async {
    await run(event: EdgeVisionEvents.resetSettings);
  }

  @override
  Future<void> updateConfiguration({Set<EdgeVisionSettings>? settings, EdgeProcessingMode? processingMode}) async {
    final ConfigurationUpdateArgument argument = (settings: settings, processingMode: processingMode);
    await run(event: EdgeVisionEvents.updateConfiguration, data: argument);
  }

  @override
  Future<void> dispose() async {
    await destroy();
  }

  @override
  void initActions() {
    whenEventCome(EdgeVisionEvents.prepareImage).runSimple(_handlePreparedImageCallback);
  }

  void _handlePreparedImageCallback(PrepareImageArgument argument) {
    final String id = argument.id;
    final OnImagePrepare? callback = _prepareCallbacks[id];

    if (callback == null) {
      return;
    }

    _prepareCallbacks.remove(id);
    final int width = argument.width;
    final int height = argument.height;
    final ByteBuffer imageBytes = argument.image.materialize();
    final Image image = Image.fromBytes(width: width, height: height, bytes: imageBytes);
    callback(image);
  }
}
