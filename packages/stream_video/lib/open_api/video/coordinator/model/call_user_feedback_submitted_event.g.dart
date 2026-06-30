// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_user_feedback_submitted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallUserFeedbackSubmittedEvent _$CallUserFeedbackSubmittedEventFromJson(
  Map<String, dynamic> json,
) => CallUserFeedbackSubmittedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>?,
  rating: (json['rating'] as num).toInt(),
  reason: json['reason'] as String?,
  sdk: json['sdk'] as String?,
  sdkVersion: json['sdk_version'] as String?,
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallUserFeedbackSubmittedEventToJson(
  CallUserFeedbackSubmittedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'rating': instance.rating,
  'reason': instance.reason,
  'sdk': instance.sdk,
  'sdk_version': instance.sdkVersion,
  'session_id': instance.sessionId,
  'type': instance.type,
  'user': instance.user.toJson(),
};
