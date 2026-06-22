// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_transcription_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopTranscriptionRequest _$StopTranscriptionRequestFromJson(
  Map<String, dynamic> json,
) => StopTranscriptionRequest(
  stopClosedCaptions: json['stop_closed_captions'] as bool?,
);

Map<String, dynamic> _$StopTranscriptionRequestToJson(
  StopTranscriptionRequest instance,
) => <String, dynamic>{'stop_closed_captions': instance.stopClosedCaptions};
