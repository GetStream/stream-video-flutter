// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_live_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopLiveRequest _$StopLiveRequestFromJson(Map<String, dynamic> json) =>
    StopLiveRequest(
      continueClosedCaption: json['continue_closed_caption'] as bool?,
      continueCompositeRecording: json['continue_composite_recording'] as bool?,
      continueHls: json['continue_hls'] as bool?,
      continueIndividualRecording:
          json['continue_individual_recording'] as bool?,
      continueRawRecording: json['continue_raw_recording'] as bool?,
      continueRecording: json['continue_recording'] as bool?,
      continueRtmpBroadcasts: json['continue_rtmp_broadcasts'] as bool?,
      continueTranscription: json['continue_transcription'] as bool?,
    );

Map<String, dynamic> _$StopLiveRequestToJson(StopLiveRequest instance) =>
    <String, dynamic>{
      'continue_closed_caption': instance.continueClosedCaption,
      'continue_composite_recording': instance.continueCompositeRecording,
      'continue_hls': instance.continueHls,
      'continue_individual_recording': instance.continueIndividualRecording,
      'continue_raw_recording': instance.continueRawRecording,
      'continue_recording': instance.continueRecording,
      'continue_rtmp_broadcasts': instance.continueRtmpBroadcasts,
      'continue_transcription': instance.continueTranscription,
    };
