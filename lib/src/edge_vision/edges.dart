import 'dart:math';

import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../tools/point_extensions.dart';
import '../tools/types.dart';

part 'edges.g.dart';

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

typedef ImageSize = ({int width, int height});

@autoequal
@CopyWith()
@JsonSerializable()
class Edges extends Equatable {
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
    required this.originalImageSize,
    required this.resizedImageSize,
    this.unrecognizedReason,
  });

  factory Edges.fromJson(Json json) => _$EdgesFromJson(json);

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
        unrecognizedReason = null,
        originalImageSize = null,
        resizedImageSize = null;

  @JsonKey(fromJson: pointIntOrNullFromJson, toJson: pointIntToJsonOrNull)
  final Point<int>? leftTop;

  @JsonKey(fromJson: pointIntOrNullFromJson, toJson: pointIntToJsonOrNull)
  final Point<int>? rightTop;

  @JsonKey(fromJson: pointIntOrNullFromJson, toJson: pointIntToJsonOrNull)
  final Point<int>? rightBottom;

  @JsonKey(fromJson: pointIntOrNullFromJson, toJson: pointIntToJsonOrNull)
  final Point<int>? leftBottom;

  final double? leftLength;
  final double? topLength;
  final double? rightLength;
  final double? bottomLength;

  final double? leftTopAngle;
  final double? rightTopAngle;
  final double? rightBottomAngle;
  final double? leftBottomAngle;

  @JsonKey(fromJson: jsonListToListOfPointInt, toJson: listOfPointIntToJsonList)
  final List<Point<int>> allPoints;

  final List<int> recognizedObjects;

  final XAxis? xMoveTo;
  final YAxis? yMoveTo;

  final double? relativeSquare;
  final int? square;
  final UnrecognizedReason? unrecognizedReason;

  final ImageSize? originalImageSize;
  final ImageSize? resizedImageSize;

  List<Point<int>> get corners => [
        leftTop,
        rightTop,
        rightBottom,
        leftBottom,
      ].nonNulls.toList();

  @override
  List<Object?> get props => _$props;

  Json toJson() => _$EdgesToJson(this);
}
