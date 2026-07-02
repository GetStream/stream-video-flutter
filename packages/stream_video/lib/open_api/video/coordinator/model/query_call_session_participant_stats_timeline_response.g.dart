// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_session_participant_stats_timeline_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallSessionParticipantStatsTimelineResponse
_$QueryCallSessionParticipantStatsTimelineResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallSessionParticipantStatsTimelineResponse(
  callId: json['call_id'] as String,
  callSessionId: json['call_session_id'] as String,
  callType: json['call_type'] as String,
  duration: json['duration'] as String,
  events:
      (json['events'] as List<dynamic>?)
          ?.map(
            (e) => CallParticipantTimeline.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  userId: json['user_id'] as String,
  userSessionId: json['user_session_id'] as String,
);

Map<String, dynamic> _$QueryCallSessionParticipantStatsTimelineResponseToJson(
  QueryCallSessionParticipantStatsTimelineResponse instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'call_session_id': instance.callSessionId,
  'call_type': instance.callType,
  'duration': instance.duration,
  'events': instance.events.map((e) => e.toJson()).toList(),
  'user_id': instance.userId,
  'user_session_id': instance.userSessionId,
};
