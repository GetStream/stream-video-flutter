// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ring_call_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RingCallResponse {
  String get duration;
  List<String> get membersIds;

  /// Create a copy of RingCallResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RingCallResponseCopyWith<RingCallResponse> get copyWith =>
      _$RingCallResponseCopyWithImpl<RingCallResponse>(
        this as RingCallResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RingCallResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other.membersIds,
              membersIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(membersIds),
  );

  @override
  String toString() {
    return 'RingCallResponse(duration: $duration, membersIds: $membersIds)';
  }
}

/// @nodoc
abstract mixin class $RingCallResponseCopyWith<$Res> {
  factory $RingCallResponseCopyWith(
    RingCallResponse value,
    $Res Function(RingCallResponse) _then,
  ) = _$RingCallResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<String> membersIds});
}

/// @nodoc
class _$RingCallResponseCopyWithImpl<$Res>
    implements $RingCallResponseCopyWith<$Res> {
  _$RingCallResponseCopyWithImpl(this._self, this._then);

  final RingCallResponse _self;
  final $Res Function(RingCallResponse) _then;

  /// Create a copy of RingCallResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? membersIds = null}) {
    return _then(
      RingCallResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        membersIds: null == membersIds
            ? _self.membersIds
            : membersIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
