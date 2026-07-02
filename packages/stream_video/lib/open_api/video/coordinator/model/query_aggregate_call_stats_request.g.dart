// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_aggregate_call_stats_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryAggregateCallStatsRequest _$QueryAggregateCallStatsRequestFromJson(
  Map<String, dynamic> json,
) => QueryAggregateCallStatsRequest(
  from: json['from'] as String?,
  reportTypes: (json['report_types'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  to: json['to'] as String?,
);

Map<String, dynamic> _$QueryAggregateCallStatsRequestToJson(
  QueryAggregateCallStatsRequest instance,
) => <String, dynamic>{
  'from': instance.from,
  'report_types': instance.reportTypes,
  'to': instance.to,
};
