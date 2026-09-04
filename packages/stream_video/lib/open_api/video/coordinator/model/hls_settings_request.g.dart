// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLSSettingsRequest _$HLSSettingsRequestFromJson(Map<String, dynamic> json) =>
    HLSSettingsRequest(
      autoOn: json['auto_on'] as bool?,
      enabled: json['enabled'] as bool?,
      qualityTracks: (json['quality_tracks'] as List<dynamic>)
          .map((e) => HLSSettingsRequestQualityTracks.fromJson(e as String))
          .toList(),
    );

Map<String, dynamic> _$HLSSettingsRequestToJson(HLSSettingsRequest instance) =>
    <String, dynamic>{
      'auto_on': instance.autoOn,
      'enabled': instance.enabled,
      'quality_tracks': instance.qualityTracks.map((e) => e.toJson()).toList(),
    };
