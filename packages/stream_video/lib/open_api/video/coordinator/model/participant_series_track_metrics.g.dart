// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_track_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesTrackMetrics _$ParticipantSeriesTrackMetricsFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesTrackMetrics(
  codec: json['codec'] as String?,
  label: json['label'] as String?,
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
  rid: json['rid'] as String?,
  thresholds: (json['thresholds'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => MetricThreshold.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  trackId: json['track_id'] as String,
  trackType: json['track_type'] as String?,
);

Map<String, dynamic> _$ParticipantSeriesTrackMetricsToJson(
  ParticipantSeriesTrackMetrics instance,
) => <String, dynamic>{
  'codec': instance.codec,
  'label': instance.label,
  'metrics': instance.metrics,
  'metrics_meta': instance.metricsMeta?.map((k, e) => MapEntry(k, e.toJson())),
  'metrics_order': instance.metricsOrder,
  'rid': instance.rid,
  'thresholds': instance.thresholds?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'track_id': instance.trackId,
  'track_type': instance.trackType,
};
