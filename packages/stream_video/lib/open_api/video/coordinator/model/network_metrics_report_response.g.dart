// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_metrics_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkMetricsReportResponse _$NetworkMetricsReportResponseFromJson(
  Map<String, dynamic> json,
) => NetworkMetricsReportResponse(
  averageConnectionTime: (json['average_connection_time'] as num?)?.toDouble(),
  averageJitter: (json['average_jitter'] as num?)?.toDouble(),
  averageLatency: (json['average_latency'] as num?)?.toDouble(),
  averageTimeToReconnect: (json['average_time_to_reconnect'] as num?)
      ?.toDouble(),
);

Map<String, dynamic> _$NetworkMetricsReportResponseToJson(
  NetworkMetricsReportResponse instance,
) => <String, dynamic>{
  'average_connection_time': instance.averageConnectionTime,
  'average_jitter': instance.averageJitter,
  'average_latency': instance.averageLatency,
  'average_time_to_reconnect': instance.averageTimeToReconnect,
};
