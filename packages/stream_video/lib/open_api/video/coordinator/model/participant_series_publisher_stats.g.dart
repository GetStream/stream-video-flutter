// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_publisher_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesPublisherStats _$ParticipantSeriesPublisherStatsFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesPublisherStats(
  global: (json['global'] as Map<String, dynamic>?)?.map(
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
  globalMeta: (json['global_meta'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, MetricDescriptor.fromJson(e as Map<String, dynamic>)),
  ),
  globalMetricsOrder: (json['global_metrics_order'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  globalThresholds: (json['global_thresholds'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => MetricThreshold.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  tracks: (json['tracks'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map(
            (e) => ParticipantSeriesTrackMetrics.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$ParticipantSeriesPublisherStatsToJson(
  ParticipantSeriesPublisherStats instance,
) => <String, dynamic>{
  'global': instance.global,
  'global_meta': instance.globalMeta?.map((k, e) => MapEntry(k, e.toJson())),
  'global_metrics_order': instance.globalMetricsOrder,
  'global_thresholds': instance.globalThresholds?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'tracks': instance.tracks?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
