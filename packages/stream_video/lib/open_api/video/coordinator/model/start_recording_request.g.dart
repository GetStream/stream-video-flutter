// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_recording_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartRecordingRequest _$StartRecordingRequestFromJson(
  Map<String, dynamic> json,
) => StartRecordingRequest(
  recordingExternalStorage: json['recording_external_storage'] as String?,
);

Map<String, dynamic> _$StartRecordingRequestToJson(
  StartRecordingRequest instance,
) => <String, dynamic>{
  'recording_external_storage': instance.recordingExternalStorage,
};
