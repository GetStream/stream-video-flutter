// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryCallStatsResponse _$QueryCallStatsResponseFromJson(
  Map<String, dynamic> json,
) => QueryCallStatsResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  reports:
      (json['reports'] as List<dynamic>?)
          ?.map(
            (e) => CallStatsReportSummaryResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$QueryCallStatsResponseToJson(
  QueryCallStatsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
  'reports': instance.reports.map((e) => e.toJson()).toList(),
};
