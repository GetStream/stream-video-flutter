// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quality _$QualityFromJson(Map<String, dynamic> json) => Quality(
  connectionAvgJitterMs: Percentiles.fromJson(
    json['connection_avg_jitter_ms'] as Map<String, dynamic>,
  ),
  connectionAvgLatencyMs: Percentiles.fromJson(
    json['connection_avg_latency_ms'] as Map<String, dynamic>,
  ),
  interruptionIncidents: (json['interruption_incidents'] as List<dynamic>)
      .map((e) => Incident.fromJson(e as Map<String, dynamic>))
      .toList(),
  p50QualityScore: (json['p50_quality_score'] as num?)?.toDouble(),
  p5QualityScore: (json['p5_quality_score'] as num?)?.toDouble(),
  scoreBandsByConnectionPct: ScoreBands.fromJson(
    json['score_bands_by_connection_pct'] as Map<String, dynamic>,
  ),
  scoreBandsByWatchTimePct: ScoreBands.fromJson(
    json['score_bands_by_watch_time_pct'] as Map<String, dynamic>,
  ),
  viewerInterruptionNote: json['viewer_interruption_note'] as String,
  viewerInterruptionRatePct: (json['viewer_interruption_rate_pct'] as num?)
      ?.toDouble(),
);

Map<String, dynamic> _$QualityToJson(Quality instance) => <String, dynamic>{
  'connection_avg_jitter_ms': instance.connectionAvgJitterMs.toJson(),
  'connection_avg_latency_ms': instance.connectionAvgLatencyMs.toJson(),
  'interruption_incidents': instance.interruptionIncidents
      .map((e) => e.toJson())
      .toList(),
  'p50_quality_score': instance.p50QualityScore,
  'p5_quality_score': instance.p5QualityScore,
  'score_bands_by_connection_pct': instance.scoreBandsByConnectionPct.toJson(),
  'score_bands_by_watch_time_pct': instance.scoreBandsByWatchTimePct.toJson(),
  'viewer_interruption_note': instance.viewerInterruptionNote,
  'viewer_interruption_rate_pct': instance.viewerInterruptionRatePct,
};
