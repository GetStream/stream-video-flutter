// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_notification_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallNotificationEvent _$CallNotificationEventFromJson(
  Map<String, dynamic> json,
) => CallNotificationEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallNotificationEventToJson(
  CallNotificationEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members,
  'session_id': instance.sessionId,
  'type': instance.type,
  'user': instance.user,
};
