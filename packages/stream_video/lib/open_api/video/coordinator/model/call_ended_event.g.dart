// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_ended_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallEndedEvent _$CallEndedEventFromJson(Map<String, dynamic> json) =>
    CallEndedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      reason: json['reason'] as String?,
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallEndedEventToJson(CallEndedEvent instance) =>
    <String, dynamic>{
      'call': instance.call,
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members,
      'reason': instance.reason,
      'type': instance.type,
      'user': instance.user,
    };
