// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_feedback_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFeedbackReport _$UserFeedbackReportFromJson(Map<String, dynamic> json) =>
    UserFeedbackReport(
      countByRating:
          (json['count_by_rating'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          {},
      unreportedCount: (json['unreported_count'] as num).toInt(),
    );

Map<String, dynamic> _$UserFeedbackReportToJson(UserFeedbackReport instance) =>
    <String, dynamic>{
      'count_by_rating': instance.countByRating,
      'unreported_count': instance.unreportedCount,
    };
