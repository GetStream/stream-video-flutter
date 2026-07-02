// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_participant_sessions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallParticipantSessionsResponse
_$QueryCallParticipantSessionsResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallParticipantSessionsResponse(
  callId: json['call_id'] as String,
  callSessionId: json['call_session_id'] as String,
  callType: json['call_type'] as String,
  duration: (json['duration'] as num).toInt(),
  next: json['next'] as String?,
  participantsSessions:
      (json['participants_sessions'] as List<dynamic>?)
          ?.map(
            (e) =>
                ParticipantSessionDetails.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  prev: json['prev'] as String?,
  session: json['session'] == null
      ? null
      : CallSessionResponse.fromJson(json['session'] as Map<String, dynamic>),
  totalParticipantDuration: (json['total_participant_duration'] as num).toInt(),
  totalParticipantSessions: (json['total_participant_sessions'] as num).toInt(),
);

Map<String, dynamic> _$QueryCallParticipantSessionsResponseToJson(
  QueryCallParticipantSessionsResponse instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'call_session_id': instance.callSessionId,
  'call_type': instance.callType,
  'duration': instance.duration,
  'next': instance.next,
  'participants_sessions': instance.participantsSessions
      .map((e) => e.toJson())
      .toList(),
  'prev': instance.prev,
  'session': instance.session?.toJson(),
  'total_participant_duration': instance.totalParticipantDuration,
  'total_participant_sessions': instance.totalParticipantSessions,
};
