// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HLSSettingsRequest _$HLSSettingsRequestFromJson(Map<String, dynamic> json) =>
    HLSSettingsRequest(
      autoOn: json['auto_on'] as bool?,
      enabled: json['enabled'] as bool?,
      qualityTracks:
          (json['quality_tracks'] as List<dynamic>?)
              ?.map(
                (e) => $enumDecode(
                  _$HLSSettingsRequestQualityTracksEnumMap,
                  e,
                  unknownValue: HLSSettingsRequestQualityTracks.unknown,
                ),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$HLSSettingsRequestToJson(HLSSettingsRequest instance) =>
    <String, dynamic>{
      'auto_on': instance.autoOn,
      'enabled': instance.enabled,
      'quality_tracks': instance.qualityTracks
          .map((e) => _$HLSSettingsRequestQualityTracksEnumMap[e]!)
          .toList(),
    };

const _$HLSSettingsRequestQualityTracksEnumMap = {
  HLSSettingsRequestQualityTracks.n1080p: '1080p',
  HLSSettingsRequestQualityTracks.n1440p: '1440p',
  HLSSettingsRequestQualityTracks.n360p: '360p',
  HLSSettingsRequestQualityTracks.n480p: '480p',
  HLSSettingsRequestQualityTracks.n720p: '720p',
  HLSSettingsRequestQualityTracks.portrait1080x1920: 'portrait-1080x1920',
  HLSSettingsRequestQualityTracks.portrait1440x2560: 'portrait-1440x2560',
  HLSSettingsRequestQualityTracks.portrait360x640: 'portrait-360x640',
  HLSSettingsRequestQualityTracks.portrait480x854: 'portrait-480x854',
  HLSSettingsRequestQualityTracks.portrait720x1280: 'portrait-720x1280',
  HLSSettingsRequestQualityTracks.unknown: '_unknown',
};
