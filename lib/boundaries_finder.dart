import 'dart:math';
import 'package:boundaries_detector/utils/angle.dart';
import 'package:boundaries_detector/utils/distance.dart';
import 'package:image/image.dart' as i;

import 'utils/distortion.dart';

class Boundaries {
  const Boundaries({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.allPoints,
    required this.xMoveTo,
    required this.yMoveTo,
    required this.recognizedObjects,
  });

  final Point<int>? left;
  final Point<int>? top;
  final Point<int>? right;
  final Point<int>? bottom;
  final List<Point<int>> allPoints;
  final List<int> recognizedObjects;

  final XAxis xMoveTo;
  final YAxis yMoveTo;

  List<Point<int>> get corners => [
        left,
        top,
        right,
        bottom,
      ].nonNulls.toList();
}

bool isWhite(i.Pixel pixel) => pixel.r == 255 && pixel.g == 255 && pixel.b == 255;

bool isBlack(i.Pixel pixel) => pixel.r == 0 && pixel.g == 0 && pixel.b == 0;

extension ExtendedIntPoint on Point<int> {
  int get ltSum => x + y;
  int get rtSum => x - y;
  int get rbSum => ltSum;
  int get lbSum => y - x;
}

Boundaries findBoundaries(
  i.Image image, {
  int matrixSize = 3,
  int minSize = 100,
  double angleThreshold = 2,
  double proportionThreshold = 0.25,
}) {
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

  for (int x = -matrixSize; x < matrixSize; x++) {
    for (int y = -matrixSize; y < matrixSize; y++) {
      directions.add(Point(x, y));
    }
  }

  bool isInside(int x, int y) => x >= 0 && y >= 0 && x < image.width && y < image.height;

  List<Point<int>> findPathPoints(int startX, int startY) {
    final List<Point<int>> points = [];
    final List<Point<int>> currentPath = [Point(startX, startY)];
    const int takeEveryNth = 4;
    int counter = 0;

    while (currentPath.isNotEmpty) {
      Point<int> point = currentPath.removeLast();
      int x = point.x;
      int y = point.y;

      if (!isInside(x, y) || visited[y][x] || isBlack(image.getPixel(x, y))) {
        continue;
      }

      visited[y][x] = true;

      if (counter % takeEveryNth == 0) {
        points.add(point);
      }

      counter++;

      for (Point<int> direction in directions) {
        int newX = x + direction.x;
        int newY = y + direction.y;
        if (isInside(newX, newY) && visited[newY][newX] == false) {
          currentPath.add(Point(newX, newY));
        }
      }
    }

    if (points.length >= minSize) {
      return points;
    } else {
      return [];
    }
  }

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final i.Pixel pixel = image.getPixel(x, y);
      final bool isPixelWhite = isWhite(pixel);
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

  if (distanceDifference(topDistance, bottomDistance) > proportionThreshold) {
    wrongFigure = true;
  } else if (distanceDifference(rightDistance, leftDistance) > proportionThreshold) {
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
    threshold: angleThreshold,
  );

  if (wrongFigure) {
    return const Boundaries(
      left: null,
      top: null,
      right: null,
      bottom: null,
      allPoints: [],
      xMoveTo: XAxis.center,
      yMoveTo: YAxis.center,
      recognizedObjects: [],
    );
  }

  return Boundaries(
    left: leftTop,
    top: rightTop,
    right: rightBottom,
    bottom: leftBottom,
    allPoints: allPoints,
    xMoveTo: distortionLevel.x,
    yMoveTo: distortionLevel.y,
    recognizedObjects: recognizedObjects,
  );
}
