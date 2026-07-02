// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_joined_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionParticipantJoinedEvent _$CallSessionParticipantJoinedEventFromJson(
  Map<String, dynamic> json,
) => CallSessionParticipantJoinedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  participant: CallParticipantResponse.fromJson(
    json['participant'] as Map<String, dynamic>,
  ),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionParticipantJoinedEventToJson(
  CallSessionParticipantJoinedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'participant': instance.participant.toJson(),
  'session_id': instance.sessionId,
  'type': instance.type,
};
