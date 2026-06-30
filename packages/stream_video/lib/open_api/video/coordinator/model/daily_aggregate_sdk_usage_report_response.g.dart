// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_sdk_usage_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateSDKUsageReportResponse
_$DailyAggregateSDKUsageReportResponseFromJson(Map<String, dynamic> json) =>
    DailyAggregateSDKUsageReportResponse(
      date: json['date'] as String,
      report: SDKUsageReport.fromJson(json['report'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DailyAggregateSDKUsageReportResponseToJson(
  DailyAggregateSDKUsageReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
