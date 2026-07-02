// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsSessionResponse {
  DateTime? get callEndedAt;
  String get callId;
  String get callSessionId;
  DateTime? get callStartedAt;
  String get callType;
  CallStatsParticipantCounts get counts;
  DateTime get generatedAt;

  /// Create a copy of CallStatsSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsSessionResponseCopyWith<CallStatsSessionResponse> get copyWith =>
      _$CallStatsSessionResponseCopyWithImpl<CallStatsSessionResponse>(
        this as CallStatsSessionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsSessionResponse &&
            (identical(other.callEndedAt, callEndedAt) ||
                other.callEndedAt == callEndedAt) &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.callSessionId, callSessionId) ||
                other.callSessionId == callSessionId) &&
            (identical(other.callStartedAt, callStartedAt) ||
                other.callStartedAt == callStartedAt) &&
            (identical(other.callType, callType) ||
                other.callType == callType) &&
            (identical(other.counts, counts) || other.counts == counts) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callEndedAt,
    callId,
    callSessionId,
    callStartedAt,
    callType,
    counts,
    generatedAt,
  );

  @override
  String toString() {
    return 'CallStatsSessionResponse(callEndedAt: $callEndedAt, callId: $callId, callSessionId: $callSessionId, callStartedAt: $callStartedAt, callType: $callType, counts: $counts, generatedAt: $generatedAt)';
  }
}

/// @nodoc
abstract mixin class $CallStatsSessionResponseCopyWith<$Res> {
  factory $CallStatsSessionResponseCopyWith(
    CallStatsSessionResponse value,
    $Res Function(CallStatsSessionResponse) _then,
  ) = _$CallStatsSessionResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime? callEndedAt,
    String callId,
    String callSessionId,
    DateTime? callStartedAt,
    String callType,
    CallStatsParticipantCounts counts,
    DateTime generatedAt,
  });
}

/// @nodoc
class _$CallStatsSessionResponseCopyWithImpl<$Res>
    implements $CallStatsSessionResponseCopyWith<$Res> {
  _$CallStatsSessionResponseCopyWithImpl(this._self, this._then);

  final CallStatsSessionResponse _self;
  final $Res Function(CallStatsSessionResponse) _then;

  /// Create a copy of CallStatsSessionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callEndedAt = freezed,
    Object? callId = null,
    Object? callSessionId = null,
    Object? callStartedAt = freezed,
    Object? callType = null,
    Object? counts = null,
    Object? generatedAt = null,
  }) {
    return _then(
      CallStatsSessionResponse(
        callEndedAt: freezed == callEndedAt
            ? _self.callEndedAt
            : callEndedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        callId: null == callId
            ? _self.callId
            : callId // ignore: cast_nullable_to_non_nullable
                  as String,
        callSessionId: null == callSessionId
            ? _self.callSessionId
            : callSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        callStartedAt: freezed == callStartedAt
            ? _self.callStartedAt
            : callStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        callType: null == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String,
        counts: null == counts
            ? _self.counts
            : counts // ignore: cast_nullable_to_non_nullable
                  as CallStatsParticipantCounts,
        generatedAt: null == generatedAt
            ? _self.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
