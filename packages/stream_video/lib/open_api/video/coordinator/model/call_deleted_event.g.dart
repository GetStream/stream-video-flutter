// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallDeletedEvent _$CallDeletedEventFromJson(Map<String, dynamic> json) =>
    CallDeletedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallDeletedEventToJson(CallDeletedEvent instance) =>
    <String, dynamic>{
      'call': instance.call,
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };
