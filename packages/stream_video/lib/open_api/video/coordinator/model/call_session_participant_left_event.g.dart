// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_left_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionParticipantLeftEvent _$CallSessionParticipantLeftEventFromJson(
  Map<String, dynamic> json,
) => CallSessionParticipantLeftEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  durationSeconds: (json['duration_seconds'] as num).toInt(),
  participant: CallParticipantResponse.fromJson(
    json['participant'] as Map<String, dynamic>,
  ),
  reason: json['reason'] as String?,
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallSessionParticipantLeftEventToJson(
  CallSessionParticipantLeftEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'duration_seconds': instance.durationSeconds,
  'participant': instance.participant,
  'reason': instance.reason,
  'session_id': instance.sessionId,
  'type': instance.type,
};
