// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_recording_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualRecordingSettingsRequest _$IndividualRecordingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => IndividualRecordingSettingsRequest(
  mode: $enumDecode(
    _$IndividualRecordingSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: IndividualRecordingSettingsRequestMode.unknown,
  ),
  outputTypes: (json['output_types'] as List<dynamic>?)
      ?.map(
        (e) => $enumDecode(
          _$IndividualRecordingSettingsRequestOutputTypesEnumMap,
          e,
          unknownValue: IndividualRecordingSettingsRequestOutputTypes.unknown,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$IndividualRecordingSettingsRequestToJson(
  IndividualRecordingSettingsRequest instance,
) => <String, dynamic>{
  'mode': _$IndividualRecordingSettingsRequestModeEnumMap[instance.mode]!,
  'output_types': instance.outputTypes
      ?.map((e) => _$IndividualRecordingSettingsRequestOutputTypesEnumMap[e]!)
      .toList(),
};

const _$IndividualRecordingSettingsRequestModeEnumMap = {
  IndividualRecordingSettingsRequestMode.autoOn: 'auto-on',
  IndividualRecordingSettingsRequestMode.available: 'available',
  IndividualRecordingSettingsRequestMode.disabled: 'disabled',
  IndividualRecordingSettingsRequestMode.unknown: '_unknown',
};

const _$IndividualRecordingSettingsRequestOutputTypesEnumMap = {
  IndividualRecordingSettingsRequestOutputTypes.audioOnly: 'audio_only',
  IndividualRecordingSettingsRequestOutputTypes.audioVideo: 'audio_video',
  IndividualRecordingSettingsRequestOutputTypes.screenshareAudioOnly:
      'screenshare_audio_only',
  IndividualRecordingSettingsRequestOutputTypes.screenshareAudioVideo:
      'screenshare_audio_video',
  IndividualRecordingSettingsRequestOutputTypes.screenshareVideoOnly:
      'screenshare_video_only',
  IndividualRecordingSettingsRequestOutputTypes.videoOnly: 'video_only',
  IndividualRecordingSettingsRequestOutputTypes.unknown: '_unknown',
};
