// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_user_feedback_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectUserFeedbackRequest _$CollectUserFeedbackRequestFromJson(
  Map<String, dynamic> json,
) => CollectUserFeedbackRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  rating: (json['rating'] as num).toInt(),
  reason: json['reason'] as String?,
  sdk: json['sdk'] as String,
  sdkVersion: json['sdk_version'] as String,
  userSessionId: json['user_session_id'] as String?,
);

Map<String, dynamic> _$CollectUserFeedbackRequestToJson(
  CollectUserFeedbackRequest instance,
) => <String, dynamic>{
  'custom': instance.custom,
  'rating': instance.rating,
  'reason': instance.reason,
  'sdk': instance.sdk,
  'sdk_version': instance.sdkVersion,
  'user_session_id': instance.userSessionId,
};
