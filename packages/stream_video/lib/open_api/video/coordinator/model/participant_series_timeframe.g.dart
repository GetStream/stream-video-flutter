// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_timeframe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesTimeframe _$ParticipantSeriesTimeframeFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesTimeframe(
  maxPoints: (json['max_points'] as num).toInt(),
  since: const EpochDateTimeConverter().fromJson(json['since'] as Object),
  stepSeconds: (json['step_seconds'] as num).toInt(),
  until: const EpochDateTimeConverter().fromJson(json['until'] as Object),
);

Map<String, dynamic> _$ParticipantSeriesTimeframeToJson(
  ParticipantSeriesTimeframe instance,
) => <String, dynamic>{
  'max_points': instance.maxPoints,
  'since': const EpochDateTimeConverter().toJson(instance.since),
  'step_seconds': instance.stepSeconds,
  'until': const EpochDateTimeConverter().toJson(instance.until),
};
