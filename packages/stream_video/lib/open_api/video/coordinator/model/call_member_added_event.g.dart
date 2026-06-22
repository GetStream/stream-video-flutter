// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_added_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallMemberAddedEvent _$CallMemberAddedEventFromJson(
  Map<String, dynamic> json,
) => CallMemberAddedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallMemberAddedEventToJson(
  CallMemberAddedEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'members': instance.members,
  'type': instance.type,
};
