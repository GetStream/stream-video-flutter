// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_user_feedback_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateUserFeedbackReportResponse
_$DailyAggregateUserFeedbackReportResponseFromJson(Map<String, dynamic> json) =>
    DailyAggregateUserFeedbackReportResponse(
      date: json['date'] as String,
      report: UserFeedbackReport.fromJson(
        json['report'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DailyAggregateUserFeedbackReportResponseToJson(
  DailyAggregateUserFeedbackReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
