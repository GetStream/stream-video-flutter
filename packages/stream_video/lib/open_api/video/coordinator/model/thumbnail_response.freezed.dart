// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thumbnail_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThumbnailResponse {
  String get imageUrl;

  /// Create a copy of ThumbnailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThumbnailResponseCopyWith<ThumbnailResponse> get copyWith =>
      _$ThumbnailResponseCopyWithImpl<ThumbnailResponse>(
        this as ThumbnailResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThumbnailResponse &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imageUrl);

  @override
  String toString() {
    return 'ThumbnailResponse(imageUrl: $imageUrl)';
  }
}

/// @nodoc
abstract mixin class $ThumbnailResponseCopyWith<$Res> {
  factory $ThumbnailResponseCopyWith(
    ThumbnailResponse value,
    $Res Function(ThumbnailResponse) _then,
  ) = _$ThumbnailResponseCopyWithImpl;
  @useResult
  $Res call({String imageUrl});
}

/// @nodoc
class _$ThumbnailResponseCopyWithImpl<$Res>
    implements $ThumbnailResponseCopyWith<$Res> {
  _$ThumbnailResponseCopyWithImpl(this._self, this._then);

  final ThumbnailResponse _self;
  final $Res Function(ThumbnailResponse) _then;

  /// Create a copy of ThumbnailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? imageUrl = null}) {
    return _then(
      ThumbnailResponse(
        imageUrl: null == imageUrl
            ? _self.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
