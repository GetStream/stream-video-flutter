// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_series_subscriber_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSeriesSubscriberStats _$ParticipantSeriesSubscriberStatsFromJson(
  Map<String, dynamic> json,
) => ParticipantSeriesSubscriberStats(
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
  subscriptions: (json['subscriptions'] as List<dynamic>?)
      ?.map(
        (e) => ParticipantSeriesSubscriptionTrackMetrics.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ParticipantSeriesSubscriberStatsToJson(
  ParticipantSeriesSubscriberStats instance,
) => <String, dynamic>{
  'global': instance.global,
  'global_meta': instance.globalMeta?.map((k, e) => MapEntry(k, e.toJson())),
  'global_metrics_order': instance.globalMetricsOrder,
  'global_thresholds': instance.globalThresholds?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'subscriptions': instance.subscriptions?.map((e) => e.toJson()).toList(),
};
