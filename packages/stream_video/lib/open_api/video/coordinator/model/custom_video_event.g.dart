// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_video_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomVideoEvent _$CustomVideoEventFromJson(Map<String, dynamic> json) =>
    CustomVideoEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>? ?? {},
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomVideoEventToJson(CustomVideoEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'type': instance.type,
      'user': instance.user,
    };
