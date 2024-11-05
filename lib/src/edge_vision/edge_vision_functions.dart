import 'dart:math' show Point;

import 'package:image/image.dart' show Image, Pixel, gaussianBlur, sobel;

import '../../edge_vision.dart';
import '../tools/distortion.dart';
import '../tools/math.dart';
import '../tools/pixel_extensions.dart';
import '../tools/point_extensions.dart';

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
  ) = settings;

  final int width = image.width;
  final int height = image.height;

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

  bool leftTopFound = false;
  bool rightTopFound = false;
  bool rightBottomFound = false;
  bool leftBottomFound = false;

  Point<int> leftTop = Point(width, 0);
  Point<int> rightTop = Point(0, height);
  Point<int> rightBottom = const Point(0, 0);
  Point<int> leftBottom = const Point(0, 0);

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

  if (cornersFound == false) {
    return const Edges.empty();
  }

  final List<Point<int>> corners = [leftTop, rightTop, rightBottom, leftBottom]..sort((a, b) => a.x.compareTo(b.x));
  final List<Point<int>> leftCorners = [corners[0], corners[1]]..sort((a, b) => a.y.compareTo(b.y));
  final List<Point<int>> rightCorners = [corners[2], corners[3]]..sort((a, b) => a.y.compareTo(b.y));

  leftTop = leftCorners[0];
  leftBottom = leftCorners[1];
  rightTop = rightCorners[0];
  rightBottom = rightCorners[1];

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

  if (wrongFigure) {
    return const Edges.empty();
  }

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

  if (hasWrongAngles()) {
    return const Edges.empty();
  }

  final int objectSquare = square(leftTop, rightTop, rightBottom, leftBottom);
  final int imageSquare = width * height;
  final double relativeSquare = objectSquare / imageSquare;

  if (relativeSquare < areaThreshold) {
    return Edges.empty().copyWith(square: relativeSquare);
  }

  final Distortion distortionLevel = distortion(
    topLeft: leftTopAngle,
    topRight: rightTopAngle,
    bottomLeft: leftBottomAngle,
    bottomRight: rightBottomAngle,
    threshold: directionAngleLevel,
  );

  return Edges(
    leftMiddle: null,
    leftTop: leftTop,
    topMiddle: null,
    rightTop: rightTop,
    rightMiddle: null,
    rightBottom: rightBottom,
    bottomMiddle: null,
    leftBottom: leftBottom,
    allPoints: allPoints,
    xMoveTo: distortionLevel.x,
    yMoveTo: distortionLevel.y,
    recognizedObjects: recognizedObjects,
    square: relativeSquare,
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
  ) = settings;

  imageToProcess = imageToProcess.withBestChannelOnly(luminanceThreshold);

  if (blurRadius > 0) {
    imageToProcess = gaussianBlur(imageToProcess, radius: blurRadius);
  }

  if (sobelLevel > 0) {
    for (int i = 0; i < sobelAmount; i++) {
      imageToProcess = sobel(imageToProcess, amount: sobelLevel);
    }
  }

  if (blackWhiteThreshold > 0 && blackWhiteThreshold < 255) {
    imageToProcess = imageToProcess.toBlackWhite(blackWhiteThreshold);
  }

  return imageToProcess;
}
