// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFeedbackReportResponse _$UserFeedbackReportResponseFromJson(
  Map<String, dynamic> json,
) => UserFeedbackReportResponse(
  daily: (json['daily'] as List<dynamic>)
      .map(
        (e) => DailyAggregateUserFeedbackReportResponse.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$UserFeedbackReportResponseToJson(
  UserFeedbackReportResponse instance,
) => <String, dynamic>{'daily': instance.daily};
