// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_recording_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualRecordingSettingsRequest _$IndividualRecordingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => IndividualRecordingSettingsRequest(
  mode: json['mode'] as FeatureActivationMode,
  outputTypes: (json['output_types'] as List<dynamic>?)
      ?.map((e) => e as IndividualRecordingSettingsRequestOutputTypes)
      .toList(),
);

Map<String, dynamic> _$IndividualRecordingSettingsRequestToJson(
  IndividualRecordingSettingsRequest instance,
) => <String, dynamic>{
  'mode': instance.mode,
  'output_types': instance.outputTypes,
};
