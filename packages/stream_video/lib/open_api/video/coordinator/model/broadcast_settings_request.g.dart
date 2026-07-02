// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastSettingsRequest _$BroadcastSettingsRequestFromJson(
  Map<String, dynamic> json,
) => BroadcastSettingsRequest(
  enabled: json['enabled'] as bool?,
  hls: json['hls'] == null
      ? null
      : HLSSettingsRequest.fromJson(json['hls'] as Map<String, dynamic>),
  rtmp: json['rtmp'] == null
      ? null
      : RTMPSettingsRequest.fromJson(json['rtmp'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BroadcastSettingsRequestToJson(
  BroadcastSettingsRequest instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'hls': instance.hls?.toJson(),
  'rtmp': instance.rtmp?.toJson(),
};
