// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_call_participant_count_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateCallParticipantCountReportResponse
_$DailyAggregateCallParticipantCountReportResponseFromJson(
  Map<String, dynamic> json,
) => DailyAggregateCallParticipantCountReportResponse(
  date: json['date'] as String,
  report: CallParticipantCountReport.fromJson(
    json['report'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DailyAggregateCallParticipantCountReportResponseToJson(
  DailyAggregateCallParticipantCountReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
