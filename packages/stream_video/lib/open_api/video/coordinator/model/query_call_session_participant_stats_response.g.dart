// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_session_participant_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallSessionParticipantStatsResponse
_$QueryCallSessionParticipantStatsResponseFromJson(Map<String, dynamic> json) =>
    QueryCallSessionParticipantStatsResponse(
      callEndedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['call_ended_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      callEvents: (json['call_events'] as List<dynamic>?)
          ?.map(
            (e) => CallLevelEventPayload.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      callId: json['call_id'] as String,
      callSessionId: json['call_session_id'] as String,
      callStartedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['call_started_at'],
        const EpochDateTimeConverter().fromJson,
      ),
      callType: json['call_type'] as String,
      counts: CallStatsParticipantCounts.fromJson(
        json['counts'] as Map<String, dynamic>,
      ),
      duration: json['duration'] as String,
      next: json['next'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => CallStatsParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      prev: json['prev'] as String?,
      tmpDataSource: json['tmp_data_source'] as String?,
    );

Map<String, dynamic> _$QueryCallSessionParticipantStatsResponseToJson(
  QueryCallSessionParticipantStatsResponse instance,
) => <String, dynamic>{
  'call_ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.callEndedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'call_events': instance.callEvents,
  'call_id': instance.callId,
  'call_session_id': instance.callSessionId,
  'call_started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.callStartedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'call_type': instance.callType,
  'counts': instance.counts,
  'duration': instance.duration,
  'next': instance.next,
  'participants': instance.participants,
  'prev': instance.prev,
  'tmp_data_source': instance.tmpDataSource,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
