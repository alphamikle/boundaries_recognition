import 'dart:math';

enum XAxis {
  left,
  right,
  center,
}

enum YAxis {
  top,
  bottom,
  center,
}

typedef Distortion = ({XAxis x, YAxis y});

class Edges {
  const Edges({
    required this.leftMiddle,
    required this.leftTop,
    required this.topMiddle,
    required this.rightTop,
    required this.rightMiddle,
    required this.rightBottom,
    required this.bottomMiddle,
    required this.leftBottom,
    required this.allPoints,
    required this.xMoveTo,
    required this.yMoveTo,
    required this.recognizedObjects,
    required this.square,
  });

  const Edges.empty()
      : leftMiddle = null,
        leftTop = null,
        topMiddle = null,
        rightTop = null,
        rightMiddle = null,
        rightBottom = null,
        bottomMiddle = null,
        leftBottom = null,
        allPoints = const [],
        xMoveTo = null,
        yMoveTo = null,
        recognizedObjects = const [],
        square = null;

  final Point<int>? leftMiddle;
  final Point<int>? leftTop;
  final Point<int>? topMiddle;
  final Point<int>? rightTop;
  final Point<int>? rightMiddle;
  final Point<int>? rightBottom;
  final Point<int>? bottomMiddle;
  final Point<int>? leftBottom;

  final List<Point<int>> allPoints;
  final List<int> recognizedObjects;

  final XAxis? xMoveTo;
  final YAxis? yMoveTo;

  final int? square;

  List<Point<int>> get corners => [
        leftMiddle,
        leftTop,
        topMiddle,
        rightTop,
        rightMiddle,
        rightBottom,
        bottomMiddle,
        leftBottom,
      ].nonNulls.toList();
}
