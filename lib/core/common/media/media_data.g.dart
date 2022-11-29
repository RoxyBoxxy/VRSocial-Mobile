// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaDataCWProxy {
  MediaData id(String? id);

  MediaData path(String? path);

  MediaData thumbnail(String? thumbnail);

  MediaData type(MediaTypeEnum? type);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaData(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaData call({
    String? id,
    String? path,
    String? thumbnail,
    MediaTypeEnum? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMediaData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMediaData.copyWith.fieldName(...)`
class _$MediaDataCWProxyImpl implements _$MediaDataCWProxy {
  final MediaData _value;

  const _$MediaDataCWProxyImpl(this._value);

  @override
  MediaData id(String? id) => this(id: id);

  @override
  MediaData path(String? path) => this(path: path);

  @override
  MediaData thumbnail(String? thumbnail) => this(thumbnail: thumbnail);

  @override
  MediaData type(MediaTypeEnum? type) => this(type: type);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MediaData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MediaData(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaData call({
    Object? id = const $CopyWithPlaceholder(),
    Object? path = const $CopyWithPlaceholder(),
    Object? thumbnail = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return MediaData(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      path: path == const $CopyWithPlaceholder()
          ? _value.path
          // ignore: cast_nullable_to_non_nullable
          : path as String?,
      thumbnail: thumbnail == const $CopyWithPlaceholder()
          ? _value.thumbnail
          // ignore: cast_nullable_to_non_nullable
          : thumbnail as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as MediaTypeEnum?,
    );
  }
}

extension $MediaDataCopyWith on MediaData {
  /// Returns a callable class that can be used as follows: `instanceOfMediaData.copyWith(...)` or like so:`instanceOfMediaData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaDataCWProxy get copyWith => _$MediaDataCWProxyImpl(this);
}
