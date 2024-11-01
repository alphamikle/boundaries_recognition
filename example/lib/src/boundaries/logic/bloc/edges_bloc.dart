import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';

import '../../../utils/bench.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/images.dart';
import '../../../utils/types.dart';
import '../model/image_result.dart';
import '../model/test_image.dart';
import 'edges_state.dart';

/*
Pretty good results without isles
GA: 1.00 / 1.25 for light background and 6.25 for dark
SA: 1.25
C-TH: 150
S-TH: 3
Size: 40
Angle: 5.00
P-TH: 0.26
 */

class EdgesBloc extends Cubit<EdgesState> {
  EdgesBloc({
    required EdgeVision edgeVision,
  })  : _edgeVision = edgeVision,
        super(EdgesState.initial());

  final EdgeVision _edgeVision;
  CameraController? _cameraController;

  CameraController? get cameraController => _cameraController;

  Future<void> pickImage() async {
    // TODO(alphamikle):
  }

  Future<void> togglePainter() async {
    emit(state.copyWith(painterOn: !state.painterOn));
    await _applyFilters();
  }

  Future<void> toggleDotsCloud() async {
    emit(state.copyWith(dotsCloudOn: !state.dotsCloudOn));
    await _applyFilters();
  }

  Future<void> toggleGrayscale() async {
    emit(state.copyWith(grayScaleOn: !state.grayScaleOn));
    await _applyFilters();
  }

  Future<void> toggleBlur() async {
    emit(state.copyWith(blurOn: !state.blurOn));
    await _applyFilters();
  }

  Future<void> toggleResize() async {
    emit(state.copyWith(resizeOn: !state.resizeOn));
    await _applyFilters();
  }

  Future<void> toggleSobel() async {
    emit(state.copyWith(sobelOn: !state.sobelOn));
    await _applyFilters();
  }

  Future<void> toggleBlackWhite() async {
    emit(state.copyWith(bwOn: !state.bwOn));
    await _applyFilters();
  }

  Future<void> toggleDarkSettings() async {
    emit(state.copyWith(darkSettingsOn: !state.darkSettingsOn));
    await _applyFilters();
  }

  void updateOpacity(double opacity) => emit(state.copyWith(opacity: opacity));

  Future<void> loadImage(String filePath) async {
    if (state.images.containsKey(filePath)) {
      return;
    }

    final ByteData bytes = await rootBundle.load(filePath);
    final Uint8List image = bytes.buffer.asUint8List();
    final ImageResult imageResult = ImageResult.fromOriginalImage(filePath, image);

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
    final RegExp imageRegExp = RegExp(r'(?<size>\d+x\d+)/(?<card>[a-z]+)_(?<background>[a-z]+)_(?<index>\d+)\.jpg$');

    final int size = false ? 16 : images.length;
    final List<String> firstNthImages = images.getRange(0, size).toList();

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
    }

    final double sum = cpuTime.fold(0, (double sum, double it) => sum + it);
    final double avg = sum / cpuTime.length;

    dev.log('Total processing time for $total images = ${sum}ms and average time = ${avg}ms');
  }

  Future<void> applySettings(ValueChanger<Settings> emitter) async {
    final bool isDark = state.darkSettingsOn;

    final Settings settings = emitter(state.settings);

    if (isDark) {
      emit(
        state.copyWith(
          darkSettings: settings,
        ),
      );
    } else {
      emit(
        state.copyWith(
          lightSettings: settings,
        ),
      );
    }

    dev.log(settings.toString());

    await _applyFilters();
  }

  Future<void> _applyFilters() async {
    await Debouncer.run(
      'filters_apply',
      delay: const Duration(seconds: 3),
      () async {
        emit(state.copyWith(processing: true));
        for (final MapEntry(:key, :value) in state.images.entries) {
          await _applyFiltersToImage(key, value);
        }
        emit(state.copyWith(processing: false));
      },
    );
  }

  Future<void> _applyFiltersToImage(String filename, ImageResult imageResult) async {
    final EdgesState(
      :maxImageSize,
      :threads,
      :grayScaleOn,
      :blurOn,
      :resizeOn,
      :sobelOn,
      :bwOn,
      :dotsCloudOn,
      :painterOn,
    ) = state;

    final Settings(
      :searchMatrixSize,
      :minObjectSize,
      :distortionAngleThreshold,
      :skewnessThreshold,
      :blackWhiteThreshold,
      :grayscaleAmount,
      :sobelAmount,
      :blurRadius,
    ) = state.settings;

    Image image = decodeJpg(imageResult.originalImage)!;

    // const String chain = 'Filters';
    // String id(String name) => '[$filename|${image.width}x${image.height}] => $name consumed ';

    if (resizeOn) {
      // measure(id('resize'), chain: chain, () {
      // });
      final int largeSize = max(image.width, image.height);
      if (largeSize >= maxImageSize) {
        final int smallSize = min(image.width, image.height);
        final int delimiter = largeSize ~/ maxImageSize;

        final int newLargeSize = maxImageSize;
        final int newSmallSize = smallSize ~/ delimiter;

        final bool isPortrait = image.height >= image.width;

        image = image.resize(isPortrait ? newSmallSize : newLargeSize, isPortrait ? newLargeSize : newSmallSize);
      }
    }

    final double aspectRatio = image.width / image.height;
    if (aspectRatio > 1) {
      // measure(id('rotation'), chain: chain, () {
      // });
      image = copyRotate(image, angle: 90);
    }

    if (grayScaleOn) {
      // measure(id('grayscale filter'), chain: chain, () {
      // });
      image = grayscale(image, amount: grayscaleAmount);
    }

    if (blurOn) {
      // measure(id('blur filter'), chain: chain, () {
      // });
      image = gaussianBlur(image, radius: blurRadius);
    }

    if (sobelOn) {
      // measure(id('sobel filter'), chain: chain, () {
      // });
      image = sobel(image, amount: sobelAmount);
    }

    if (bwOn) {
      // measure(id('black and white filter'), chain: chain, () {
      // });
      image = image.toBlackWhite(blackWhiteThreshold);
    }

    Edges? edges;

    // await measure(id('finding edges'), chain: chain, () async {
    // });
    edges = await _edgeVision.findImageEdges(
      image: image,
      settings: state.settings,
      threads: state.threads,
      preparedImage: true,
    );

    // measure(id('Total'), chain: chain, abortChain: true, () {});

    _updateFilteredImage(
      filename,
      (ImageResult value) => value.copyWith(
        processedImage: encodeJpg(image),
        edges: edges,
        processedImageHeight: image.height,
        processedImageWidth: image.width,
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
