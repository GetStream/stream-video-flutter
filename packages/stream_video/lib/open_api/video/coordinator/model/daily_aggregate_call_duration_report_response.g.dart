// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_call_duration_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateCallDurationReportResponse
_$DailyAggregateCallDurationReportResponseFromJson(Map<String, dynamic> json) =>
    DailyAggregateCallDurationReportResponse(
      date: json['date'] as String,
      report: CallDurationReport.fromJson(
        json['report'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DailyAggregateCallDurationReportResponseToJson(
  DailyAggregateCallDurationReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
