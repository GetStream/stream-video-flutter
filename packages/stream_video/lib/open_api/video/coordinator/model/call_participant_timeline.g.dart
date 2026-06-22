// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallParticipantTimeline _$CallParticipantTimelineFromJson(
  Map<String, dynamic> json,
) => CallParticipantTimeline(
  data: json['data'] as Map<String, dynamic>? ?? {},
  severity: json['severity'] as String,
  timestamp: const EpochDateTimeConverter().fromJson(
    json['timestamp'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallParticipantTimelineToJson(
  CallParticipantTimeline instance,
) => <String, dynamic>{
  'data': instance.data,
  'severity': instance.severity,
  'timestamp': const EpochDateTimeConverter().toJson(instance.timestamp),
  'type': instance.type,
};
