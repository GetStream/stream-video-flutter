// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_report_ready_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallStatsReportReadyEvent _$CallStatsReportReadyEventFromJson(
  Map<String, dynamic> json,
) => CallStatsReportReadyEvent(
  callCid: json['call_cid'] as String,
  counts: CallStatsParticipantCounts.fromJson(
    json['counts'] as Map<String, dynamic>,
  ),
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  isTrimmed: json['is_trimmed'] as bool?,
  participantsOverview: (json['participants_overview'] as List<dynamic>?)
      ?.map((e) => CallStatsParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallStatsReportReadyEventToJson(
  CallStatsReportReadyEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'counts': instance.counts.toJson(),
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'is_trimmed': instance.isTrimmed,
  'participants_overview': instance.participantsOverview
      ?.map((e) => e.toJson())
      .toList(),
  'session_id': instance.sessionId,
  'type': instance.type,
};
