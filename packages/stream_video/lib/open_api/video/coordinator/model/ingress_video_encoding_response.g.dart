// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_video_encoding_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressVideoEncodingResponse _$IngressVideoEncodingResponseFromJson(
  Map<String, dynamic> json,
) => IngressVideoEncodingResponse(
  layers:
      (json['layers'] as List<dynamic>?)
          ?.map(
            (e) =>
                IngressVideoLayerResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  source: IngressSourceResponse.fromJson(
    json['source'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$IngressVideoEncodingResponseToJson(
  IngressVideoEncodingResponse instance,
) => <String, dynamic>{
  'layers': instance.layers.map((e) => e.toJson()).toList(),
  'source': instance.source.toJson(),
};
