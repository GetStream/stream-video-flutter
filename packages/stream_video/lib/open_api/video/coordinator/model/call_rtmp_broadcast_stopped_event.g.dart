// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rtmp_broadcast_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRtmpBroadcastStoppedEvent _$CallRtmpBroadcastStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallRtmpBroadcastStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  name: json['name'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRtmpBroadcastStoppedEventToJson(
  CallRtmpBroadcastStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'name': instance.name,
  'type': instance.type,
};
