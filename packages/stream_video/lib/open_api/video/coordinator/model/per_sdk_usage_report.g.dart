// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_sdk_usage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerSDKUsageReport _$PerSDKUsageReportFromJson(Map<String, dynamic> json) =>
    PerSDKUsageReport(
      byVersion:
          (json['by_version'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PerSDKUsageReportToJson(PerSDKUsageReport instance) =>
    <String, dynamic>{
      'by_version': instance.byVersion,
      'total': instance.total,
    };
