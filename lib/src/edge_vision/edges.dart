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
    required this.leftTop,
    required this.rightTop,
    required this.rightBottom,
    required this.leftBottom,
    required this.leftLength,
    required this.topLength,
    required this.rightLength,
    required this.bottomLength,
    required this.leftTopAngle,
    required this.rightTopAngle,
    required this.rightBottomAngle,
    required this.leftBottomAngle,
    required this.allPoints,
    required this.recognizedObjects,
    required this.xMoveTo,
    required this.yMoveTo,
    required this.relativeSquare,
    required this.square,
    this.unrecognizedReason,
  });

  const Edges.empty()
      : leftTop = null,
        rightTop = null,
        rightBottom = null,
        leftBottom = null,
        leftLength = null,
        topLength = null,
        rightLength = null,
        bottomLength = null,
        leftTopAngle = null,
        rightTopAngle = null,
        rightBottomAngle = null,
        leftBottomAngle = null,
        allPoints = const [],
        recognizedObjects = const [],
        xMoveTo = null,
        yMoveTo = null,
        relativeSquare = null,
        square = null,
        unrecognizedReason = null;

  /// Corners
  final Point<int>? leftTop;
  final Point<int>? rightTop;
  final Point<int>? rightBottom;
  final Point<int>? leftBottom;

  final double? leftLength;
  final double? topLength;
  final double? rightLength;
  final double? bottomLength;

  final double? leftTopAngle;
  final double? rightTopAngle;
  final double? rightBottomAngle;
  final double? leftBottomAngle;

  final List<Point<int>> allPoints;
  final List<int> recognizedObjects;

  final XAxis? xMoveTo;
  final YAxis? yMoveTo;

  final double? relativeSquare;
  final int? square;
  final UnrecognizedReason? unrecognizedReason;

  List<Point<int>> get corners => [
        leftTop,
        rightTop,
        rightBottom,
        leftBottom,
      ].nonNulls.toList();

  Edges copyWith({
    Point<int>? leftTop,
    Point<int>? rightTop,
    Point<int>? rightBottom,
    Point<int>? leftBottom,
    double? leftLength,
    double? topLength,
    double? rightLength,
    double? bottomLength,
    double? leftTopAngle,
    double? rightTopAngle,
    double? rightBottomAngle,
    double? leftBottomAngle,
    List<Point<int>>? allPoints,
    List<int>? recognizedObjects,
    XAxis? xMoveTo,
    YAxis? yMoveTo,
    double? relativeSquare,
    int? square,
    UnrecognizedReason? unrecognizedReason,
  }) {
    return Edges(
      leftTop: leftTop ?? this.leftTop,
      rightTop: rightTop ?? this.rightTop,
      rightBottom: rightBottom ?? this.rightBottom,
      leftBottom: leftBottom ?? this.leftBottom,
      leftLength: leftLength ?? this.leftLength,
      topLength: topLength ?? this.topLength,
      rightLength: rightLength ?? this.rightLength,
      bottomLength: bottomLength ?? this.bottomLength,
      leftTopAngle: leftTopAngle ?? this.leftTopAngle,
      rightTopAngle: rightTopAngle ?? this.rightTopAngle,
      rightBottomAngle: rightBottomAngle ?? this.rightBottomAngle,
      leftBottomAngle: leftBottomAngle ?? this.leftBottomAngle,
      allPoints: allPoints ?? this.allPoints,
      recognizedObjects: recognizedObjects ?? this.recognizedObjects,
      xMoveTo: xMoveTo ?? this.xMoveTo,
      yMoveTo: yMoveTo ?? this.yMoveTo,
      relativeSquare: relativeSquare ?? this.relativeSquare,
      square: square ?? this.square,
      unrecognizedReason: unrecognizedReason ?? this.unrecognizedReason,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Edges &&
          runtimeType == other.runtimeType &&
          leftTop == other.leftTop &&
          rightTop == other.rightTop &&
          rightBottom == other.rightBottom &&
          leftBottom == other.leftBottom &&
          leftLength == other.leftLength &&
          topLength == other.topLength &&
          rightLength == other.rightLength &&
          bottomLength == other.bottomLength &&
          leftTopAngle == other.leftTopAngle &&
          rightTopAngle == other.rightTopAngle &&
          rightBottomAngle == other.rightBottomAngle &&
          leftBottomAngle == other.leftBottomAngle &&
          allPoints == other.allPoints &&
          recognizedObjects == other.recognizedObjects &&
          xMoveTo == other.xMoveTo &&
          yMoveTo == other.yMoveTo &&
          relativeSquare == other.relativeSquare &&
          square == other.square &&
          unrecognizedReason == other.unrecognizedReason;

  @override
  int get hashCode =>
      leftTop.hashCode ^
      rightTop.hashCode ^
      rightBottom.hashCode ^
      leftBottom.hashCode ^
      leftLength.hashCode ^
      topLength.hashCode ^
      rightLength.hashCode ^
      bottomLength.hashCode ^
      leftTopAngle.hashCode ^
      rightTopAngle.hashCode ^
      rightBottomAngle.hashCode ^
      leftBottomAngle.hashCode ^
      allPoints.hashCode ^
      recognizedObjects.hashCode ^
      xMoveTo.hashCode ^
      yMoveTo.hashCode ^
      relativeSquare.hashCode ^
      square.hashCode ^
      unrecognizedReason.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'leftTop': leftTop?.toJson(),
      'rightTop': rightTop?.toJson(),
      'rightBottom': rightBottom?.toJson(),
      'leftBottom': leftBottom?.toJson(),
      'leftLength': leftLength,
      'topLength': topLength,
      'rightLength': rightLength,
      'bottomLength': bottomLength,
      'leftTopAngle': leftTopAngle,
      'rightTopAngle': rightTopAngle,
      'rightBottomAngle': rightBottomAngle,
      'leftBottomAngle': leftBottomAngle,
      'recognizedObjects': recognizedObjects,
      'xMoveTo': xMoveTo?.toString(),
      'yMoveTo': yMoveTo?.toString(),
      'relativeSquare': relativeSquare,
      'square': square,
      'unrecognizedReason': unrecognizedReason?.toString(),
    };
  }
}

extension _JsonablePointInt on Point<int> {
  Map<String, int> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}
