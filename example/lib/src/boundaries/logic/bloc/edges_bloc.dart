import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';

import '../../../utils/bench.dart';
import '../../../utils/debouncer.dart';
import '../../../utils/sleep.dart';
import '../../../utils/types.dart';
import '../model/image_result.dart';
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

  Future<void> loadImage(String fileName) async {
    if (state.images.containsKey(fileName)) {
      return;
    }

    final ByteData bytes = await rootBundle.load('assets/$fileName.jpg');
    final Uint8List image = bytes.buffer.asUint8List();

    emit(
      state.copyWith(
        images: {
          ...state.images,
          fileName: ImageResult.fromOriginalImage(image),
        },
      ),
    );

    await _applyFilters();
  }

  Future<void> applySettings(ValueChanger<Settings> emitter) async {
    emit(
      state.copyWith(
        settings: emitter(state.settings),
      ),
    );
    await _applyFilters();
  }

  Future<void> _applyFilters() async {
    await Debouncer.run(
      'filters_apply',
      delay: const Duration(milliseconds: 250),
      () async {
        for (final MapEntry(:key, :value) in state.images.entries) {
          await _applyFiltersToImage(key, value);
          await sleep(250);
        }
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

    const String chain = 'Filters';
    String id(String name) => 'Image [$filename] with width = ${image.width}, height = ${image.height} $name applied in';

    if (resizeOn) {
      measure('resize', chain: chain, () {
        final int largeSize = max(image.width, image.height);
        if (largeSize >= maxImageSize) {
          final int smallSize = min(image.width, image.height);
          final int delimiter = largeSize ~/ maxImageSize;

          final int newLargeSize = maxImageSize;
          final int newSmallSize = smallSize ~/ delimiter;

          final bool isPortrait = image.height >= image.width;

          image = image.resize(isPortrait ? newSmallSize : newLargeSize, isPortrait ? newLargeSize : newSmallSize);
        }
      });
    }

    await sleep(50);

    final double aspectRatio = image.width / image.height;
    if (aspectRatio > 1) {
      measure('rotation', chain: chain, () {
        image = copyRotate(image, angle: 90);
      });
    }

    await sleep(50);

    if (grayScaleOn) {
      measure(id('grayscale filter'), chain: chain, () {
        image = grayscale(image, amount: grayscaleAmount);
      });
    }

    await sleep(50);

    if (blurOn) {
      measure(id('blur filter'), chain: chain, () {
        image = gaussianBlur(image, radius: blurRadius);
      });
    }

    await sleep(50);

    if (sobelOn) {
      measure(id('sobel filter'), chain: chain, () {
        image = sobel(image, amount: sobelAmount);
      });
    }

    await sleep(50);

    if (bwOn) {
      measure(id('black and white filter'), chain: chain, () {
        image = image.toBlackWhite(blackWhiteThreshold);
      });
    }

    await sleep(50);

    Edges? edges;

    await measure('finding edges', chain: chain, () async {
      edges = await _edgeVision.findImageEdges(
        image: image,
        settings: state.settings,
        threads: state.threads,
        preparedImage: true,
      );
    });

    measure('Applied', chain: chain, abortChain: true, () {});

    _updateFilteredImage(
      filename,
      (ImageResult value) => value.copyWith(
        processedImage: encodeJpg(image),
        edges: edges,
      ),
    );
  }

  void _updateFilteredImage(String filename, ValueChanger<ImageResult> emitter) {
    final ImageResult? oldFilteredImage = state.images[filename];
    if (oldFilteredImage == null) {
      return;
    }
    emit(
      state.copyWith(
        images: {
          ...state.images,
          filename: emitter(oldFilteredImage),
        },
      ),
    );
  }
}
