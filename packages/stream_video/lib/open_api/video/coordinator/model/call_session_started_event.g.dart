// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionStartedEvent _$CallSessionStartedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionStartedEventToJson(
  CallSessionStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'session_id': instance.sessionId,
  'type': instance.type,
};
