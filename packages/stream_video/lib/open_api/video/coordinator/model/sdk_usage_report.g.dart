// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_usage_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SDKUsageReport _$SDKUsageReportFromJson(Map<String, dynamic> json) =>
    SDKUsageReport(
      perSdkUsage:
          (json['per_sdk_usage'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              PerSDKUsageReport.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          {},
    );

Map<String, dynamic> _$SDKUsageReportToJson(SDKUsageReport instance) =>
    <String, dynamic>{'per_sdk_usage': instance.perSdkUsage};
