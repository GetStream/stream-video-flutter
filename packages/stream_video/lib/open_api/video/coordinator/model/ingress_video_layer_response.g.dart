// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_video_layer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressVideoLayerResponse _$IngressVideoLayerResponseFromJson(
  Map<String, dynamic> json,
) => IngressVideoLayerResponse(
  bitrate: (json['bitrate'] as num).toInt(),
  codec: json['codec'] as String,
  frameRateLimit: (json['frame_rate_limit'] as num).toInt(),
  maxDimension: (json['max_dimension'] as num).toInt(),
  minDimension: (json['min_dimension'] as num).toInt(),
);

Map<String, dynamic> _$IngressVideoLayerResponseToJson(
  IngressVideoLayerResponse instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate,
  'codec': instance.codec,
  'frame_rate_limit': instance.frameRateLimit,
  'max_dimension': instance.maxDimension,
  'min_dimension': instance.minDimension,
};
