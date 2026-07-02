// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_recording_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawRecordingSettingsRequest _$RawRecordingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => RawRecordingSettingsRequest(
  audioOnly: json['audio_only'] as bool?,
  mode: $enumDecode(
    _$RawRecordingSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: RawRecordingSettingsRequestMode.unknown,
  ),
);

Map<String, dynamic> _$RawRecordingSettingsRequestToJson(
  RawRecordingSettingsRequest instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': _$RawRecordingSettingsRequestModeEnumMap[instance.mode]!,
};

const _$RawRecordingSettingsRequestModeEnumMap = {
  RawRecordingSettingsRequestMode.autoOn: 'auto-on',
  RawRecordingSettingsRequestMode.available: 'available',
  RawRecordingSettingsRequestMode.disabled: 'disabled',
  RawRecordingSettingsRequestMode.unknown: '_unknown',
};
