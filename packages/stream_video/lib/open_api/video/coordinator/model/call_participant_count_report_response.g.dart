// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_count_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallParticipantCountReportResponse _$CallParticipantCountReportResponseFromJson(
  Map<String, dynamic> json,
) => CallParticipantCountReportResponse(
  daily: (json['daily'] as List<dynamic>)
      .map(
        (e) => DailyAggregateCallParticipantCountReportResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$CallParticipantCountReportResponseToJson(
  CallParticipantCountReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
