// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_image.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$TestImageAutoequal on TestImage {
  List<Object?> get _$props => [
        index,
        size,
        card,
        background,
        fullPath,
      ];
}

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TestImageCWProxy {
  TestImage index(int index);

  TestImage size(String size);

  TestImage card(String card);

  TestImage background(String background);

  TestImage fullPath(String fullPath);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestImage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestImage(...).copyWith(id: 12, name: "My name")
  /// ````
  TestImage call({
    int? index,
    String? size,
    String? card,
    String? background,
    String? fullPath,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTestImage.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTestImage.copyWith.fieldName(...)`
class _$TestImageCWProxyImpl implements _$TestImageCWProxy {
  const _$TestImageCWProxyImpl(this._value);

  final TestImage _value;

  @override
  TestImage index(int index) => this(index: index);

  @override
  TestImage size(String size) => this(size: size);

  @override
  TestImage card(String card) => this(card: card);

  @override
  TestImage background(String background) => this(background: background);

  @override
  TestImage fullPath(String fullPath) => this(fullPath: fullPath);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TestImage(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TestImage(...).copyWith(id: 12, name: "My name")
  /// ````
  TestImage call({
    Object? index = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? card = const $CopyWithPlaceholder(),
    Object? background = const $CopyWithPlaceholder(),
    Object? fullPath = const $CopyWithPlaceholder(),
  }) {
    return TestImage(
      index: index == const $CopyWithPlaceholder() || index == null
          ? _value.index
          // ignore: cast_nullable_to_non_nullable
          : index as int,
      size: size == const $CopyWithPlaceholder() || size == null
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as String,
      card: card == const $CopyWithPlaceholder() || card == null
          ? _value.card
          // ignore: cast_nullable_to_non_nullable
          : card as String,
      background:
          background == const $CopyWithPlaceholder() || background == null
              ? _value.background
              // ignore: cast_nullable_to_non_nullable
              : background as String,
      fullPath: fullPath == const $CopyWithPlaceholder() || fullPath == null
          ? _value.fullPath
          // ignore: cast_nullable_to_non_nullable
          : fullPath as String,
    );
  }
}

extension $TestImageCopyWith on TestImage {
  /// Returns a callable class that can be used as follows: `instanceOfTestImage.copyWith(...)` or like so:`instanceOfTestImage.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TestImageCWProxy get copyWith => _$TestImageCWProxyImpl(this);
}
