// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_rtmp_broadcast_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRtmpBroadcastFailedEvent _$CallRtmpBroadcastFailedEventFromJson(
  Map<String, dynamic> json,
) => CallRtmpBroadcastFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  name: json['name'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallRtmpBroadcastFailedEventToJson(
  CallRtmpBroadcastFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'name': instance.name,
  'type': instance.type,
};
