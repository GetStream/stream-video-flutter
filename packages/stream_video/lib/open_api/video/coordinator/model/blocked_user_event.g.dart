// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedUserEvent _$BlockedUserEventFromJson(Map<String, dynamic> json) =>
    BlockedUserEvent(
      blockedByUser: json['blocked_by_user'] == null
          ? null
          : UserResponse.fromJson(
              json['blocked_by_user'] as Map<String, dynamic>,
            ),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlockedUserEventToJson(BlockedUserEvent instance) =>
    <String, dynamic>{
      'blocked_by_user': instance.blockedByUser?.toJson(),
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
