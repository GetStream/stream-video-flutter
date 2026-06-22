// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rejected_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRejectedEvent _$CallRejectedEventFromJson(Map<String, dynamic> json) =>
    CallRejectedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      reason: json['reason'] as String?,
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallRejectedEventToJson(CallRejectedEvent instance) =>
    <String, dynamic>{
      'call': instance.call,
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'reason': instance.reason,
      'type': instance.type,
      'user': instance.user,
    };
