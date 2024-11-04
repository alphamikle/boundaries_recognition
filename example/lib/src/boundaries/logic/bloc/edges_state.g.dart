// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edges_state.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$EdgesStateAutoequal on EdgesState {
  List<Object?> get _$props => [
        images,
        selectedImages,
        imagesList,
        testImages,
        settings,
        settingsIndex,
        maxImageSize,
        dotsCloudOn,
        painterOn,
        processing,
        opacity,
      ];
}

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EdgesStateCWProxy {
  EdgesState images(Map<String, ImageResult> images);

  EdgesState selectedImages(Set<String> selectedImages);

  EdgesState imagesList(List<ImageResult> imagesList);

  EdgesState testImages(Map<String, TestImage> testImages);

  EdgesState settings(List<EdgeVisionSettings> settings);

  EdgesState settingsIndex(int? settingsIndex);

  EdgesState maxImageSize(int maxImageSize);

  EdgesState dotsCloudOn(bool dotsCloudOn);

  EdgesState painterOn(bool painterOn);

  EdgesState processing(bool processing);

  EdgesState opacity(double opacity);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EdgesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EdgesState(...).copyWith(id: 12, name: "My name")
  /// ````
  EdgesState call({
    Map<String, ImageResult>? images,
    Set<String>? selectedImages,
    List<ImageResult>? imagesList,
    Map<String, TestImage>? testImages,
    List<EdgeVisionSettings>? settings,
    int? settingsIndex,
    int? maxImageSize,
    bool? dotsCloudOn,
    bool? painterOn,
    bool? processing,
    double? opacity,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEdgesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEdgesState.copyWith.fieldName(...)`
class _$EdgesStateCWProxyImpl implements _$EdgesStateCWProxy {
  const _$EdgesStateCWProxyImpl(this._value);

  final EdgesState _value;

  @override
  EdgesState images(Map<String, ImageResult> images) => this(images: images);

  @override
  EdgesState selectedImages(Set<String> selectedImages) =>
      this(selectedImages: selectedImages);

  @override
  EdgesState imagesList(List<ImageResult> imagesList) =>
      this(imagesList: imagesList);

  @override
  EdgesState testImages(Map<String, TestImage> testImages) =>
      this(testImages: testImages);

  @override
  EdgesState settings(List<EdgeVisionSettings> settings) =>
      this(settings: settings);

  @override
  EdgesState settingsIndex(int? settingsIndex) =>
      this(settingsIndex: settingsIndex);

  @override
  EdgesState maxImageSize(int maxImageSize) => this(maxImageSize: maxImageSize);

  @override
  EdgesState dotsCloudOn(bool dotsCloudOn) => this(dotsCloudOn: dotsCloudOn);

  @override
  EdgesState painterOn(bool painterOn) => this(painterOn: painterOn);

  @override
  EdgesState processing(bool processing) => this(processing: processing);

  @override
  EdgesState opacity(double opacity) => this(opacity: opacity);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EdgesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EdgesState(...).copyWith(id: 12, name: "My name")
  /// ````
  EdgesState call({
    Object? images = const $CopyWithPlaceholder(),
    Object? selectedImages = const $CopyWithPlaceholder(),
    Object? imagesList = const $CopyWithPlaceholder(),
    Object? testImages = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? settingsIndex = const $CopyWithPlaceholder(),
    Object? maxImageSize = const $CopyWithPlaceholder(),
    Object? dotsCloudOn = const $CopyWithPlaceholder(),
    Object? painterOn = const $CopyWithPlaceholder(),
    Object? processing = const $CopyWithPlaceholder(),
    Object? opacity = const $CopyWithPlaceholder(),
  }) {
    return EdgesState(
      images: images == const $CopyWithPlaceholder() || images == null
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as Map<String, ImageResult>,
      selectedImages: selectedImages == const $CopyWithPlaceholder() ||
              selectedImages == null
          ? _value.selectedImages
          // ignore: cast_nullable_to_non_nullable
          : selectedImages as Set<String>,
      imagesList:
          imagesList == const $CopyWithPlaceholder() || imagesList == null
              ? _value.imagesList
              // ignore: cast_nullable_to_non_nullable
              : imagesList as List<ImageResult>,
      testImages:
          testImages == const $CopyWithPlaceholder() || testImages == null
              ? _value.testImages
              // ignore: cast_nullable_to_non_nullable
              : testImages as Map<String, TestImage>,
      settings: settings == const $CopyWithPlaceholder() || settings == null
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as List<EdgeVisionSettings>,
      settingsIndex: settingsIndex == const $CopyWithPlaceholder()
          ? _value.settingsIndex
          // ignore: cast_nullable_to_non_nullable
          : settingsIndex as int?,
      maxImageSize:
          maxImageSize == const $CopyWithPlaceholder() || maxImageSize == null
              ? _value.maxImageSize
              // ignore: cast_nullable_to_non_nullable
              : maxImageSize as int,
      dotsCloudOn:
          dotsCloudOn == const $CopyWithPlaceholder() || dotsCloudOn == null
              ? _value.dotsCloudOn
              // ignore: cast_nullable_to_non_nullable
              : dotsCloudOn as bool,
      painterOn: painterOn == const $CopyWithPlaceholder() || painterOn == null
          ? _value.painterOn
          // ignore: cast_nullable_to_non_nullable
          : painterOn as bool,
      processing:
          processing == const $CopyWithPlaceholder() || processing == null
              ? _value.processing
              // ignore: cast_nullable_to_non_nullable
              : processing as bool,
      opacity: opacity == const $CopyWithPlaceholder() || opacity == null
          ? _value.opacity
          // ignore: cast_nullable_to_non_nullable
          : opacity as double,
    );
  }
}

extension $EdgesStateCopyWith on EdgesState {
  /// Returns a callable class that can be used as follows: `instanceOfEdgesState.copyWith(...)` or like so:`instanceOfEdgesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EdgesStateCWProxy get copyWith => _$EdgesStateCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `EdgesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EdgesState(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  EdgesState copyWithNull({
    bool settingsIndex = false,
  }) {
    return EdgesState(
      images: images,
      selectedImages: selectedImages,
      imagesList: imagesList,
      testImages: testImages,
      settings: settings,
      settingsIndex: settingsIndex == true ? null : this.settingsIndex,
      maxImageSize: maxImageSize,
      dotsCloudOn: dotsCloudOn,
      painterOn: painterOn,
      processing: processing,
      opacity: opacity,
    );
  }
}
