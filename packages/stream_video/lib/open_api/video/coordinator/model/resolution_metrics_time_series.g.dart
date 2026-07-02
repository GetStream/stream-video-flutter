// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolution_metrics_time_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResolutionMetricsTimeSeries _$ResolutionMetricsTimeSeriesFromJson(
  Map<String, dynamic> json,
) => ResolutionMetricsTimeSeries(
  height: json['height'] == null
      ? null
      : MetricTimeSeries.fromJson(json['height'] as Map<String, dynamic>),
  width: json['width'] == null
      ? null
      : MetricTimeSeries.fromJson(json['width'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ResolutionMetricsTimeSeriesToJson(
  ResolutionMetricsTimeSeries instance,
) => <String, dynamic>{
  'height': instance.height?.toJson(),
  'width': instance.width?.toJson(),
};
