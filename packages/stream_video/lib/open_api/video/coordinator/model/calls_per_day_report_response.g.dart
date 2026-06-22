// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_per_day_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallsPerDayReportResponse _$CallsPerDayReportResponseFromJson(
  Map<String, dynamic> json,
) => CallsPerDayReportResponse(
  daily:
      (json['daily'] as List<dynamic>?)
          ?.map(
            (e) => DailyAggregateCallsPerDayReportResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$CallsPerDayReportResponseToJson(
  CallsPerDayReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
