// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_score_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualityScoreReport _$QualityScoreReportFromJson(Map<String, dynamic> json) =>
    QualityScoreReport(
      histogram: (json['histogram'] as List<dynamic>)
          .map(
            (e) => ReportByHistogramBucket.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$QualityScoreReportToJson(QualityScoreReport instance) =>
    <String, dynamic>{'histogram': instance.histogram};
