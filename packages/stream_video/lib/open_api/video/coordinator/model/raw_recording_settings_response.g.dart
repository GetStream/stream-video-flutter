// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_recording_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawRecordingSettingsResponse _$RawRecordingSettingsResponseFromJson(
  Map<String, dynamic> json,
) => RawRecordingSettingsResponse(
  audioOnly: json['audio_only'] as bool?,
  mode: $enumDecode(
    _$RawRecordingSettingsResponseModeEnumMap,
    json['mode'],
    unknownValue: RawRecordingSettingsResponseMode.unknown,
  ),
);

Map<String, dynamic> _$RawRecordingSettingsResponseToJson(
  RawRecordingSettingsResponse instance,
) => <String, dynamic>{
  'audio_only': instance.audioOnly,
  'mode': _$RawRecordingSettingsResponseModeEnumMap[instance.mode]!,
};

const _$RawRecordingSettingsResponseModeEnumMap = {
  RawRecordingSettingsResponseMode.autoOn: 'auto-on',
  RawRecordingSettingsResponseMode.available: 'available',
  RawRecordingSettingsResponseMode.disabled: 'disabled',
  RawRecordingSettingsResponseMode.unknown: '_unknown',
};
