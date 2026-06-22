// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_video_encoding_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressVideoEncodingOptionsRequest _$IngressVideoEncodingOptionsRequestFromJson(
  Map<String, dynamic> json,
) => IngressVideoEncodingOptionsRequest(
  layers: (json['layers'] as List<dynamic>)
      .map((e) => IngressVideoLayerRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  source: IngressSourceRequest.fromJson(json['source'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IngressVideoEncodingOptionsRequestToJson(
  IngressVideoEncodingOptionsRequest instance,
) => <String, dynamic>{'layers': instance.layers, 'source': instance.source};
