import 'dart:typed_data';

import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:equatable/equatable.dart';

part 'image_result.g.dart';

@autoequal
@CopyWith()
class ImageResult extends Equatable {
  const ImageResult({
    required this.originalImage,
    required this.processedImage,
    required this.edges,
    required this.processedImageWidth,
    required this.processedImageHeight,
  });

  const ImageResult.fromOriginalImage(this.originalImage)
      : processedImage = null,
        processedImageWidth = null,
        processedImageHeight = null,
        edges = null;

  final Uint8List originalImage;

  final Uint8List? processedImage;

  final Edges? edges;

  final int? processedImageWidth;

  final int? processedImageHeight;

  @override
  List<Object?> get props => _$props;
}
