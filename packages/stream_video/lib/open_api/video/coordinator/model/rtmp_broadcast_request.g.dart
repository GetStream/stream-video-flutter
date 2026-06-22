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
  quality: $enumDecodeNullable(
    _$RTMPBroadcastRequestQualityEnumMap,
    json['quality'],
    unknownValue: RTMPBroadcastRequestQuality.unknown,
  ),
  streamKey: json['stream_key'] as String?,
  streamUrl: json['stream_url'] as String,
);

Map<String, dynamic> _$RTMPBroadcastRequestToJson(
  RTMPBroadcastRequest instance,
) => <String, dynamic>{
  'layout': instance.layout,
  'name': instance.name,
  'quality': _$RTMPBroadcastRequestQualityEnumMap[instance.quality],
  'stream_key': instance.streamKey,
  'stream_url': instance.streamUrl,
};

const _$RTMPBroadcastRequestQualityEnumMap = {
  RTMPBroadcastRequestQuality.n1080p: '1080p',
  RTMPBroadcastRequestQuality.n1440p: '1440p',
  RTMPBroadcastRequestQuality.n360p: '360p',
  RTMPBroadcastRequestQuality.n480p: '480p',
  RTMPBroadcastRequestQuality.n720p: '720p',
  RTMPBroadcastRequestQuality.portrait1080x1920: 'portrait-1080x1920',
  RTMPBroadcastRequestQuality.portrait1440x2560: 'portrait-1440x2560',
  RTMPBroadcastRequestQuality.portrait360x640: 'portrait-360x640',
  RTMPBroadcastRequestQuality.portrait480x854: 'portrait-480x854',
  RTMPBroadcastRequestQuality.portrait720x1280: 'portrait-720x1280',
  RTMPBroadcastRequestQuality.unknown: '_unknown',
};
