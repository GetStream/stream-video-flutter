// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_created_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallCreatedEvent _$CallCreatedEventFromJson(Map<String, dynamic> json) =>
    CallCreatedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      members:
          (json['members'] as List<dynamic>?)
              ?.map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallCreatedEventToJson(CallCreatedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'type': instance.type,
    };
