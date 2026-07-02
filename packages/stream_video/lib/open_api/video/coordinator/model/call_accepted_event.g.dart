// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_accepted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallAcceptedEvent _$CallAcceptedEventFromJson(Map<String, dynamic> json) =>
    CallAcceptedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CallAcceptedEventToJson(CallAcceptedEvent instance) =>
    <String, dynamic>{
      'call': instance.call.toJson(),
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
      'user': instance.user.toJson(),
    };
