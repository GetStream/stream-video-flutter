// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_user_muted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallUserMutedEvent _$CallUserMutedEventFromJson(Map<String, dynamic> json) =>
    CallUserMutedEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      fromUserId: json['from_user_id'] as String,
      mutedUserIds:
          (json['muted_user_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      reason: json['reason'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallUserMutedEventToJson(CallUserMutedEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'from_user_id': instance.fromUserId,
      'muted_user_ids': instance.mutedUserIds,
      'reason': instance.reason,
      'type': instance.type,
    };
