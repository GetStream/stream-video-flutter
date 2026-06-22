// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_count_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallParticipantCountReport _$CallParticipantCountReportFromJson(
  Map<String, dynamic> json,
) => CallParticipantCountReport(
  histogram: (json['histogram'] as List<dynamic>)
      .map((e) => ReportByHistogramBucket.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CallParticipantCountReportToJson(
  CallParticipantCountReport instance,
) => <String, dynamic>{'histogram': instance.histogram};
