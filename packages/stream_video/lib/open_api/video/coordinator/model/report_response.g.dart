// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportResponse _$ReportResponseFromJson(Map<String, dynamic> json) =>
    ReportResponse(
      call: CallReportResponse.fromJson(json['call'] as Map<String, dynamic>),
      participants: ParticipantReportResponse.fromJson(
        json['participants'] as Map<String, dynamic>,
      ),
      userRatings: UserRatingReportResponse.fromJson(
        json['user_ratings'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ReportResponseToJson(ReportResponse instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'participants': instance.participants.toJson(),
      'user_ratings': instance.userRatings.toJson(),
    };
