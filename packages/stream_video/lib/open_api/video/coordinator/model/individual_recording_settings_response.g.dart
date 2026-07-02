// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_recording_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualRecordingSettingsResponse
_$IndividualRecordingSettingsResponseFromJson(Map<String, dynamic> json) =>
    IndividualRecordingSettingsResponse(
      mode: $enumDecode(
        _$IndividualRecordingSettingsResponseModeEnumMap,
        json['mode'],
        unknownValue: IndividualRecordingSettingsResponseMode.unknown,
      ),
      outputTypes: (json['output_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IndividualRecordingSettingsResponseToJson(
  IndividualRecordingSettingsResponse instance,
) => <String, dynamic>{
  'mode': _$IndividualRecordingSettingsResponseModeEnumMap[instance.mode]!,
  'output_types': instance.outputTypes,
};

const _$IndividualRecordingSettingsResponseModeEnumMap = {
  IndividualRecordingSettingsResponseMode.autoOn: 'auto-on',
  IndividualRecordingSettingsResponseMode.available: 'available',
  IndividualRecordingSettingsResponseMode.disabled: 'disabled',
  IndividualRecordingSettingsResponseMode.unknown: '_unknown',
};
