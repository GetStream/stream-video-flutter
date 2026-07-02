// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_source_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressSourceResponse _$IngressSourceResponseFromJson(
  Map<String, dynamic> json,
) => IngressSourceResponse(
  fps: (json['fps'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  width: (json['width'] as num).toInt(),
);

Map<String, dynamic> _$IngressSourceResponseToJson(
  IngressSourceResponse instance,
) => <String, dynamic>{
  'fps': instance.fps,
  'height': instance.height,
  'width': instance.width,
};
