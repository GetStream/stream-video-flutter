// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_hls_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EgressHLSResponse _$EgressHLSResponseFromJson(Map<String, dynamic> json) =>
    EgressHLSResponse(
      playlistUrl: json['playlist_url'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$EgressHLSResponseToJson(EgressHLSResponse instance) =>
    <String, dynamic>{
      'playlist_url': instance.playlistUrl,
      'status': instance.status,
    };
