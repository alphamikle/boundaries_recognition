import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';

import '../../../utils/bench.dart';
import '../../../utils/dataset.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/sleep.dart';
import '../../../utils/types.dart';
import '../model/image_result.dart';
import '../model/test_image.dart';
import 'edges_state.dart';

class EdgesBloc extends Cubit<EdgesState> {
  EdgesBloc({
    required EdgeVision edgeVision,
  })  : _edgeVision = edgeVision,
        super(EdgesState.initial());

  final EdgeVision _edgeVision;
  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

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
        blurRadius: 1,
        sobelLevel: 1,
        sobelAmount: 1,
        blackWhiteThreshold: 125,
        skewnessThreshold: 0.15,
        directionAngleLevel: 5,
        symmetricAngleThreshold: 0.1,
        minObjectSize: 40,
        searchMatrixSize: 3,
        areaThreshold: 0.35,
        luminanceThreshold: 1.05,
        maxImageSize: 300,
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
      final ByteData bytes = await rootBundle.load(filePath);
      image = bytes.buffer.asUint8List();
    } else {
      image = await File(filePath).readAsBytes();
    }

    final ImageResult imageResult = ImageResult.fromOriginalImage(
      name: filePath,
      originalImage: image,
      decodedImage: decodeJpg(image)!,
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
    final RegExp imageRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');

    final int size = 1 == 1 ? 4 : dataset.length;
    final List<String> firstNthImages = dataset.getRange(0, size).toList();

    int i = 0;
    final int total = firstNthImages.length;

    final List<double> cpuTime = [];

    for (final String image in firstNthImages) {
      i++;

      final RegExpMatch? match = imageRegExp.firstMatch(image);
      if (match == null) {
        dev.log('Image $image has wrong name');
        continue;
      }
      final TestImage testImage = TestImage(
        index: int.parse(match.namedGroup('index')!),
        size: match.namedGroup('size')!,
        card: match.namedGroup('card')!,
        background: match.namedGroup('background')!,
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

      await sleep(10);
    }

    final double sum = cpuTime.fold(0, (double sum, double it) => sum + it);
    final double avg = sum / cpuTime.length;

    dev.log('Total processing time for $total images = ${sum}ms and average time = ${avg}ms');
  }

  Future<void> applySettings(ValueChanger<EdgeVisionSettings> emitter) async {
    final EdgeVisionSettings? selectedSettings = state.selectedSettings;
    final int? settingsIndex = state.settingsIndex;

    if (selectedSettings == null || settingsIndex == null) {
      return;
    }

    final EdgeVisionSettings newSettings = emitter(selectedSettings);
    final List<EdgeVisionSettings> allSettings = [...state.settings];
    allSettings[settingsIndex] = newSettings;

    emit(
      state.copyWith(
        settings: allSettings,
      ),
    );

    dev.log(newSettings.toString());

    await _applyFilters();
  }

  Future<void> _applyFilters() async {
    emit(state.copyWith(processing: true));

    await Debouncer.run(
      'filters_apply',
      delay: const Duration(seconds: 1),
      () async {
        for (final MapEntry(:key, :value) in state.images.entries) {
          start('Image "key"');
          _applyFiltersToImage(key, value);
          stop('Image "key"');
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }

        emit(state.copyWith(processing: false));
      },
    );
  }

  void _applyFiltersToImage(String filename, ImageResult imageResult) {
    final bool selected = state.selectedImages.isEmpty || state.selectedImages.contains(imageResult.name);

    if (selected == false) {
      return;
    }

    _edgeVision.updateConfiguration(settings: state.settings.toSet());

    final Image image = imageResult.decodedImage.clone();
    late Image preparedImage;

    final Edges edges = _edgeVision.findImageEdges(image: image, onImagePrepare: (Image it) => preparedImage = it);

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
