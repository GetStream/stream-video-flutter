// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallHLSBroadcastingStartedEvent _$CallHLSBroadcastingStartedEventFromJson(
  Map<String, dynamic> json,
) => CallHLSBroadcastingStartedEvent(
  call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  hlsPlaylistUrl: json['hls_playlist_url'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$CallHLSBroadcastingStartedEventToJson(
  CallHLSBroadcastingStartedEvent instance,
) => <String, dynamic>{
  'call': instance.call,
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'hls_playlist_url': instance.hlsPlaylistUrl,
  'type': instance.type,
};
