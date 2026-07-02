// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_source_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressSourceRequest _$IngressSourceRequestFromJson(
  Map<String, dynamic> json,
) => IngressSourceRequest(
  fps: $enumDecode(
    _$IngressSourceRequestFpsEnumMap,
    json['fps'],
    unknownValue: IngressSourceRequestFps.unknown,
  ),
  height: (json['height'] as num).toInt(),
  width: (json['width'] as num).toInt(),
);

Map<String, dynamic> _$IngressSourceRequestToJson(
  IngressSourceRequest instance,
) => <String, dynamic>{
  'fps': _$IngressSourceRequestFpsEnumMap[instance.fps]!,
  'height': instance.height,
  'width': instance.width,
};

const _$IngressSourceRequestFpsEnumMap = {
  IngressSourceRequestFps.n30: '30',
  IngressSourceRequestFps.n60: '60',
  IngressSourceRequestFps.unknown: '_unknown',
};
