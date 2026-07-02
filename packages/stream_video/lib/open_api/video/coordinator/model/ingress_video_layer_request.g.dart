// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_video_layer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressVideoLayerRequest _$IngressVideoLayerRequestFromJson(
  Map<String, dynamic> json,
) => IngressVideoLayerRequest(
  bitrate: (json['bitrate'] as num).toInt(),
  codec: $enumDecode(
    _$IngressVideoLayerRequestCodecEnumMap,
    json['codec'],
    unknownValue: IngressVideoLayerRequestCodec.unknown,
  ),
  frameRateLimit: (json['frame_rate_limit'] as num).toInt(),
  maxDimension: (json['max_dimension'] as num).toInt(),
  minDimension: (json['min_dimension'] as num).toInt(),
);

Map<String, dynamic> _$IngressVideoLayerRequestToJson(
  IngressVideoLayerRequest instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate,
  'codec': _$IngressVideoLayerRequestCodecEnumMap[instance.codec]!,
  'frame_rate_limit': instance.frameRateLimit,
  'max_dimension': instance.maxDimension,
  'min_dimension': instance.minDimension,
};

const _$IngressVideoLayerRequestCodecEnumMap = {
  IngressVideoLayerRequestCodec.h264: 'h264',
  IngressVideoLayerRequestCodec.vp8: 'vp8',
  IngressVideoLayerRequestCodec.unknown: '_unknown',
};
