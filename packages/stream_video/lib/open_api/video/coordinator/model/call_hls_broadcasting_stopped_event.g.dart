// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallHLSBroadcastingStoppedEvent _$CallHLSBroadcastingStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingStoppedEventToJson(
  CallHLSBroadcastingStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
