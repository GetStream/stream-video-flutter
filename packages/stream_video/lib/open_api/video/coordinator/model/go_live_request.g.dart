// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoLiveRequest _$GoLiveRequestFromJson(Map<String, dynamic> json) =>
    GoLiveRequest(
      recordingStorageName: json['recording_storage_name'] as String?,
      startClosedCaption: json['start_closed_caption'] as bool?,
      startCompositeRecording: json['start_composite_recording'] as bool?,
      startHls: json['start_hls'] as bool?,
      startIndividualRecording: json['start_individual_recording'] as bool?,
      startRawRecording: json['start_raw_recording'] as bool?,
      startRecording: json['start_recording'] as bool?,
      startTranscription: json['start_transcription'] as bool?,
      transcriptionStorageName: json['transcription_storage_name'] as String?,
    );

Map<String, dynamic> _$GoLiveRequestToJson(GoLiveRequest instance) =>
    <String, dynamic>{
      'recording_storage_name': instance.recordingStorageName,
      'start_closed_caption': instance.startClosedCaption,
      'start_composite_recording': instance.startCompositeRecording,
      'start_hls': instance.startHls,
      'start_individual_recording': instance.startIndividualRecording,
      'start_raw_recording': instance.startRawRecording,
      'start_recording': instance.startRecording,
      'start_transcription': instance.startTranscription,
      'transcription_storage_name': instance.transcriptionStorageName,
    };
