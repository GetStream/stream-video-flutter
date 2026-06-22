// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioSettingsRequest _$AudioSettingsRequestFromJson(
  Map<String, dynamic> json,
) => AudioSettingsRequest(
  accessRequestEnabled: json['access_request_enabled'] as bool?,
  defaultDevice: $enumDecode(
    _$AudioSettingsRequestDefaultDeviceEnumMap,
    json['default_device'],
    unknownValue: AudioSettingsRequestDefaultDevice.unknown,
  ),
  hifiAudioEnabled: json['hifi_audio_enabled'] as bool?,
  micDefaultOn: json['mic_default_on'] as bool?,
  noiseCancellation: json['noise_cancellation'] == null
      ? null
      : NoiseCancellationSettings.fromJson(
          json['noise_cancellation'] as Map<String, dynamic>,
        ),
  opusDtxEnabled: json['opus_dtx_enabled'] as bool?,
  redundantCodingEnabled: json['redundant_coding_enabled'] as bool?,
  speakerDefaultOn: json['speaker_default_on'] as bool?,
);

Map<String, dynamic> _$AudioSettingsRequestToJson(
  AudioSettingsRequest instance,
) => <String, dynamic>{
  'access_request_enabled': instance.accessRequestEnabled,
  'default_device':
      _$AudioSettingsRequestDefaultDeviceEnumMap[instance.defaultDevice]!,
  'hifi_audio_enabled': instance.hifiAudioEnabled,
  'mic_default_on': instance.micDefaultOn,
  'noise_cancellation': instance.noiseCancellation,
  'opus_dtx_enabled': instance.opusDtxEnabled,
  'redundant_coding_enabled': instance.redundantCodingEnabled,
  'speaker_default_on': instance.speakerDefaultOn,
};

const _$AudioSettingsRequestDefaultDeviceEnumMap = {
  AudioSettingsRequestDefaultDevice.earpiece: 'earpiece',
  AudioSettingsRequestDefaultDevice.speaker: 'speaker',
  AudioSettingsRequestDefaultDevice.unknown: '_unknown',
};
