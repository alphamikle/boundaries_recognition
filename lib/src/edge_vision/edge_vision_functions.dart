import 'dart:math' show Point, max;

import 'package:image/image.dart' show Image, Pixel, gaussianBlur, sobel;

import '../../edge_vision.dart';
import '../tools/bench.dart';
import '../tools/distortion.dart';
import '../tools/math.dart';
import '../tools/pixel_extensions.dart';
import '../tools/point_extensions.dart';

void _p1(String id) {
  if (EdgeVision.logLevel.logPreparing) {
    start('[EDGE VISION] $id');
  }
}

void _p2(String id) {
  if (EdgeVision.logLevel.logPreparing) {
    stop('[EDGE VISION] $id');
  }
}

void _f1(String id) {
  if (EdgeVision.logLevel.logRecognition) {
    start('[EDGE VISION] $id');
  }
}

void _f2(String id) {
  if (EdgeVision.logLevel.logRecognition) {
    stop('[EDGE VISION] $id');
  }
}

Edges findImageEdgesSync({
  required Image image,
  required EdgeVisionSettings settings,
}) {
  final EdgeVisionSettings(
    :searchMatrixSize,
    :minObjectSize,
    :directionAngleLevel,
    :skewnessThreshold,
    :areaThreshold,
    :symmetricAngleThreshold,
    returnInvalidData: returnInvalid,
  ) = settings;

  final int width = image.width;
  final int height = image.height;
  final bool noInvalidData = returnInvalid == false;

  List<Point<int>> allPoints = [];

  /// List of amount of dots per object
  final List<int> recognizedObjects = [];

  final List<List<bool>> visited = List.generate(
    image.height,
    (_) => List.generate(image.width, (_) => false),
  );

  final List<Point<int>> directions = [];

  for (int x = -searchMatrixSize; x < searchMatrixSize; x++) {
    for (int y = -searchMatrixSize; y < searchMatrixSize; y++) {
      directions.add(Point(x, y));
    }
  }

  List<Point<int>> findPathPoints(int startX, int startY) {
    final List<Point<int>> points = [];
    final List<Point<int>> currentPath = [Point(startX, startY)];
    const int takeEveryNth = 4;
    int counter = 0;

    while (currentPath.isNotEmpty) {
      final Point<int> point = currentPath.removeLast();
      final int x = point.x;
      final int y = point.y;

      // Determine not only on the black surfaces
      if (point.isInRectangle(width, height) == false || visited[y][x] || image.getPixel(x, y).isBlack) {
        continue;
      }

      visited[y][x] = true;

      if (counter % takeEveryNth == 0) {
        points.add(point);
      }

      counter++;

      for (final Point<int> direction in directions) {
        final int newX = x + direction.x;
        final int newY = y + direction.y;

        if ((x: newX, y: newY).isInRectangle(width, height) && visited[newY][newX] == false) {
          currentPath.add(Point(newX, newY));
        }
      }
    }

    if (points.length >= minObjectSize) {
      return points;
    } else {
      return [];
    }
  }

  _f1('Finding all points');
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final Pixel pixel = image.getPixel(x, y);
      final bool isPixelWhite = pixel.isWhite;
      final bool canBeVisited = visited[y][x] == false;

      if (canBeVisited && isPixelWhite) {
        final List<Point<int>> points = findPathPoints(x, y);

        if (points.length > allPoints.length) {
          allPoints = points;
        }

        if (points.isNotEmpty) {
          recognizedObjects.add(points.length);
        }
      }
    }
  }
  _f2('Finding all points');

  bool leftTopFound = false;
  bool rightTopFound = false;
  bool rightBottomFound = false;
  bool leftBottomFound = false;

  Point<int> leftTop = Point(width, 0);
  Point<int> rightTop = Point(0, height);
  Point<int> rightBottom = const Point(0, 0);
  Point<int> leftBottom = const Point(0, 0);

  _f1('Finding corner points');
  for (final Point<int> point in allPoints) {
    if (point.ltSum < leftTop.ltSum) {
      leftTop = point;
      leftTopFound = true;
    } else if (point.rtSum > rightTop.rtSum) {
      rightTop = point;
      rightTopFound = true;
    } else if (point.rbSum > rightBottom.rbSum) {
      rightBottom = point;
      rightBottomFound = true;
    } else if (point.lbSum > leftBottom.lbSum) {
      leftBottom = point;
      leftBottomFound = true;
    }
  }

  final bool cornersFound = leftTopFound && rightTopFound && rightBottomFound && leftBottomFound;

  if (noInvalidData && cornersFound == false) {
    _f2('Finding corner points');
    return Edges.empty().copyWith(unrecognizedReason: UnrecognizedReason.noCorners);
  }

  final List<Point<int>> corners = [leftTop, rightTop, rightBottom, leftBottom]..sort((a, b) => a.x.compareTo(b.x));
  final List<Point<int>> leftCorners = [corners[0], corners[1]]..sort((a, b) => a.y.compareTo(b.y));
  final List<Point<int>> rightCorners = [corners[2], corners[3]]..sort((a, b) => a.y.compareTo(b.y));

  leftTop = leftCorners[0];
  leftBottom = leftCorners[1];
  rightTop = rightCorners[0];
  rightBottom = rightCorners[1];
  _f2('Finding corner points');

  _f1('Calculating limits');
  final double topLength = distance(leftTop, rightTop);
  final double rightLength = distance(rightTop, rightBottom);
  final double bottomLength = distance(rightBottom, leftBottom);
  final double leftLength = distance(leftBottom, leftTop);

  bool wrongFigure = false;

  if (cornersFound) {
    if (percentageDifference(topLength, bottomLength) > skewnessThreshold) {
      wrongFigure = true;
    } else if (percentageDifference(rightLength, leftLength) > skewnessThreshold) {
      wrongFigure = true;
    }
  }

  if (noInvalidData && wrongFigure) {
    _f2('Calculating limits');
    return Edges.empty().copyWith(unrecognizedReason: UnrecognizedReason.exceededSkewnessThreshold);
  }

  // TODO(alphamikle): Incorrect angles
  final double leftTopAngle = angle(leftBottom, leftTop, rightTop);
  final double rightTopAngle = angle(leftTop, rightTop, rightBottom);
  final double rightBottomAngle = angle(rightTop, rightBottom, leftBottom);
  final double leftBottomAngle = angle(rightBottom, leftBottom, leftTop);

  bool hasWrongAngles({bool tryFix = true}) {
    final bool isLeftTopAndRightBottomSimilar = percentageDifference(leftTopAngle, rightBottomAngle) <= symmetricAngleThreshold;
    final bool isRightTopAndLeftBottomSimilar = percentageDifference(rightTopAngle, leftBottomAngle) <= symmetricAngleThreshold;
    final bool isLeftTopAndRightTopSimilar = percentageDifference(leftTopAngle, rightTopAngle) <= symmetricAngleThreshold;
    final bool isLeftBottomAndRightBottomSimilar = percentageDifference(leftBottomAngle, rightBottomAngle) <= symmetricAngleThreshold;
    final bool isLeftTopAndLeftBottomSimilar = percentageDifference(leftTopAngle, leftBottomAngle) <= symmetricAngleThreshold;
    final bool isRightTopAndRightBottomSimilar = percentageDifference(rightTopAngle, rightBottomAngle) <= symmetricAngleThreshold;

    bool isWrongAngles = true;

    if (isLeftTopAndRightBottomSimilar && isRightTopAndLeftBottomSimilar) {
      isWrongAngles = false;
    } else if (isLeftTopAndRightTopSimilar && isLeftBottomAndRightBottomSimilar) {
      isWrongAngles = false;
    } else if (isLeftTopAndLeftBottomSimilar && isRightTopAndRightBottomSimilar) {
      isWrongAngles = false;
    }

    if (tryFix && isWrongAngles) {
      // TODO(alphamikle): Fix sides lengths (later)
    }

    return isWrongAngles;
  }

  if (noInvalidData && hasWrongAngles()) {
    _f2('Calculating limits');
    return Edges.empty().copyWith(unrecognizedReason: UnrecognizedReason.exceededAngleThreshold);
  }

  final int objectSquare = square(leftTop, rightTop, rightBottom, leftBottom);
  final int imageSquare = width * height;
  final double relativeSquare = objectSquare / imageSquare;
  const double maxSquare = 1;

  if (noInvalidData && (relativeSquare < areaThreshold || relativeSquare > maxSquare)) {
    _f2('Calculating limits');
    return Edges.empty().copyWith(unrecognizedReason: UnrecognizedReason.tooSmallSquare);
  }

  final Distortion distortionLevel = distortion(
    topLeft: leftTopAngle,
    topRight: rightTopAngle,
    bottomLeft: leftBottomAngle,
    bottomRight: rightBottomAngle,
    threshold: directionAngleLevel,
  );

  _f2('Calculating limits');

  return Edges(
    leftTop: leftTop,
    rightTop: rightTop,
    rightBottom: rightBottom,
    leftBottom: leftBottom,
    leftLength: leftLength,
    topLength: topLength,
    rightLength: rightLength,
    bottomLength: bottomLength,
    leftTopAngle: leftTopAngle,
    rightTopAngle: rightTopAngle,
    rightBottomAngle: rightBottomAngle,
    leftBottomAngle: leftBottomAngle,
    relativeSquare: relativeSquare,
    square: objectSquare,
    allPoints: allPoints,
    xMoveTo: distortionLevel.x,
    yMoveTo: distortionLevel.y,
    recognizedObjects: recognizedObjects,
  );
}

Image prepareImageSync({
  required Image image,
  required EdgeVisionSettings settings,
}) {
  Image imageToProcess = image;

  final EdgeVisionSettings(
    :blackWhiteThreshold,
    :sobelLevel,
    :sobelAmount,
    :blurRadius,
    :luminanceThreshold,
    :maxImageSize,
  ) = settings;

  final int maxSize = max(image.width, image.height);

  if (maxSize > maxImageSize) {
    final double multiplier = maxImageSize / maxSize;
    final int width = (image.width * multiplier).toInt();
    final int height = (image.height * multiplier).toInt();

    _p1('Resizing image [${image.width}x${image.height}] => [${width}x$height]');
    imageToProcess = imageToProcess.resize(width, height, steps: 1);
    _p2('Resizing image [${image.width}x${image.height}] => [${width}x$height]');
  }

  _p1('Selecting best channel');
  imageToProcess = imageToProcess.withBestChannelOnly(luminanceThreshold);
  _p2('Selecting best channel');

  if (blurRadius > 0) {
    _p1('Applying blur');
    imageToProcess = gaussianBlur(imageToProcess, radius: blurRadius);
    _p2('Applying blur');
  }

  if (sobelLevel > 0) {
    if (sobelAmount == 1) {
      _p1('Applying sobel');
    } else {
      _p1('Applying sobel (total)');
    }
    for (int i = 0; i < sobelAmount; i++) {
      if (sobelAmount > 1) {
        _p1('Applying sobel $i / $sobelAmount');
      }
      imageToProcess = sobel(imageToProcess, amount: sobelLevel);
      if (sobelAmount > 1) {
        _p2('Applying sobel $i / $sobelAmount');
      }
    }
    if (sobelAmount == 1) {
      _p2('Applying sobel');
    } else {
      _p2('Applying sobel (total)');
    }
  }

  if (blackWhiteThreshold > 0 && blackWhiteThreshold < 255) {
    _p1('Applying black/white filter');
    imageToProcess = imageToProcess.toBlackWhite(blackWhiteThreshold);
    _p2('Applying black/white filter');
  }

  return imageToProcess;
}
