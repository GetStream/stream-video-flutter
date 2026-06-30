// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_stats_map_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallStatsMapResponse _$QueryCallStatsMapResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallStatsMapResponse(
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
  dataSource: json['data_source'] as String?,
  duration: json['duration'] as String,
  endTime: _$JsonConverterFromJson<Object, DateTime>(
    json['end_time'],
    const EpochDateTimeConverter().fromJson,
  ),
  generatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['generated_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  publishers: json['publishers'] == null
      ? null
      : CallStatsMapPublishers.fromJson(
          json['publishers'] as Map<String, dynamic>,
        ),
  sfus: json['sfus'] == null
      ? null
      : CallStatsMapSFUs.fromJson(json['sfus'] as Map<String, dynamic>),
  startTime: _$JsonConverterFromJson<Object, DateTime>(
    json['start_time'],
    const EpochDateTimeConverter().fromJson,
  ),
  subscribers: json['subscribers'] == null
      ? null
      : CallStatsMapSubscribers.fromJson(
          json['subscribers'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QueryCallStatsMapResponseToJson(
  QueryCallStatsMapResponse instance,
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
  'counts': instance.counts.toJson(),
  'data_source': instance.dataSource,
  'duration': instance.duration,
  'end_time': _$JsonConverterToJson<Object, DateTime>(
    instance.endTime,
    const EpochDateTimeConverter().toJson,
  ),
  'generated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.generatedAt,
    const EpochDateTimeConverter().toJson,
  ),
  'publishers': instance.publishers?.toJson(),
  'sfus': instance.sfus?.toJson(),
  'start_time': _$JsonConverterToJson<Object, DateTime>(
    instance.startTime,
    const EpochDateTimeConverter().toJson,
  ),
  'subscribers': instance.subscribers?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
