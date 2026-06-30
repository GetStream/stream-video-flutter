// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_count_over_time_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantCountOverTimeResponse {
  List<ParticipantCountByMinuteResponse>? get byMinute;

  /// Create a copy of ParticipantCountOverTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantCountOverTimeResponseCopyWith<ParticipantCountOverTimeResponse>
  get copyWith =>
      _$ParticipantCountOverTimeResponseCopyWithImpl<
        ParticipantCountOverTimeResponse
      >(this as ParticipantCountOverTimeResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantCountOverTimeResponse &&
            const DeepCollectionEquality().equals(other.byMinute, byMinute));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(byMinute));

  @override
  String toString() {
    return 'ParticipantCountOverTimeResponse(byMinute: $byMinute)';
  }
}

/// @nodoc
abstract mixin class $ParticipantCountOverTimeResponseCopyWith<$Res> {
  factory $ParticipantCountOverTimeResponseCopyWith(
    ParticipantCountOverTimeResponse value,
    $Res Function(ParticipantCountOverTimeResponse) _then,
  ) = _$ParticipantCountOverTimeResponseCopyWithImpl;
  @useResult
  $Res call({List<ParticipantCountByMinuteResponse>? byMinute});
}

/// @nodoc
class _$ParticipantCountOverTimeResponseCopyWithImpl<$Res>
    implements $ParticipantCountOverTimeResponseCopyWith<$Res> {
  _$ParticipantCountOverTimeResponseCopyWithImpl(this._self, this._then);

  final ParticipantCountOverTimeResponse _self;
  final $Res Function(ParticipantCountOverTimeResponse) _then;

  /// Create a copy of ParticipantCountOverTimeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? byMinute = freezed}) {
    return _then(
      ParticipantCountOverTimeResponse(
        byMinute: freezed == byMinute
            ? _self.byMinute
            : byMinute // ignore: cast_nullable_to_non_nullable
                  as List<ParticipantCountByMinuteResponse>?,
      ),
    );
  }
}
