// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_sdk_usage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerSDKUsageReport _$PerSDKUsageReportFromJson(Map<String, dynamic> json) =>
    PerSDKUsageReport(
      byVersion: Map<String, int>.from(json['by_version'] as Map),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PerSDKUsageReportToJson(PerSDKUsageReport instance) =>
    <String, dynamic>{
      'by_version': instance.byVersion,
      'total': instance.total,
    };
