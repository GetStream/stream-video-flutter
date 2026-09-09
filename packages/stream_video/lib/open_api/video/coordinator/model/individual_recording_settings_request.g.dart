// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_recording_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndividualRecordingSettingsRequest _$IndividualRecordingSettingsRequestFromJson(
  Map<String, dynamic> json,
) => IndividualRecordingSettingsRequest(
  mode: IndividualRecordingSettingsRequestMode.fromJson(json['mode'] as String),
  outputTypes: (json['output_types'] as List<dynamic>?)
      ?.map(
        (e) =>
            IndividualRecordingSettingsRequestOutputTypes.fromJson(e as String),
      )
      .toList(),
);

Map<String, dynamic> _$IndividualRecordingSettingsRequestToJson(
  IndividualRecordingSettingsRequest instance,
) => <String, dynamic>{
  'mode': instance.mode.toJson(),
  'output_types': instance.outputTypes?.map((e) => e.toJson()).toList(),
};
