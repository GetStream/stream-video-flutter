// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLSSettingsResponse _$HLSSettingsResponseFromJson(Map<String, dynamic> json) =>
    HLSSettingsResponse(
      autoOn: json['auto_on'] as bool,
      enabled: json['enabled'] as bool,
      qualityTracks: (json['quality_tracks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HLSSettingsResponseToJson(
  HLSSettingsResponse instance,
) => <String, dynamic>{
  'auto_on': instance.autoOn,
  'enabled': instance.enabled,
  'quality_tracks': instance.qualityTracks,
};
