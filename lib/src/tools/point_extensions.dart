import 'dart:math';

import 'types.dart';

typedef PointCoordinates<T extends num> = ({num x, num y});

extension ExtendedIntPoint on Point<int> {
  int get ltSum => x + y;
  int get rtSum => x - y;
  int get rbSum => ltSum;
  int get lbSum => y - x;

  bool isInRectangle(int width, int height) => x >= 0 && y >= 0 && x < width && y < height;
}

extension ExtendedPointCoordinates<T extends num> on PointCoordinates<T> {
  bool isInRectangle(int width, int height) => x >= 0 && y >= 0 && x < width && y < height;
}

Json? pointIntToJsonOrNull(Point<int>? point) {
  if (point == null) {
    return null;
  }

  return {
    'x': point.x,
    'y': point.y,
  };
}

Point<int>? pointIntOrNullFromJson(Object? json) {
  if (json is Map) {
    final int x = json['x'] as int;
    final int y = json['y'] as int;
    return Point(x, y);
  }
  return null;
}

List<Json> listOfPointIntToJsonList(List<Point<int>>? points) {
  if (points == null) {
    return [];
  }
  final List<Json> jsonList = [];
  for (int i = 0; i < points.length; i++) {
    jsonList.add(pointIntToJsonOrNull(points[i])!);
  }
  return jsonList;
}

List<Point<int>> jsonListToListOfPointInt(Object? json) {
  if (json is List) {
    final List<Point<int>> pointIntList = [];

    for (int i = 0; i < json.length; i++) {
      final Point<int>? point = pointIntOrNullFromJson(json[i]);
      if (point != null) {
        pointIntList.add(point);
      }
    }

    return pointIntList;
  }
  return [];
}
