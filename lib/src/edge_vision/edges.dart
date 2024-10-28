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
