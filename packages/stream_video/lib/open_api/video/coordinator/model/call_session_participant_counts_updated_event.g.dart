// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_session_participant_counts_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSessionParticipantCountsUpdatedEvent
_$CallSessionParticipantCountsUpdatedEventFromJson(Map<String, dynamic> json) =>
    CallSessionParticipantCountsUpdatedEvent(
      anonymousParticipantCount: (json['anonymous_participant_count'] as num)
          .toInt(),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      participantsCountByRole: Map<String, int>.from(
        json['participants_count_by_role'] as Map,
      ),
      sessionId: json['session_id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallSessionParticipantCountsUpdatedEventToJson(
  CallSessionParticipantCountsUpdatedEvent instance,
) => <String, dynamic>{
  'anonymous_participant_count': instance.anonymousParticipantCount,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'participants_count_by_role': instance.participantsCountByRole,
  'session_id': instance.sessionId,
  'type': instance.type,
};
