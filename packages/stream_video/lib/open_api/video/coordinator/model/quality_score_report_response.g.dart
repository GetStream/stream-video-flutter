// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_score_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualityScoreReportResponse _$QualityScoreReportResponseFromJson(
  Map<String, dynamic> json,
) => QualityScoreReportResponse(
  daily:
      (json['daily'] as List<dynamic>?)
          ?.map(
            (e) => DailyAggregateQualityScoreReportResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$QualityScoreReportResponseToJson(
  QualityScoreReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
