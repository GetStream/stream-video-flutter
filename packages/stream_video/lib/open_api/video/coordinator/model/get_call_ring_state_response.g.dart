// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_ring_state_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCallRingStateResponse _$GetCallRingStateResponseFromJson(
  Map<String, dynamic> json,
) => GetCallRingStateResponse(
  acceptedBy: (json['accepted_by'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, const StreamDateTimeConverter().fromJson(e as Object)),
  ),
  callCid: json['call_cid'] as String,
  callEndedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['call_ended_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  createdByUserId: json['created_by_user_id'] as String,
  duration: json['duration'] as String,
  missedBy: (json['missed_by'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, const StreamDateTimeConverter().fromJson(e as Object)),
  ),
  rejectedBy: (json['rejected_by'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, const StreamDateTimeConverter().fromJson(e as Object)),
  ),
  sessionEndedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['session_ended_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  sessionId: json['session_id'] as String,
  sessionStartedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['session_started_at'],
    const StreamDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$GetCallRingStateResponseToJson(
  GetCallRingStateResponse instance,
) => <String, dynamic>{
  'accepted_by': instance.acceptedBy.map(
    (k, e) => MapEntry(k, const StreamDateTimeConverter().toJson(e)),
  ),
  'call_cid': instance.callCid,
  'call_ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.callEndedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'created_by_user_id': instance.createdByUserId,
  'duration': instance.duration,
  'missed_by': instance.missedBy.map(
    (k, e) => MapEntry(k, const StreamDateTimeConverter().toJson(e)),
  ),
  'rejected_by': instance.rejectedBy.map(
    (k, e) => MapEntry(k, const StreamDateTimeConverter().toJson(e)),
  ),
  'session_ended_at': _$JsonConverterToJson<Object, DateTime>(
    instance.sessionEndedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'session_id': instance.sessionId,
  'session_started_at': _$JsonConverterToJson<Object, DateTime>(
    instance.sessionStartedAt,
    const StreamDateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
