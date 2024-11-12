import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:isolator/isolator.dart';

import '../../edge_vision.dart';
import '../tools/bench.dart';
import 'edge_vision_isolated.dart';

typedef EdgeVisionBackendInitializationArgument = ({Set<EdgeVisionSettings>? settings, EdgeProcessingMode processingMode});
typedef FindEdgesArgument = ({TransferableTypedData image, int width, int height, bool isImagePrepared, String? imagePrepareId});
typedef PrepareImageArgument = ({String id, TransferableTypedData image, int width, int height});
typedef ConfigurationUpdateArgument = ({Set<EdgeVisionSettings>? settings, EdgeProcessingMode? processingMode});

class EdgeVisionBackend extends Backend {
  EdgeVisionBackend({
    required super.argument,
    required this.edgeVision,
  });

  factory EdgeVisionBackend.isolate(BackendArgument<EdgeVisionBackendInitializationArgument> argument) {
    return EdgeVisionBackend(
      argument: argument,
      edgeVision: EdgeVision(
        settings: argument.data?.settings,
        processingMode: argument.data?.processingMode ?? EdgeProcessingMode.oneByOne,
      ),
    );
  }

  final EdgeVision edgeVision;

  Future<Edges> findEdges(FindEdgesArgument argument) async {
    start('Materialization');
    final ByteBuffer imageBytes = argument.image.materialize();
    stop('Materialization');

    final int width = argument.width;
    final int height = argument.height;

    final bool isImagePrepared = argument.isImagePrepared;
    final String? imagePrepareId = argument.imagePrepareId;

    start('Creating image');
    final Image image = Image.fromBytes(width: width, height: height, bytes: imageBytes);
    stop('Creating image');

    start('Finding edges');
    final Edges edges = await edgeVision.findImageEdges(
      image: image,
      isImagePrepared: isImagePrepared,
      onImagePrepare: imagePrepareId == null ? null : (Image image) => onImagePrepare(imagePrepareId, image),
    );
    stop('Finding edges');
    return edges;
  }

  Future<void> updateConfiguration(ConfigurationUpdateArgument argument) async {
    await edgeVision.updateConfiguration(settings: argument.settings, processingMode: argument.processingMode);
  }

  Future<void> resetSettings() async {
    await edgeVision.resetSettings();
  }

  Future<void> onImagePrepare(String id, Image image) async {
    final PrepareImageArgument argument = (
      id: id,
      image: TransferableTypedData.fromList([image.buffer.asUint8List()]),
      width: image.width,
      height: image.height,
    );
    await send(event: EdgeVisionEvents.prepareImage, data: argument, sendDirectly: true);
  }

  @override
  void initActions() {
    whenEventCome(EdgeVisionEvents.findEdges).runSimple(findEdges);
    whenEventCome(EdgeVisionEvents.updateConfiguration).runSimple(updateConfiguration);
    whenEventCome(EdgeVisionEvents.resetSettings).runVoid(resetSettings);
  }
}
