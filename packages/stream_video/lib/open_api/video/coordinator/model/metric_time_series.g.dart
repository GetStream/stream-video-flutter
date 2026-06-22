// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_time_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricTimeSeries _$MetricTimeSeriesFromJson(Map<String, dynamic> json) =>
    MetricTimeSeries(
      dataPoints: (json['data_points'] as List<dynamic>?)
          ?.map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
    );

Map<String, dynamic> _$MetricTimeSeriesToJson(MetricTimeSeries instance) =>
    <String, dynamic>{'data_points': instance.dataPoints};
