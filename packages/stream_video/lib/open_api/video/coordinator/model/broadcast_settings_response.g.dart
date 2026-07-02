// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastSettingsResponse _$BroadcastSettingsResponseFromJson(
  Map<String, dynamic> json,
) => BroadcastSettingsResponse(
  enabled: json['enabled'] as bool,
  hls: HLSSettingsResponse.fromJson(json['hls'] as Map<String, dynamic>),
  rtmp: RTMPSettingsResponse.fromJson(json['rtmp'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BroadcastSettingsResponseToJson(
  BroadcastSettingsResponse instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'hls': instance.hls.toJson(),
  'rtmp': instance.rtmp.toJson(),
};
