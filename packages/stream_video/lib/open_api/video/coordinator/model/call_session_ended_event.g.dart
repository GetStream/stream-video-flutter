// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_ended_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionEndedEvent _$CallSessionEndedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionEndedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionEndedEventToJson(
  CallSessionEndedEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'session_id': instance.sessionId,
  'type': instance.type,
};
