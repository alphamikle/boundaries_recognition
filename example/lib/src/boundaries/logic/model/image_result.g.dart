// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_result.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$ImageResultAutoequal on ImageResult {
  List<Object?> get _$props => [
        name,
        originalImage,
        decodedImage,
        processedImage,
        edges,
        originalImageWidth,
        originalImageHeight,
        processedImageWidth,
        processedImageHeight,
      ];
}

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImageResultCWProxy {
  ImageResult name(String name);

  ImageResult originalImage(Uint8List originalImage);

  ImageResult decodedImage(Image decodedImage);

  ImageResult processedImage(Uint8List? processedImage);

  ImageResult edges(Edges? edges);

  ImageResult originalImageWidth(int originalImageWidth);

  ImageResult originalImageHeight(int originalImageHeight);

  ImageResult processedImageWidth(int? processedImageWidth);

  ImageResult processedImageHeight(int? processedImageHeight);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImageResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImageResult(...).copyWith(id: 12, name: "My name")
  /// ````
  ImageResult call({
    String? name,
    Uint8List? originalImage,
    Image? decodedImage,
    Uint8List? processedImage,
    Edges? edges,
    int? originalImageWidth,
    int? originalImageHeight,
    int? processedImageWidth,
    int? processedImageHeight,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfImageResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfImageResult.copyWith.fieldName(...)`
class _$ImageResultCWProxyImpl implements _$ImageResultCWProxy {
  const _$ImageResultCWProxyImpl(this._value);

  final ImageResult _value;

  @override
  ImageResult name(String name) => this(name: name);

  @override
  ImageResult originalImage(Uint8List originalImage) =>
      this(originalImage: originalImage);

  @override
  ImageResult decodedImage(Image decodedImage) =>
      this(decodedImage: decodedImage);

  @override
  ImageResult processedImage(Uint8List? processedImage) =>
      this(processedImage: processedImage);

  @override
  ImageResult edges(Edges? edges) => this(edges: edges);

  @override
  ImageResult originalImageWidth(int originalImageWidth) =>
      this(originalImageWidth: originalImageWidth);

  @override
  ImageResult originalImageHeight(int originalImageHeight) =>
      this(originalImageHeight: originalImageHeight);

  @override
  ImageResult processedImageWidth(int? processedImageWidth) =>
      this(processedImageWidth: processedImageWidth);

  @override
  ImageResult processedImageHeight(int? processedImageHeight) =>
      this(processedImageHeight: processedImageHeight);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImageResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImageResult(...).copyWith(id: 12, name: "My name")
  /// ````
  ImageResult call({
    Object? name = const $CopyWithPlaceholder(),
    Object? originalImage = const $CopyWithPlaceholder(),
    Object? decodedImage = const $CopyWithPlaceholder(),
    Object? processedImage = const $CopyWithPlaceholder(),
    Object? edges = const $CopyWithPlaceholder(),
    Object? originalImageWidth = const $CopyWithPlaceholder(),
    Object? originalImageHeight = const $CopyWithPlaceholder(),
    Object? processedImageWidth = const $CopyWithPlaceholder(),
    Object? processedImageHeight = const $CopyWithPlaceholder(),
  }) {
    return ImageResult(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      originalImage:
          originalImage == const $CopyWithPlaceholder() || originalImage == null
              ? _value.originalImage
              // ignore: cast_nullable_to_non_nullable
              : originalImage as Uint8List,
      decodedImage:
          decodedImage == const $CopyWithPlaceholder() || decodedImage == null
              ? _value.decodedImage
              // ignore: cast_nullable_to_non_nullable
              : decodedImage as Image,
      processedImage: processedImage == const $CopyWithPlaceholder()
          ? _value.processedImage
          // ignore: cast_nullable_to_non_nullable
          : processedImage as Uint8List?,
      edges: edges == const $CopyWithPlaceholder()
          ? _value.edges
          // ignore: cast_nullable_to_non_nullable
          : edges as Edges?,
      originalImageWidth: originalImageWidth == const $CopyWithPlaceholder() ||
              originalImageWidth == null
          ? _value.originalImageWidth
          // ignore: cast_nullable_to_non_nullable
          : originalImageWidth as int,
      originalImageHeight:
          originalImageHeight == const $CopyWithPlaceholder() ||
                  originalImageHeight == null
              ? _value.originalImageHeight
              // ignore: cast_nullable_to_non_nullable
              : originalImageHeight as int,
      processedImageWidth: processedImageWidth == const $CopyWithPlaceholder()
          ? _value.processedImageWidth
          // ignore: cast_nullable_to_non_nullable
          : processedImageWidth as int?,
      processedImageHeight: processedImageHeight == const $CopyWithPlaceholder()
          ? _value.processedImageHeight
          // ignore: cast_nullable_to_non_nullable
          : processedImageHeight as int?,
    );
  }
}

extension $ImageResultCopyWith on ImageResult {
  /// Returns a callable class that can be used as follows: `instanceOfImageResult.copyWith(...)` or like so:`instanceOfImageResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ImageResultCWProxy get copyWith => _$ImageResultCWProxyImpl(this);
}
