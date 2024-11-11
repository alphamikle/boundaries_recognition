import 'dart:typed_data';

import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:equatable/equatable.dart';
import 'package:image/image.dart';

part 'image_result.g.dart';

@autoequal
@CopyWith()
class ImageResult extends Equatable {
  const ImageResult({
    required this.name,
    required this.originalImage,
    required this.decodedImage,
    required this.processedImage,
    required this.edges,
    required this.originalImageWidth,
    required this.originalImageHeight,
    required this.processedImageWidth,
    required this.processedImageHeight,
  });

  const ImageResult.fromOriginalImage({
    required this.name,
    required this.originalImage,
    required this.decodedImage,
    required this.originalImageWidth,
    required this.originalImageHeight,
  })  : processedImage = null,
        processedImageWidth = null,
        processedImageHeight = null,
        edges = null;

  final String name;

  final Uint8List originalImage;

  final Image decodedImage;

  final Uint8List? processedImage;

  final Edges? edges;

  final int originalImageWidth;

  final int originalImageHeight;

  final int? processedImageWidth;

  final int? processedImageHeight;

  @override
  List<Object?> get props => _$props;
}
