// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSettingsResponse _$CallSettingsResponseFromJson(
  Map<String, dynamic> json,
) => CallSettingsResponse(
  audio: AudioSettingsResponse.fromJson(json['audio'] as Map<String, dynamic>),
  backstage: BackstageSettingsResponse.fromJson(
    json['backstage'] as Map<String, dynamic>,
  ),
  broadcasting: BroadcastSettingsResponse.fromJson(
    json['broadcasting'] as Map<String, dynamic>,
  ),
  frameRecording: FrameRecordingSettingsResponse.fromJson(
    json['frame_recording'] as Map<String, dynamic>,
  ),
  geofencing: GeofenceSettingsResponse.fromJson(
    json['geofencing'] as Map<String, dynamic>,
  ),
  individualRecording: IndividualRecordingSettingsResponse.fromJson(
    json['individual_recording'] as Map<String, dynamic>,
  ),
  ingress: json['ingress'] == null
      ? null
      : IngressSettingsResponse.fromJson(
          json['ingress'] as Map<String, dynamic>,
        ),
  limits: LimitsSettingsResponse.fromJson(
    json['limits'] as Map<String, dynamic>,
  ),
  rawRecording: RawRecordingSettingsResponse.fromJson(
    json['raw_recording'] as Map<String, dynamic>,
  ),
  recording: RecordSettingsResponse.fromJson(
    json['recording'] as Map<String, dynamic>,
  ),
  ring: RingSettingsResponse.fromJson(json['ring'] as Map<String, dynamic>),
  screensharing: ScreensharingSettingsResponse.fromJson(
    json['screensharing'] as Map<String, dynamic>,
  ),
  session: SessionSettingsResponse.fromJson(
    json['session'] as Map<String, dynamic>,
  ),
  thumbnails: ThumbnailsSettingsResponse.fromJson(
    json['thumbnails'] as Map<String, dynamic>,
  ),
  transcription: TranscriptionSettingsResponse.fromJson(
    json['transcription'] as Map<String, dynamic>,
  ),
  video: VideoSettingsResponse.fromJson(json['video'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CallSettingsResponseToJson(
  CallSettingsResponse instance,
) => <String, dynamic>{
  'audio': instance.audio.toJson(),
  'backstage': instance.backstage.toJson(),
  'broadcasting': instance.broadcasting.toJson(),
  'frame_recording': instance.frameRecording.toJson(),
  'geofencing': instance.geofencing.toJson(),
  'individual_recording': instance.individualRecording.toJson(),
  'ingress': instance.ingress?.toJson(),
  'limits': instance.limits.toJson(),
  'raw_recording': instance.rawRecording.toJson(),
  'recording': instance.recording.toJson(),
  'ring': instance.ring.toJson(),
  'screensharing': instance.screensharing.toJson(),
  'session': instance.session.toJson(),
  'thumbnails': instance.thumbnails.toJson(),
  'transcription': instance.transcription.toJson(),
  'video': instance.video.toJson(),
};
