// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edges_state.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$EdgesStateAutoequal on EdgesState {
  List<Object?> get _$props => [
        images,
        settings,
        maxImageSize,
        threads,
        grayScaleOn,
        blurOn,
        resizeOn,
        sobelOn,
        bwOn,
        dotsCloudOn,
        painterOn,
      ];
}

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EdgesStateCWProxy {
  EdgesState images(Map<String, ImageResult> images);

  EdgesState settings(Settings settings);

  EdgesState maxImageSize(int maxImageSize);

  EdgesState threads(int threads);

  EdgesState grayScaleOn(bool grayScaleOn);

  EdgesState blurOn(bool blurOn);

  EdgesState resizeOn(bool resizeOn);

  EdgesState sobelOn(bool sobelOn);

  EdgesState bwOn(bool bwOn);

  EdgesState dotsCloudOn(bool dotsCloudOn);

  EdgesState painterOn(bool painterOn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EdgesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EdgesState(...).copyWith(id: 12, name: "My name")
  /// ````
  EdgesState call({
    Map<String, ImageResult>? images,
    Settings? settings,
    int? maxImageSize,
    int? threads,
    bool? grayScaleOn,
    bool? blurOn,
    bool? resizeOn,
    bool? sobelOn,
    bool? bwOn,
    bool? dotsCloudOn,
    bool? painterOn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEdgesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEdgesState.copyWith.fieldName(...)`
class _$EdgesStateCWProxyImpl implements _$EdgesStateCWProxy {
  const _$EdgesStateCWProxyImpl(this._value);

  final EdgesState _value;

  @override
  EdgesState images(Map<String, ImageResult> images) => this(images: images);

  @override
  EdgesState settings(Settings settings) => this(settings: settings);

  @override
  EdgesState maxImageSize(int maxImageSize) => this(maxImageSize: maxImageSize);

  @override
  EdgesState threads(int threads) => this(threads: threads);

  @override
  EdgesState grayScaleOn(bool grayScaleOn) => this(grayScaleOn: grayScaleOn);

  @override
  EdgesState blurOn(bool blurOn) => this(blurOn: blurOn);

  @override
  EdgesState resizeOn(bool resizeOn) => this(resizeOn: resizeOn);

  @override
  EdgesState sobelOn(bool sobelOn) => this(sobelOn: sobelOn);

  @override
  EdgesState bwOn(bool bwOn) => this(bwOn: bwOn);

  @override
  EdgesState dotsCloudOn(bool dotsCloudOn) => this(dotsCloudOn: dotsCloudOn);

  @override
  EdgesState painterOn(bool painterOn) => this(painterOn: painterOn);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EdgesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EdgesState(...).copyWith(id: 12, name: "My name")
  /// ````
  EdgesState call({
    Object? images = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
    Object? maxImageSize = const $CopyWithPlaceholder(),
    Object? threads = const $CopyWithPlaceholder(),
    Object? grayScaleOn = const $CopyWithPlaceholder(),
    Object? blurOn = const $CopyWithPlaceholder(),
    Object? resizeOn = const $CopyWithPlaceholder(),
    Object? sobelOn = const $CopyWithPlaceholder(),
    Object? bwOn = const $CopyWithPlaceholder(),
    Object? dotsCloudOn = const $CopyWithPlaceholder(),
    Object? painterOn = const $CopyWithPlaceholder(),
  }) {
    return EdgesState(
      images: images == const $CopyWithPlaceholder() || images == null
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as Map<String, ImageResult>,
      settings: settings == const $CopyWithPlaceholder() || settings == null
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as Settings,
      maxImageSize:
          maxImageSize == const $CopyWithPlaceholder() || maxImageSize == null
              ? _value.maxImageSize
              // ignore: cast_nullable_to_non_nullable
              : maxImageSize as int,
      threads: threads == const $CopyWithPlaceholder() || threads == null
          ? _value.threads
          // ignore: cast_nullable_to_non_nullable
          : threads as int,
      grayScaleOn:
          grayScaleOn == const $CopyWithPlaceholder() || grayScaleOn == null
              ? _value.grayScaleOn
              // ignore: cast_nullable_to_non_nullable
              : grayScaleOn as bool,
      blurOn: blurOn == const $CopyWithPlaceholder() || blurOn == null
          ? _value.blurOn
          // ignore: cast_nullable_to_non_nullable
          : blurOn as bool,
      resizeOn: resizeOn == const $CopyWithPlaceholder() || resizeOn == null
          ? _value.resizeOn
          // ignore: cast_nullable_to_non_nullable
          : resizeOn as bool,
      sobelOn: sobelOn == const $CopyWithPlaceholder() || sobelOn == null
          ? _value.sobelOn
          // ignore: cast_nullable_to_non_nullable
          : sobelOn as bool,
      bwOn: bwOn == const $CopyWithPlaceholder() || bwOn == null
          ? _value.bwOn
          // ignore: cast_nullable_to_non_nullable
          : bwOn as bool,
      dotsCloudOn:
          dotsCloudOn == const $CopyWithPlaceholder() || dotsCloudOn == null
              ? _value.dotsCloudOn
              // ignore: cast_nullable_to_non_nullable
              : dotsCloudOn as bool,
      painterOn: painterOn == const $CopyWithPlaceholder() || painterOn == null
          ? _value.painterOn
          // ignore: cast_nullable_to_non_nullable
          : painterOn as bool,
    );
  }
}

extension $EdgesStateCopyWith on EdgesState {
  /// Returns a callable class that can be used as follows: `instanceOfEdgesState.copyWith(...)` or like so:`instanceOfEdgesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EdgesStateCWProxy get copyWith => _$EdgesStateCWProxyImpl(this);
}
