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
  });

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

  final XAxis xMoveTo;
  final YAxis yMoveTo;

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
