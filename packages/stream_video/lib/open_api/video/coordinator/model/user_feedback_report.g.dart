// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFeedbackReport _$UserFeedbackReportFromJson(Map<String, dynamic> json) =>
    UserFeedbackReport(
      countByRating: Map<String, int>.from(json['count_by_rating'] as Map),
      unreportedCount: (json['unreported_count'] as num).toInt(),
    );

Map<String, dynamic> _$UserFeedbackReportToJson(UserFeedbackReport instance) =>
    <String, dynamic>{
      'count_by_rating': instance.countByRating,
      'unreported_count': instance.unreportedCount,
    };
