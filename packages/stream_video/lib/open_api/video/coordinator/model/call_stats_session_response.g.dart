// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsSessionResponse _$CallStatsSessionResponseFromJson(
  Map<String, dynamic> json,
) => CallStatsSessionResponse(
  callEndedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['call_ended_at'],
    const EpochDateTimeConverter().fromJson,
  ),
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
  generatedAt: const EpochDateTimeConverter().fromJson(
    json['generated_at'] as Object,
  ),
);

Map<String, dynamic> _$CallStatsSessionResponseToJson(
  CallStatsSessionResponse instance,
) => <String, dynamic>{
  'call_ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.callEndedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'call_id': instance.callId,
  'call_session_id': instance.callSessionId,
  'call_started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.callStartedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'call_type': instance.callType,
  'counts': instance.counts,
  'generated_at': const EpochDateTimeConverter().toJson(instance.generatedAt),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
