import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/services.dart';
import 'package:isolator/isolator.dart';

import '../../../utils/throttle.dart';
import '../../../utils/types.dart';
import 'edges_backend.dart';
import 'edges_state.dart';
import 'events.dart';

class EdgesBloc extends Cubit<EdgesState> with Frontend {
  EdgesBloc() : super(EdgesState.initial());

  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

  Future<void> pickImage() async => throw UnimplementedError();

  Future<void> togglePainter() async => run(event: Events.togglePainter);

  Future<void> toggleDotsCloud() async => run(event: Events.toggleCloud);

  Future<void> chooseSettingsAsActive(int settingsIndex) async => run(event: Events.selectActiveSettings, data: settingsIndex);

  Future<void> addNewSettings() async => run(event: Events.addNewSettings);

  Future<void> removeSelectedSettings() async => run(event: Events.removeSelectedSettings);

  Future<void> toggleImageSelection(String filePath) async => run(event: Events.toggleImageSelection, data: filePath);

  Future<void> updateOpacity(double opacity) async => run(event: Events.updateOpacity, data: opacity);

  Future<void> loadImage(String filePath) async => run(event: Events.loadImage, data: filePath);

  Future<void> loadImages() async => run(event: Events.loadImages);

  Future<void> applySettings(ValueChanger<EdgeVisionSettings> emitter) async {
    final EdgeVisionSettings? selectedSettings = state.selectedSettings;
    final int? settingsIndex = state.settingsIndex;

    if (selectedSettings == null || settingsIndex == null) {
      return;
    }

    final EdgeVisionSettings newSettings = emitter(selectedSettings);

    await run(event: Events.applySettings, data: (settingsIndex, newSettings));
  }

  Future<void> init() async {
    initActions();
    await initBackend(initializer: EdgesBackend.isolate);
    await run(event: Events.init);
  }

  void _emit(EdgesState state) {
    unawaited(
      Throttle.run(
        'edges_bloc_emit',
        delay: const Duration(milliseconds: 100),
        () => emit(state),
      ),
    );
  }

  Future<void> _rootBundleLoader({
    required RootBundleEvent event,
    required String data,
  }) async {
    final ByteData fileData = await rootBundle.load(data);
    await run(event: event, data: TransferableTypedData.fromList([fileData.buffer.asUint8List()]));
  }

  @override
  void initActions() {
    whenEventCome(Events.emit).runSimple(_emit);
    whenEventCome<RootBundleEvent>().run(_rootBundleLoader);
  }
}
