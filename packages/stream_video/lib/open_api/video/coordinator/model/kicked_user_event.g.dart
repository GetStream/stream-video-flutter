// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kicked_user_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KickedUserEvent _$KickedUserEventFromJson(Map<String, dynamic> json) =>
    KickedUserEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      kickedByUser: json['kicked_by_user'] == null
          ? null
          : UserResponse.fromJson(
              json['kicked_by_user'] as Map<String, dynamic>,
            ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KickedUserEventToJson(KickedUserEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'kicked_by_user': instance.kickedByUser?.toJson(),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
