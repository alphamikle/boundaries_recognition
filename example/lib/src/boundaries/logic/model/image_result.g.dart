// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_result.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$ImageResultAutoequal on ImageResult {
  List<Object?> get _$props => [
        name,
        originalImage,
        processedImage,
        edges,
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

  ImageResult processedImage(Uint8List? processedImage);

  ImageResult edges(Edges? edges);

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
    Uint8List? processedImage,
    Edges? edges,
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
  ImageResult processedImage(Uint8List? processedImage) =>
      this(processedImage: processedImage);

  @override
  ImageResult edges(Edges? edges) => this(edges: edges);

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
    Object? processedImage = const $CopyWithPlaceholder(),
    Object? edges = const $CopyWithPlaceholder(),
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
      processedImage: processedImage == const $CopyWithPlaceholder()
          ? _value.processedImage
          // ignore: cast_nullable_to_non_nullable
          : processedImage as Uint8List?,
      edges: edges == const $CopyWithPlaceholder()
          ? _value.edges
          // ignore: cast_nullable_to_non_nullable
          : edges as Edges?,
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
