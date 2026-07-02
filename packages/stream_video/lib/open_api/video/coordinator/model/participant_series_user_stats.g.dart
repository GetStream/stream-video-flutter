// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesUserStats _$ParticipantSeriesUserStatsFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesUserStats(
  metrics: (json['metrics'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    ),
  ),
  metricsMeta: (json['metrics_meta'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, MetricDescriptor.fromJson(e as Map<String, dynamic>)),
  ),
  metricsOrder: (json['metrics_order'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  thresholds: (json['thresholds'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => MetricThreshold.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$ParticipantSeriesUserStatsToJson(
  ParticipantSeriesUserStats instance,
) => <String, dynamic>{
  'metrics': instance.metrics,
  'metrics_meta': instance.metricsMeta?.map((k, e) => MapEntry(k, e.toJson())),
  'metrics_order': instance.metricsOrder,
  'thresholds': instance.thresholds?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
