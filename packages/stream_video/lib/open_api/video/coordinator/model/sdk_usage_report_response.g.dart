// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_usage_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SDKUsageReportResponse _$SDKUsageReportResponseFromJson(
  Map<String, dynamic> json,
) => SDKUsageReportResponse(
  daily:
      (json['daily'] as List<dynamic>?)
          ?.map(
            (e) => DailyAggregateSDKUsageReportResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$SDKUsageReportResponseToJson(
  SDKUsageReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
