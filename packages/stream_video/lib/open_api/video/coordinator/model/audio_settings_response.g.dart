// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioSettingsResponse _$AudioSettingsResponseFromJson(
  Map<String, dynamic> json,
) => AudioSettingsResponse(
  accessRequestEnabled: json['access_request_enabled'] as bool,
  defaultDevice: $enumDecode(
    _$AudioSettingsResponseDefaultDeviceEnumMap,
    json['default_device'],
    unknownValue: AudioSettingsResponseDefaultDevice.unknown,
  ),
  hifiAudioEnabled: json['hifi_audio_enabled'] as bool,
  micDefaultOn: json['mic_default_on'] as bool,
  noiseCancellation: json['noise_cancellation'] == null
      ? null
      : NoiseCancellationSettings.fromJson(
          json['noise_cancellation'] as Map<String, dynamic>,
        ),
  opusDtxEnabled: json['opus_dtx_enabled'] as bool,
  redundantCodingEnabled: json['redundant_coding_enabled'] as bool,
  speakerDefaultOn: json['speaker_default_on'] as bool,
);

Map<String, dynamic> _$AudioSettingsResponseToJson(
  AudioSettingsResponse instance,
) => <String, dynamic>{
  'access_request_enabled': instance.accessRequestEnabled,
  'default_device':
      _$AudioSettingsResponseDefaultDeviceEnumMap[instance.defaultDevice]!,
  'hifi_audio_enabled': instance.hifiAudioEnabled,
  'mic_default_on': instance.micDefaultOn,
  'noise_cancellation': instance.noiseCancellation,
  'opus_dtx_enabled': instance.opusDtxEnabled,
  'redundant_coding_enabled': instance.redundantCodingEnabled,
  'speaker_default_on': instance.speakerDefaultOn,
};

const _$AudioSettingsResponseDefaultDeviceEnumMap = {
  AudioSettingsResponseDefaultDevice.earpiece: 'earpiece',
  AudioSettingsResponseDefaultDevice.speaker: 'speaker',
  AudioSettingsResponseDefaultDevice.unknown: '_unknown',
};
