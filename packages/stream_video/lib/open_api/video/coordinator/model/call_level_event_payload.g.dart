// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_level_event_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallLevelEventPayload _$CallLevelEventPayloadFromJson(
  Map<String, dynamic> json,
) => CallLevelEventPayload(
  eventType: json['event_type'] as String,
  payload: json['payload'] as Map<String, dynamic>?,
  timestamp: (json['timestamp'] as num).toInt(),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallLevelEventPayloadToJson(
  CallLevelEventPayload instance,
) => <String, dynamic>{
  'event_type': instance.eventType,
  'payload': instance.payload,
  'timestamp': instance.timestamp,
  'user_id': instance.userId,
};
