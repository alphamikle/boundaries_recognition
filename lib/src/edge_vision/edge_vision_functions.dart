import 'dart:math' show Point;

import 'package:image/image.dart' show Image, Pixel, gaussianBlur, grayscale, sobel;

import '../../edge_vision.dart';
import '../tools/distortion.dart';
import '../tools/math.dart';
import '../tools/pixel_extensions.dart';
import '../tools/point_extensions.dart';

Edges findImageEdgesSync({
  required Image image,
  required Settings settings,
}) {
  final Settings(:searchMatrixSize, :minObjectSize, :distortionAngleThreshold, :skewnessThreshold) = settings;

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

  Point<int> leftTop = Point(width, 0);
  Point<int> rightTop = Point(0, height);
  Point<int> rightBottom = const Point(0, 0);
  Point<int> leftBottom = const Point(0, 0);

  for (final Point<int> point in allPoints) {
    if (point.ltSum < leftTop.ltSum) {
      leftTop = point;
    } else if (point.rtSum > rightTop.rtSum) {
      rightTop = point;
    } else if (point.rbSum > rightBottom.rbSum) {
      rightBottom = point;
    } else if (point.lbSum > leftBottom.lbSum) {
      leftBottom = point;
    }
  }

  final List<Point<int>> corners = [leftTop, rightTop, rightBottom, leftBottom]..sort((a, b) => a.x.compareTo(b.x));
  final List<Point<int>> leftCorners = [corners[0], corners[1]]..sort((a, b) => a.y.compareTo(b.y));
  final List<Point<int>> rightCorners = [corners[2], corners[3]]..sort((a, b) => a.y.compareTo(b.y));

  leftTop = leftCorners[0];
  leftBottom = leftCorners[1];

  rightTop = rightCorners[0];
  rightBottom = rightCorners[1];

  final double topDistance = distance(leftTop, rightTop);
  final double rightDistance = distance(rightTop, rightBottom);
  final double bottomDistance = distance(rightBottom, leftBottom);
  final double leftDistance = distance(leftBottom, leftTop);

  bool wrongFigure = false;

  if (distanceDifference(topDistance, bottomDistance) > skewnessThreshold) {
    wrongFigure = true;
  } else if (distanceDifference(rightDistance, leftDistance) > skewnessThreshold) {
    wrongFigure = true;
  }

  final double leftTopAngle = angle(leftBottom, leftTop, rightTop);
  final double rightTopAngle = angle(leftTop, rightTop, rightBottom);
  final double rightBottomAngle = angle(rightTop, rightBottom, leftBottom);
  final double leftBottomAngle = angle(rightBottom, leftBottom, leftTop);

  final Distortion distortionLevel = distortion(
    topLeft: leftTopAngle,
    topRight: rightTopAngle,
    bottomLeft: leftBottomAngle,
    bottomRight: rightBottomAngle,
    threshold: distortionAngleThreshold,
  );

  if (wrongFigure) {
    return const Edges(
      leftMiddle: null,
      leftTop: null,
      topMiddle: null,
      rightTop: null,
      rightMiddle: null,
      rightBottom: null,
      bottomMiddle: null,
      leftBottom: null,
      allPoints: [],
      xMoveTo: XAxis.center,
      yMoveTo: YAxis.center,
      recognizedObjects: [],
    );
  }

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
  );
}

// Edges findImageEdgesRaw(TransferableTypedData rawImage) {}

Image prepareImageSync({
  required Image image,
  required Settings settings,
}) {
  Image imageToProcess = image;

  final Settings(:blackWhiteThreshold, :sobelAmount, :grayscaleAmount, :blurRadius) = settings;

  imageToProcess = grayscale(imageToProcess, amount: grayscaleAmount);
  imageToProcess = gaussianBlur(imageToProcess, radius: blurRadius);
  imageToProcess = sobel(imageToProcess, amount: sobelAmount);

  if (blackWhiteThreshold > 0 && blackWhiteThreshold < 255) {
    imageToProcess = imageToProcess.toBlackWhite(blackWhiteThreshold);
  }

  return imageToProcess;
}
