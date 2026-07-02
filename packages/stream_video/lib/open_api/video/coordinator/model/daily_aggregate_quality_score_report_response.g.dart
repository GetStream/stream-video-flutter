// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_quality_score_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyAggregateQualityScoreReportResponse
_$DailyAggregateQualityScoreReportResponseFromJson(Map<String, dynamic> json) =>
    DailyAggregateQualityScoreReportResponse(
      date: json['date'] as String,
      report: QualityScoreReport.fromJson(
        json['report'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$DailyAggregateQualityScoreReportResponseToJson(
  DailyAggregateQualityScoreReportResponse instance,
) => <String, dynamic>{
  'date': instance.date,
  'report': instance.report.toJson(),
};
