// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_session_participant_stats_timeline_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryCallSessionParticipantStatsTimelineResponse {
  String get callId;
  String get callSessionId;
  String get callType;
  String get duration;
  List<CallParticipantTimeline> get events;
  String get userId;
  String get userSessionId;

  /// Create a copy of QueryCallSessionParticipantStatsTimelineResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryCallSessionParticipantStatsTimelineResponseCopyWith<
    QueryCallSessionParticipantStatsTimelineResponse
  >
  get copyWith =>
      _$QueryCallSessionParticipantStatsTimelineResponseCopyWithImpl<
        QueryCallSessionParticipantStatsTimelineResponse
      >(this as QueryCallSessionParticipantStatsTimelineResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryCallSessionParticipantStatsTimelineResponse &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.callSessionId, callSessionId) ||
                other.callSessionId == callSessionId) &&
            (identical(other.callType, callType) ||
                other.callType == callType) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.events, events) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userSessionId, userSessionId) ||
                other.userSessionId == userSessionId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callId,
    callSessionId,
    callType,
    duration,
    const DeepCollectionEquality().hash(events),
    userId,
    userSessionId,
  );

  @override
  String toString() {
    return 'QueryCallSessionParticipantStatsTimelineResponse(callId: $callId, callSessionId: $callSessionId, callType: $callType, duration: $duration, events: $events, userId: $userId, userSessionId: $userSessionId)';
  }
}

/// @nodoc
abstract mixin class $QueryCallSessionParticipantStatsTimelineResponseCopyWith<
  $Res
> {
  factory $QueryCallSessionParticipantStatsTimelineResponseCopyWith(
    QueryCallSessionParticipantStatsTimelineResponse value,
    $Res Function(QueryCallSessionParticipantStatsTimelineResponse) _then,
  ) = _$QueryCallSessionParticipantStatsTimelineResponseCopyWithImpl;
  @useResult
  $Res call({
    String callId,
    String callSessionId,
    String callType,
    String duration,
    List<CallParticipantTimeline> events,
    String userId,
    String userSessionId,
  });
}

/// @nodoc
class _$QueryCallSessionParticipantStatsTimelineResponseCopyWithImpl<$Res>
    implements $QueryCallSessionParticipantStatsTimelineResponseCopyWith<$Res> {
  _$QueryCallSessionParticipantStatsTimelineResponseCopyWithImpl(
    this._self,
    this._then,
  );

  final QueryCallSessionParticipantStatsTimelineResponse _self;
  final $Res Function(QueryCallSessionParticipantStatsTimelineResponse) _then;

  /// Create a copy of QueryCallSessionParticipantStatsTimelineResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callId = null,
    Object? callSessionId = null,
    Object? callType = null,
    Object? duration = null,
    Object? events = null,
    Object? userId = null,
    Object? userSessionId = null,
  }) {
    return _then(
      QueryCallSessionParticipantStatsTimelineResponse(
        callId: null == callId
            ? _self.callId
            : callId // ignore: cast_nullable_to_non_nullable
                  as String,
        callSessionId: null == callSessionId
            ? _self.callSessionId
            : callSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        callType: null == callType
            ? _self.callType
            : callType // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        events: null == events
            ? _self.events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<CallParticipantTimeline>,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userSessionId: null == userSessionId
            ? _self.userSessionId
            : userSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
