// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rating_report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRatingReportResponse _$UserRatingReportResponseFromJson(
  Map<String, dynamic> json,
) => UserRatingReportResponse(
  average: (json['average'] as num).toDouble(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$UserRatingReportResponseToJson(
  UserRatingReportResponse instance,
) => <String, dynamic>{'average': instance.average, 'count': instance.count};
