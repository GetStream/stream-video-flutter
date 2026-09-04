// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_recording_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualRecordingSettingsResponse
_$IndividualRecordingSettingsResponseFromJson(Map<String, dynamic> json) =>
    IndividualRecordingSettingsResponse(
      mode: IndividualRecordingSettingsResponseMode.fromJson(
        json['mode'] as String,
      ),
      outputTypes: (json['output_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$IndividualRecordingSettingsResponseToJson(
  IndividualRecordingSettingsResponse instance,
) => <String, dynamic>{
  'mode': instance.mode.toJson(),
  'output_types': instance.outputTypes,
};
