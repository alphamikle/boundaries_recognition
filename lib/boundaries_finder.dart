import 'dart:developer';
import 'dart:math';
import 'package:image/image.dart' as i;

class Boundaries {
  const Boundaries({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.allPoints,
  });

  final Point<int> left;
  final Point<int> top;
  final Point<int> right;
  final Point<int> bottom;
  final List<Point<int>> allPoints;

  List<Point<int>> get corners => [
        left,
        top,
        right,
        bottom,
      ];
}

bool isWhite(i.Pixel pixel) => pixel.r == 255 && pixel.g == 255 && pixel.b == 255;

bool isBlack(i.Pixel pixel) => pixel.r == 0 && pixel.g == 0 && pixel.b == 0;

Boundaries findBoundaries(i.Image image, {int threshold = 3}) {
  final int width = image.width;
  final int height = image.height;

  final List<Point<int>> contours = [];

  final List<List<bool>> visited = List.generate(
    image.height,
    (_) => List.generate(image.width, (_) => false),
  );

  final List<Point<int>> directions = [];

  for (int x = -threshold; x < threshold; x++) {
    for (int y = -threshold; y < threshold; y++) {
      directions.add(Point(x, y));
    }
  }

  Point<int> mostLeft = Point(width, 0);
  Point<int> mostTop = Point(0, height);
  Point<int> mostRight = const Point(0, 0);
  Point<int> mostBottom = const Point(0, 0);

  bool isInside(int x, int y) => x >= 0 && y >= 0 && x < image.width && y < image.height;

  List<Point<int>> traceContour(int startX, int startY) {
    final List<Point<int>> contour = [];
    final List<Point<int>> stack = [Point(startX, startY)];

    while (stack.isNotEmpty) {
      Point<int> point = stack.removeLast();
      int x = point.x;
      int y = point.y;

      if (!isInside(x, y) || visited[y][x] || isBlack(image.getPixel(x, y))) {
        continue;
      }

      visited[y][x] = true;
      contour.add(point);

      if (x < mostLeft.x) {
        mostLeft = point;
      }

      if (x > mostRight.x) {
        mostRight = point;
      }

      if (y < mostTop.y) {
        mostTop = point;
      }

      if (y > mostBottom.y) {
        mostBottom = point;
      }

      for (Point<int> direction in directions) {
        int newX = x + direction.x;
        int newY = y + direction.y;
        if (isInside(newX, newY) && !visited[newY][newX]) {
          stack.add(Point(newX, newY));
        }
      }
    }

    return contour;
  }

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final i.Pixel pixel = image.getPixel(x, y);
      final bool isPixelWhite = isWhite(pixel);
      final bool canBeVisited = visited[y][x] == false;

      if (canBeVisited && isPixelWhite) {
        List<Point<int>> contour = traceContour(x, y);

        if (contour.isNotEmpty) {
          contours.addAll(contour);
        }
      }
    }
  }

  return Boundaries(left: mostLeft, top: mostTop, right: mostRight, bottom: mostBottom, allPoints: contours);
}
