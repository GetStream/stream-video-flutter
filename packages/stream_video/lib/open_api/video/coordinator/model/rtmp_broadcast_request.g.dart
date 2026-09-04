// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_broadcast_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPBroadcastRequest _$RTMPBroadcastRequestFromJson(
  Map<String, dynamic> json,
) => RTMPBroadcastRequest(
  layout: json['layout'] == null
      ? null
      : LayoutSettingsRequest.fromJson(json['layout'] as Map<String, dynamic>),
  name: json['name'] as String,
  quality: json['quality'] == null
      ? null
      : RTMPBroadcastRequestQuality.fromJson(json['quality'] as String),
  streamKey: json['stream_key'] as String?,
  streamUrl: json['stream_url'] as String,
);

Map<String, dynamic> _$RTMPBroadcastRequestToJson(
  RTMPBroadcastRequest instance,
) => <String, dynamic>{
  'layout': instance.layout?.toJson(),
  'name': instance.name,
  'quality': instance.quality?.toJson(),
  'stream_key': instance.streamKey,
  'stream_url': instance.streamUrl,
};
