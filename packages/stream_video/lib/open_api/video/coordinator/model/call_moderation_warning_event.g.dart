// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_moderation_warning_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallModerationWarningEvent _$CallModerationWarningEventFromJson(
  Map<String, dynamic> json,
) => CallModerationWarningEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] as String,
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CallModerationWarningEventToJson(
  CallModerationWarningEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message,
  'type': instance.type,
  'user_id': instance.userId,
};
