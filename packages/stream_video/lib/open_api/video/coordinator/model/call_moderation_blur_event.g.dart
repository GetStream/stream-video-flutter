// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_moderation_blur_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallModerationBlurEvent _$CallModerationBlurEventFromJson(
  Map<String, dynamic> json,
) => CallModerationBlurEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>? ?? {},
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallModerationBlurEventToJson(
  CallModerationBlurEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'type': instance.type,
  'user_id': instance.userId,
};
