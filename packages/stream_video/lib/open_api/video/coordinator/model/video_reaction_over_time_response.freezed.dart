// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_reaction_over_time_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoReactionOverTimeResponse {
  List<CountByMinuteResponse>? get byMinute;

  /// Create a copy of VideoReactionOverTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoReactionOverTimeResponseCopyWith<VideoReactionOverTimeResponse>
  get copyWith =>
      _$VideoReactionOverTimeResponseCopyWithImpl<
        VideoReactionOverTimeResponse
      >(this as VideoReactionOverTimeResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoReactionOverTimeResponse &&
            const DeepCollectionEquality().equals(other.byMinute, byMinute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(byMinute));

  @override
  String toString() {
    return 'VideoReactionOverTimeResponse(byMinute: $byMinute)';
  }
}

/// @nodoc
abstract mixin class $VideoReactionOverTimeResponseCopyWith<$Res> {
  factory $VideoReactionOverTimeResponseCopyWith(
    VideoReactionOverTimeResponse value,
    $Res Function(VideoReactionOverTimeResponse) _then,
  ) = _$VideoReactionOverTimeResponseCopyWithImpl;
  @useResult
  $Res call({List<CountByMinuteResponse>? byMinute});
}

/// @nodoc
class _$VideoReactionOverTimeResponseCopyWithImpl<$Res>
    implements $VideoReactionOverTimeResponseCopyWith<$Res> {
  _$VideoReactionOverTimeResponseCopyWithImpl(this._self, this._then);

  final VideoReactionOverTimeResponse _self;
  final $Res Function(VideoReactionOverTimeResponse) _then;

  /// Create a copy of VideoReactionOverTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byMinute = freezed}) {
    return _then(
      VideoReactionOverTimeResponse(
        byMinute: freezed == byMinute
            ? _self.byMinute
            : byMinute // ignore: cast_nullable_to_non_nullable
                  as List<CountByMinuteResponse>?,
      ),
    );
  }
}
