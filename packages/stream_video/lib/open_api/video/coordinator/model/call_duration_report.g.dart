// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_duration_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallDurationReport _$CallDurationReportFromJson(Map<String, dynamic> json) =>
    CallDurationReport(
      histogram:
          (json['histogram'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ReportByHistogramBucket.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$CallDurationReportToJson(CallDurationReport instance) =>
    <String, dynamic>{
      'histogram': instance.histogram.map((e) => e.toJson()).toList(),
    };
