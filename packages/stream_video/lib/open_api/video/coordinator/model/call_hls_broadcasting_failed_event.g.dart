// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallHLSBroadcastingFailedEvent _$CallHLSBroadcastingFailedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingFailedEventToJson(
  CallHLSBroadcastingFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
