import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io' show File;
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:edge_vision/edge_vision.dart';
import 'package:image/image.dart';
import 'package:isolator/isolator.dart';

import '../../../utils/bench.dart';
import '../../../utils/dataset.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/image_params_extractor.dart';
import '../../../utils/processor.dart';
import '../../../utils/throttle.dart';
import '../../../utils/types.dart';
import '../model/image_result.dart';
import '../model/test_image.dart';
import 'edges_state.dart';
import 'events.dart';

const int _threads = 3;

class EdgesBackend extends Backend {
  EdgesBackend({
    required super.argument,
  }) {
    initActions();
  }

  final Map<String, Completer<Uint8List>> _rootBundleCompleters = {};

  static EdgesBackend isolate(BackendArgument<void> argument) => EdgesBackend(argument: argument);

  late final EdgeVision edgeVision;

  EdgesState state = EdgesState.initial();

  Future<void> pickImage() async => throw UnimplementedError();

  Future<void> togglePainter() async => emit(state.copyWith(painterOn: !state.painterOn));

  Future<void> toggleDotsCloud() async => emit(state.copyWith(dotsCloudOn: !state.dotsCloudOn));

  Future<void> chooseSettingsAsActive(int settingsIndex) async {
    emit(state.copyWith(settingsIndex: settingsIndex));
    await _applyFilters();
  }

  Future<void> addNewSettings() async {
    final List<EdgeVisionSettings> settings = [...state.settings];
    settings.add(
      EdgeVisionSettings(
        blurRadius: 3,
        sobelLevel: 1,
        sobelAmount: 1,
        blackWhiteThreshold: 130,
        skewnessThreshold: 0.15,
        directionAngleLevel: 10,
        symmetricAngleThreshold: 0.1,
        minObjectSize: 40,
        searchMatrixSize: 3,
        areaThreshold: 0.35,
        luminanceThreshold: 1.05,
        maxImageSize: 300,
        grayscaleLevel: 0,
        grayscaleAmount: 0,
      ),
    );

    emit(
      state.copyWith(
        settings: settings,
        settingsIndex: settings.length - 1,
      ),
    );

    await _applyFilters();
  }

  Future<void> removeSelectedSettings() async {
    int? settingsIndex = state.settingsIndex;

    if (state.settings.length <= 1 || settingsIndex == null) {
      return;
    }

    final List<EdgeVisionSettings> settings = [...state.settings];
    settings.removeAt(settingsIndex);

    settingsIndex = settingsIndex.clamp(0, settings.length - 1);

    emit(
      state.copyWith(
        settings: settings,
        settingsIndex: settingsIndex,
      ),
    );

    await _applyFilters();
  }

  void toggleImageSelection(String filePath) {
    final Set<String> selectedImages = {...state.selectedImages};
    if (selectedImages.contains(filePath)) {
      selectedImages.remove(filePath);
    } else {
      selectedImages.add(filePath);
    }

    emit(
      state.copyWith(
        selectedImages: selectedImages,
      ),
    );
  }

  void updateOpacity(double opacity) => emit(state.copyWith(opacity: opacity));

  Future<void> loadImage(String filePath) async {
    if (state.images.containsKey(filePath)) {
      return;
    }

    final Uint8List image;

    if (filePath.contains('assets')) {
      DartPluginRegistrant.ensureInitialized();
      image = await _loadFileWithRootBundle(filePath);
    } else {
      image = await File(filePath).readAsBytes();
    }

    final Image decodedImage = decodeJpg(image)!.cropByAspectRatio(3 / 4);

    final ImageResult imageResult = ImageResult.fromOriginalImage(
      name: filePath,
      originalImage: image,
      decodedImage: decodedImage,
      originalImageWidth: decodedImage.width,
      originalImageHeight: decodedImage.height,
    );

    emit(
      state.copyWith(
        images: {
          ...state.images,
          filePath: imageResult,
        },
        imagesList: [...state.imagesList, imageResult],
      ),
    );

    await _applyFilters();
  }

  Future<void> loadImages() async {
    if (state.settings.isEmpty) {
      emit(
        state.copyWith(
          settings: defaultSettings.toList(),
          settingsIndex: 0,
        ),
      );
    }

    final int size = 1 == 0 ? 10 : dataset.length;
    // final List<String> firstNthImages = dataset.where((String it) => it.contains('dark_dark')).toList();
    final List<String> firstNthImages = dataset.getRange(0, size).toList();

    int i = 0;
    final int total = firstNthImages.length;

    final List<double> cpuTime = [];

    await processByChunks<String, void>(
      firstNthImages,
      _threads,
      (List<String> chunk) async {
        i += chunk.length;

        await Future.wait(
          chunk.map(
            (String image) async {
              final ImageParams imageParams = extractImageParams(image);

              final TestImage testImage = TestImage(
                index: int.parse(imageParams.index),
                size: imageParams.size,
                card: imageParams.card,
                background: imageParams.background,
                fullPath: image,
              );

              emit(
                state.copyWith(
                  testImages: {
                    ...state.testImages,
                    image: testImage,
                  },
                ),
              );

              start('image $i');
              await loadImage(image);
              final double result = stop('image $i', silent: true);
              cpuTime.add(result);

              dev.log('Processed: $i / $total image in ${result}ms');

              return null;
            },
          ),
        );

        return [];
      },
    );

    final double sum = cpuTime.fold(0, (double sum, double it) => sum + it);
    final double avg = sum / cpuTime.length;

    dev.log('Total processing time for $total images = ${sum}ms and average time = ${avg}ms');
  }

  Future<void> applySettings((int index, EdgeVisionSettings newSettings) argument) async {
    final List<EdgeVisionSettings> allSettings = [...state.settings];
    allSettings[argument.$1] = argument.$2;

    emit(
      state.copyWith(
        settings: allSettings,
      ),
    );

    dev.log(argument.$2.toString());

    await _applyFilters();
  }

  Future<void> init() async {
    edgeVision = await EdgeVision.isolated(threads: _threads);
  }

  @override
  void initActions() {
    whenEventCome(Events.init).runVoid(init);
    whenEventCome(Events.togglePainter).runVoid(togglePainter);
    whenEventCome(Events.toggleCloud).runVoid(toggleDotsCloud);
    whenEventCome(Events.selectActiveSettings).runSimple(chooseSettingsAsActive);
    whenEventCome(Events.addNewSettings).runVoid(addNewSettings);
    whenEventCome(Events.removeSelectedSettings).runVoid(removeSelectedSettings);
    whenEventCome(Events.toggleImageSelection).runSimple(toggleImageSelection);
    whenEventCome(Events.updateOpacity).runSimple(updateOpacity);
    whenEventCome(Events.loadImage).runSimple(loadImage);
    whenEventCome(Events.loadImages).runVoid(loadImages);
    whenEventCome(Events.applySettings).runSimple(applySettings);
    whenEventCome<RootBundleEvent>().run(_rootBundleReceiver);
  }

  void emit(EdgesState state) {
    this.state = state;

    unawaited(
      Throttle.run(
        'emit',
        delay: const Duration(milliseconds: 100),
        () async => send(event: Events.emit, data: state),
      ),
    );
  }

  Future<void> _applyFilters() async {
    emit(state.copyWith(processing: true));

    if (false) {
      await Debouncer.run(
        'filters_apply',
        delay: const Duration(seconds: 1),
        () async {
          final List<MapEntry<String, ImageResult>> images = state.images.entries.toList();

          await processByChunks(images, _threads, (List<MapEntry<String, ImageResult>> chunk) async {
            await Future.wait(
              chunk.map(
                (MapEntry<String, ImageResult> entry) async {
                  final String filePath = entry.key;

                  start('Applying filters to image [$filePath]');
                  await _applyFiltersToImage(filePath, entry.value);
                  stop('Applying filters to image [$filePath]');
                },
              ),
            );
            return [];
          });
        },
      );

      emit(state.copyWith(processing: false));
    } else {
      await Debouncer.run(
        'filters_apply',
        delay: const Duration(seconds: 1),
        () async {
          for (final MapEntry(:key, :value) in state.images.entries) {
            start('Image "key"');
            await _applyFiltersToImage(key, value);
            stop('Image "key"');
          }

          emit(state.copyWith(processing: false));
        },
      );
    }
  }

  Future<Uint8List> _loadFileWithRootBundle(String filePath) async {
    final Completer<Uint8List> completer = Completer();
    _rootBundleCompleters[filePath] = completer;
    await send(event: RootBundleEvent(filePath), data: filePath);
    return completer.future;
  }

  void _rootBundleReceiver({
    required RootBundleEvent event,
    required TransferableTypedData data,
  }) {
    final String filePath = event.filePath;
    final Completer<Uint8List>? completer = _rootBundleCompleters[filePath];
    if (completer == null) {
      throw Exception('Not found a completer for file [$filePath]');
    }
    completer.complete(data.materialize().asUint8List());
  }

  Future<void> _applyFiltersToImage(String filename, ImageResult imageResult) async {
    final bool selected = state.selectedImages.isEmpty || state.selectedImages.contains(imageResult.name);

    if (selected == false) {
      return;
    }

    await edgeVision.updateConfiguration(settings: state.settings.toSet());

    final Image image = imageResult.decodedImage.clone();
    late Image preparedImage;

    final Edges edges = await edgeVision.findImageEdges(image: image, onImagePrepare: (Image it) => preparedImage = it);

    _updateFilteredImage(
      filename,
      (ImageResult value) => value.copyWith(
        processedImage: encodeJpg(preparedImage),
        edges: edges,
        processedImageHeight: preparedImage.height,
        processedImageWidth: preparedImage.width,
      ),
    );
  }

  void _updateFilteredImage(String filename, ValueChanger<ImageResult> emitter) {
    final ImageResult? oldImageResult = state.images[filename];

    if (oldImageResult == null) {
      return;
    }

    final ImageResult imageResult = emitter(oldImageResult);
    final List<ImageResult> imagesList = [...state.imagesList];

    final int index = imagesList.indexWhere((ImageResult element) => element.name == filename);

    if (index >= 0) {
      imagesList[index] = imageResult;
    }

    emit(
      state.copyWith(
        images: {
          ...state.images,
          filename: imageResult,
        },
        imagesList: imagesList,
      ),
    );
  }
}
