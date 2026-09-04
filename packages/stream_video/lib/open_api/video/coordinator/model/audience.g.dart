// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audience.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audience _$AudienceFromJson(Map<String, dynamic> json) => Audience(
  avgConcurrentViewers: (json['avg_concurrent_viewers'] as num).toInt(),
  concurrencyByMinute: (json['concurrency_by_minute'] as List<dynamic>)
      .map((e) => ConcurrencyMinute.fromJson(e as Map<String, dynamic>))
      .toList(),
  hoursWatched: (json['hours_watched'] as num).toDouble(),
  peakAt: json['peak_at'] as String?,
  peakConcurrentViewers: (json['peak_concurrent_viewers'] as num).toInt(),
  rampUpMinTo90pctPeak: (json['ramp_up_min_to_90pct_peak'] as num?)?.toInt(),
  retentionAt90pctMark: (json['retention_at_90pct_mark'] as num?)?.toDouble(),
  retentionAtMidpoint: (json['retention_at_midpoint'] as num?)?.toDouble(),
  shape: json['shape'] as String?,
  uniqueViewers: (json['unique_viewers'] as num).toInt(),
  viewerConnections: (json['viewer_connections'] as num).toInt(),
);

Map<String, dynamic> _$AudienceToJson(Audience instance) => <String, dynamic>{
  'avg_concurrent_viewers': instance.avgConcurrentViewers,
  'concurrency_by_minute': instance.concurrencyByMinute
      .map((e) => e.toJson())
      .toList(),
  'hours_watched': instance.hoursWatched,
  'peak_at': instance.peakAt,
  'peak_concurrent_viewers': instance.peakConcurrentViewers,
  'ramp_up_min_to_90pct_peak': instance.rampUpMinTo90pctPeak,
  'retention_at_90pct_mark': instance.retentionAt90pctMark,
  'retention_at_midpoint': instance.retentionAtMidpoint,
  'shape': instance.shape,
  'unique_viewers': instance.uniqueViewers,
  'viewer_connections': instance.viewerConnections,
};
