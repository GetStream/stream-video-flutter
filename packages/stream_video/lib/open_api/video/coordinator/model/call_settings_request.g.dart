// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSettingsRequest _$CallSettingsRequestFromJson(
  Map<String, dynamic> json,
) => CallSettingsRequest(
  audio: json['audio'] == null
      ? null
      : AudioSettingsRequest.fromJson(json['audio'] as Map<String, dynamic>),
  backstage: json['backstage'] == null
      ? null
      : BackstageSettingsRequest.fromJson(
          json['backstage'] as Map<String, dynamic>,
        ),
  broadcasting: json['broadcasting'] == null
      ? null
      : BroadcastSettingsRequest.fromJson(
          json['broadcasting'] as Map<String, dynamic>,
        ),
  frameRecording: json['frame_recording'] == null
      ? null
      : FrameRecordingSettingsRequest.fromJson(
          json['frame_recording'] as Map<String, dynamic>,
        ),
  geofencing: json['geofencing'] == null
      ? null
      : GeofenceSettingsRequest.fromJson(
          json['geofencing'] as Map<String, dynamic>,
        ),
  individualRecording: json['individual_recording'] == null
      ? null
      : IndividualRecordingSettingsRequest.fromJson(
          json['individual_recording'] as Map<String, dynamic>,
        ),
  ingress: json['ingress'] == null
      ? null
      : IngressSettingsRequest.fromJson(
          json['ingress'] as Map<String, dynamic>,
        ),
  limits: json['limits'] == null
      ? null
      : LimitsSettingsRequest.fromJson(json['limits'] as Map<String, dynamic>),
  rawRecording: json['raw_recording'] == null
      ? null
      : RawRecordingSettingsRequest.fromJson(
          json['raw_recording'] as Map<String, dynamic>,
        ),
  recording: json['recording'] == null
      ? null
      : RecordSettingsRequest.fromJson(
          json['recording'] as Map<String, dynamic>,
        ),
  ring: json['ring'] == null
      ? null
      : RingSettingsRequest.fromJson(json['ring'] as Map<String, dynamic>),
  screensharing: json['screensharing'] == null
      ? null
      : ScreensharingSettingsRequest.fromJson(
          json['screensharing'] as Map<String, dynamic>,
        ),
  session: json['session'] == null
      ? null
      : SessionSettingsRequest.fromJson(
          json['session'] as Map<String, dynamic>,
        ),
  thumbnails: json['thumbnails'] == null
      ? null
      : ThumbnailsSettingsRequest.fromJson(
          json['thumbnails'] as Map<String, dynamic>,
        ),
  transcription: json['transcription'] == null
      ? null
      : TranscriptionSettingsRequest.fromJson(
          json['transcription'] as Map<String, dynamic>,
        ),
  video: json['video'] == null
      ? null
      : VideoSettingsRequest.fromJson(json['video'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallSettingsRequestToJson(
  CallSettingsRequest instance,
) => <String, dynamic>{
  'audio': instance.audio,
  'backstage': instance.backstage,
  'broadcasting': instance.broadcasting,
  'frame_recording': instance.frameRecording,
  'geofencing': instance.geofencing,
  'individual_recording': instance.individualRecording,
  'ingress': instance.ingress,
  'limits': instance.limits,
  'raw_recording': instance.rawRecording,
  'recording': instance.recording,
  'ring': instance.ring,
  'screensharing': instance.screensharing,
  'session': instance.session,
  'thumbnails': instance.thumbnails,
  'transcription': instance.transcription,
  'video': instance.video,
};
