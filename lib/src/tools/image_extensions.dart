import 'package:image/image.dart' as i;

import 'histogram.dart';
import 'pixel_extensions.dart';

extension ExtendedImage on i.Image {
  // TODO(alphamikle): May be buggy
  /// Image converter to black and white only pixels
  i.Image toBlackWhite(int threshold) {
    final i.Image image = i.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i.Pixel pixel = getPixel(x, y);

        if (pixel.luminance > threshold) {
          image.setPixel(x, y, i.ColorInt8.rgb(255, 255, 255));
        } else {
          image.setPixel(x, y, i.ColorInt8.rgb(0, 0, 0));
        }
      }
    }
    return image;
  }

  bool isBackgroundDark({int borderWidth = 5, int threshold = 128, double limit = 0.5}) {
    int darkPixels = 0;
    int totalPixels = 0;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < borderWidth; y++) {
        if (getPixel(x, y).isDark(threshold)) {
          darkPixels++;
        }
        if (getPixel(x, height - 1 - y).isDark(threshold)) {
          darkPixels++;
        }
        totalPixels += 2;
      }
    }

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < borderWidth; x++) {
        if (getPixel(x, y).isDark(threshold)) {
          darkPixels++;
        }
        if (getPixel(width - 1 - x, y).isDark(threshold)) {
          darkPixels++;
        }
        totalPixels += 2;
      }
    }

    return darkPixels / totalPixels > limit;
  }

  i.Image resize(
    int width,
    int height, {
    int steps = 2,
    i.Interpolation interpolation = i.Interpolation.nearest,
  }) {
    i.Image resizedImage = this;

    final List<List<int>> intermediateSizes = _calculateIntermediateSizes(width, height, steps: steps);

    for (final [width, height] in intermediateSizes) {
      resizedImage = i.copyResize(resizedImage, width: width, height: height, interpolation: interpolation);
    }

    return resizedImage;
  }

  List<List<int>> _calculateIntermediateSizes(int newWidth, int newHeight, {int steps = 2}) {
    final List<List<int>> results = [];

    if (steps == 1) {
      return [
        [
          newWidth,
          newHeight,
        ]
      ];
    }

    final double widthStep = (newWidth - width) / steps;
    final double heightStep = (newHeight - height) / steps;

    for (int i = 1; i <= steps; i++) {
      final int intermediateWidth = (width + widthStep * i).round();
      final int intermediateHeight = (height + heightStep * i).round();
      results.add([intermediateWidth, intermediateHeight]);
    }

    return results;
  }

  List<i.Image> splitImageHorizontally(int piecesAmount) {
    if (piecesAmount < 1) {
      throw ArgumentError('piecesAmount > 1');
    }

    final int pieceHeight = (height / piecesAmount).floor();
    final List<i.Image> imagePieces = [];

    int y = 0;

    for (int index = 0; index < piecesAmount; index++) {
      final int currentPieceHeight = (index == piecesAmount - 1) ? height - y : pieceHeight;
      final i.Image imagePiece = i.copyCrop(this, x: 0, y: y, width: width, height: currentPieceHeight);
      imagePieces.add(imagePiece);
      y += currentPieceHeight;
    }
    return imagePieces;
  }

  Histogram histogram() {
    final List<int> red = List.filled(256, 0);
    final List<int> green = List.filled(256, 0);
    final List<int> blue = List.filled(256, 0);
    final List<int> luminance = List.filled(256, 0);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i.Pixel pixel = getPixel(x, y);
        final num r = pixel.r;
        final num g = pixel.g;
        final num b = pixel.b;
        final num l = pixel.luminance;

        red[r.toInt()]++;
        green[g.toInt()]++;
        blue[b.toInt()]++;
        luminance[l.toInt()]++;
      }
    }

    return Histogram((red: red, green: green, blue: blue, luminance: luminance));
  }

  i.Channel bestChannel(double luminanceThreshold) {
    final Histogram h = histogram();
    final LevelsHistogramsMeanAndVariance meanAndVariance = h.meanAndVariance();

    final double redVariance = meanAndVariance.red.variance;
    final double greenVariance = meanAndVariance.green.variance;
    final double blueVariance = meanAndVariance.blue.variance;
    final double luminanceVariance = meanAndVariance.luminance.variance;
    final double target = luminanceVariance * luminanceThreshold;

    if (redVariance > target) {
      return i.Channel.red;
    } else if (greenVariance > target) {
      return i.Channel.green;
    } else if (blueVariance > target) {
      return i.Channel.blue;
    }
    return i.Channel.luminance;
  }

  i.Image withBestChannelOnly(double luminanceThreshold) {
    final i.Channel channel = bestChannel(luminanceThreshold);

    if (channel == i.Channel.alpha) {
      return this;
    }

    final i.Image result = i.Image.from(this);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i.Pixel pixel = getPixel(x, y);

        final _ = switch (channel) {
          i.Channel.red => result.setPixelRgba(x, y, pixel.r, pixel.r, pixel.r, pixel.a),
          i.Channel.green => result.setPixelRgba(x, y, pixel.g, pixel.g, pixel.g, pixel.a),
          i.Channel.blue => result.setPixelRgba(x, y, pixel.b, pixel.b, pixel.b, pixel.a),
          i.Channel.luminance => result.setPixelRgba(x, y, pixel.luminance, pixel.luminance, pixel.luminance, pixel.a),
          i.Channel.alpha => null,
        };
      }
    }

    return result;
  }
}

extension ExtendedImagesList on List<i.Image> {
  i.Image combine() {
    if (isEmpty) {
      throw ArgumentError('List<Image> should not be empty');
    }

    final int width = first.width;
    final int height = fold(0, (int sum, i.Image image) => sum + image.height);

    i.Image combinedImage = i.Image(width: width, height: height);

    int yOffset = 0;

    for (final i.Image image in this) {
      combinedImage = i.compositeImage(combinedImage, image, dstX: 0, dstY: yOffset);
      yOffset += image.height;
    }
    return combinedImage;
  }
}
