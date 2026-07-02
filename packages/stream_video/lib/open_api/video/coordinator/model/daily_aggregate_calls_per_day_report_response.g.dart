// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_calls_per_day_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateCallsPerDayReportResponse
_$DailyAggregateCallsPerDayReportResponseFromJson(Map<String, dynamic> json) =>
    DailyAggregateCallsPerDayReportResponse(
      date: json['date'] as String,
      report: CallsPerDayReport.fromJson(
        json['report'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DailyAggregateCallsPerDayReportResponseToJson(
  DailyAggregateCallsPerDayReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
