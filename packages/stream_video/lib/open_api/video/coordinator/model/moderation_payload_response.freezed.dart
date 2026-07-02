// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_payload_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationPayloadResponse {
  Map<String, Object?>? get custom;
  List<String>? get images;
  List<String>? get texts;
  List<String>? get videos;

  /// Create a copy of ModerationPayloadResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationPayloadResponseCopyWith<ModerationPayloadResponse> get copyWith =>
      _$ModerationPayloadResponseCopyWithImpl<ModerationPayloadResponse>(
        this as ModerationPayloadResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationPayloadResponse &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            const DeepCollectionEquality().equals(other.texts, texts) &&
            const DeepCollectionEquality().equals(other.videos, videos));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(images),
    const DeepCollectionEquality().hash(texts),
    const DeepCollectionEquality().hash(videos),
  );

  @override
  String toString() {
    return 'ModerationPayloadResponse(custom: $custom, images: $images, texts: $texts, videos: $videos)';
  }
}

/// @nodoc
abstract mixin class $ModerationPayloadResponseCopyWith<$Res> {
  factory $ModerationPayloadResponseCopyWith(
    ModerationPayloadResponse value,
    $Res Function(ModerationPayloadResponse) _then,
  ) = _$ModerationPayloadResponseCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? custom,
    List<String>? images,
    List<String>? texts,
    List<String>? videos,
  });
}

/// @nodoc
class _$ModerationPayloadResponseCopyWithImpl<$Res>
    implements $ModerationPayloadResponseCopyWith<$Res> {
  _$ModerationPayloadResponseCopyWithImpl(this._self, this._then);

  final ModerationPayloadResponse _self;
  final $Res Function(ModerationPayloadResponse) _then;

  /// Create a copy of ModerationPayloadResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? images = freezed,
    Object? texts = freezed,
    Object? videos = freezed,
  }) {
    return _then(
      ModerationPayloadResponse(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        images: freezed == images
            ? _self.images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        texts: freezed == texts
            ? _self.texts
            : texts // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        videos: freezed == videos
            ? _self.videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
