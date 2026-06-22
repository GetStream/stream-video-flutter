// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_duration_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallDurationReportResponse _$CallDurationReportResponseFromJson(
  Map<String, dynamic> json,
) => CallDurationReportResponse(
  daily: (json['daily'] as List<dynamic>)
      .map(
        (e) => DailyAggregateCallDurationReportResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$CallDurationReportResponseToJson(
  CallDurationReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
