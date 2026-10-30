// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_source_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressSourceRequest _$IngressSourceRequestFromJson(
  Map<String, dynamic> json,
) => IngressSourceRequest(
  fps: (json['fps'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  width: (json['width'] as num).toInt(),
);

Map<String, dynamic> _$IngressSourceRequestToJson(
  IngressSourceRequest instance,
) => <String, dynamic>{
  'fps': instance.fps,
  'height': instance.height,
  'width': instance.width,
};
