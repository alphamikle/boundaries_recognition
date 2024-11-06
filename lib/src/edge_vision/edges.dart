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

enum UnrecognizedReason {
  noCorners,
  exceededSkewnessThreshold,
  exceededAngleThreshold,
  tooSmallSquare,
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
    this.unrecognizedReason,
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
        square = null,
        unrecognizedReason = null;

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

  final double? square;
  final UnrecognizedReason? unrecognizedReason;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edges &&
          runtimeType == other.runtimeType &&
          leftMiddle == other.leftMiddle &&
          leftTop == other.leftTop &&
          topMiddle == other.topMiddle &&
          rightTop == other.rightTop &&
          rightMiddle == other.rightMiddle &&
          rightBottom == other.rightBottom &&
          bottomMiddle == other.bottomMiddle &&
          leftBottom == other.leftBottom &&
          allPoints == other.allPoints &&
          recognizedObjects == other.recognizedObjects &&
          xMoveTo == other.xMoveTo &&
          yMoveTo == other.yMoveTo &&
          square == other.square &&
          unrecognizedReason == other.unrecognizedReason;

  @override
  int get hashCode =>
      leftMiddle.hashCode ^
      leftTop.hashCode ^
      topMiddle.hashCode ^
      rightTop.hashCode ^
      rightMiddle.hashCode ^
      rightBottom.hashCode ^
      bottomMiddle.hashCode ^
      leftBottom.hashCode ^
      allPoints.hashCode ^
      recognizedObjects.hashCode ^
      xMoveTo.hashCode ^
      yMoveTo.hashCode ^
      square.hashCode ^
      unrecognizedReason.hashCode;

  @override
  String toString() {
    return '''
Edges{
  leftMiddle: $leftMiddle,
  leftTop: $leftTop,
  topMiddle: $topMiddle,
  rightTop: $rightTop,
  rightMiddle: $rightMiddle,
  rightBottom: $rightBottom,
  bottomMiddle: $bottomMiddle,
  leftBottom: $leftBottom,
  allPoints: [${allPoints.length} points],
  recognizedObjects: $recognizedObjects,
  xMoveTo: $xMoveTo,
  yMoveTo: $yMoveTo,
  square: $square,
  unrecognizedReason: $unrecognizedReason,
}''';
  }

  Edges copyWith({
    Point<int>? leftMiddle,
    Point<int>? leftTop,
    Point<int>? topMiddle,
    Point<int>? rightTop,
    Point<int>? rightMiddle,
    Point<int>? rightBottom,
    Point<int>? bottomMiddle,
    Point<int>? leftBottom,
    List<Point<int>>? allPoints,
    List<int>? recognizedObjects,
    XAxis? xMoveTo,
    YAxis? yMoveTo,
    double? square,
    UnrecognizedReason? unrecognizedReason,
  }) {
    return Edges(
      leftMiddle: leftMiddle ?? this.leftMiddle,
      leftTop: leftTop ?? this.leftTop,
      topMiddle: topMiddle ?? this.topMiddle,
      rightTop: rightTop ?? this.rightTop,
      rightMiddle: rightMiddle ?? this.rightMiddle,
      rightBottom: rightBottom ?? this.rightBottom,
      bottomMiddle: bottomMiddle ?? this.bottomMiddle,
      leftBottom: leftBottom ?? this.leftBottom,
      allPoints: allPoints ?? this.allPoints,
      recognizedObjects: recognizedObjects ?? this.recognizedObjects,
      xMoveTo: xMoveTo ?? this.xMoveTo,
      yMoveTo: yMoveTo ?? this.yMoveTo,
      square: square ?? this.square,
      unrecognizedReason: unrecognizedReason ?? this.unrecognizedReason,
    );
  }
}
