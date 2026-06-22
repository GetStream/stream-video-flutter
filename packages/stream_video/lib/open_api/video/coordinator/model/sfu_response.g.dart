// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sfu_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SFUResponse _$SFUResponseFromJson(Map<String, dynamic> json) => SFUResponse(
  edgeName: json['edge_name'] as String,
  url: json['url'] as String,
  wsEndpoint: json['ws_endpoint'] as String,
);

Map<String, dynamic> _$SFUResponseToJson(SFUResponse instance) =>
    <String, dynamic>{
      'edge_name': instance.edgeName,
      'url': instance.url,
      'ws_endpoint': instance.wsEndpoint,
    };
