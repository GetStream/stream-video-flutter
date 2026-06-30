// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unblocked_user_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnblockedUserEvent _$UnblockedUserEventFromJson(Map<String, dynamic> json) =>
    UnblockedUserEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UnblockedUserEventToJson(UnblockedUserEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
