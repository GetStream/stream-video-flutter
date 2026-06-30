// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallSettingsRequest {
  AudioSettingsRequest? get audio;
  BackstageSettingsRequest? get backstage;
  BroadcastSettingsRequest? get broadcasting;
  FrameRecordingSettingsRequest? get frameRecording;
  GeofenceSettingsRequest? get geofencing;
  IndividualRecordingSettingsRequest? get individualRecording;
  IngressSettingsRequest? get ingress;
  LimitsSettingsRequest? get limits;
  RawRecordingSettingsRequest? get rawRecording;
  RecordSettingsRequest? get recording;
  RingSettingsRequest? get ring;
  ScreensharingSettingsRequest? get screensharing;
  SessionSettingsRequest? get session;
  ThumbnailsSettingsRequest? get thumbnails;
  TranscriptionSettingsRequest? get transcription;
  VideoSettingsRequest? get video;

  /// Create a copy of CallSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallSettingsRequestCopyWith<CallSettingsRequest> get copyWith =>
      _$CallSettingsRequestCopyWithImpl<CallSettingsRequest>(
        this as CallSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallSettingsRequest &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.backstage, backstage) ||
                other.backstage == backstage) &&
            (identical(other.broadcasting, broadcasting) ||
                other.broadcasting == broadcasting) &&
            (identical(other.frameRecording, frameRecording) ||
                other.frameRecording == frameRecording) &&
            (identical(other.geofencing, geofencing) ||
                other.geofencing == geofencing) &&
            (identical(other.individualRecording, individualRecording) ||
                other.individualRecording == individualRecording) &&
            (identical(other.ingress, ingress) || other.ingress == ingress) &&
            (identical(other.limits, limits) || other.limits == limits) &&
            (identical(other.rawRecording, rawRecording) ||
                other.rawRecording == rawRecording) &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            (identical(other.ring, ring) || other.ring == ring) &&
            (identical(other.screensharing, screensharing) ||
                other.screensharing == screensharing) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.thumbnails, thumbnails) ||
                other.thumbnails == thumbnails) &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.video, video) || other.video == video));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    audio,
    backstage,
    broadcasting,
    frameRecording,
    geofencing,
    individualRecording,
    ingress,
    limits,
    rawRecording,
    recording,
    ring,
    screensharing,
    session,
    thumbnails,
    transcription,
    video,
  );

  @override
  String toString() {
    return 'CallSettingsRequest(audio: $audio, backstage: $backstage, broadcasting: $broadcasting, frameRecording: $frameRecording, geofencing: $geofencing, individualRecording: $individualRecording, ingress: $ingress, limits: $limits, rawRecording: $rawRecording, recording: $recording, ring: $ring, screensharing: $screensharing, session: $session, thumbnails: $thumbnails, transcription: $transcription, video: $video)';
  }
}

/// @nodoc
abstract mixin class $CallSettingsRequestCopyWith<$Res> {
  factory $CallSettingsRequestCopyWith(
    CallSettingsRequest value,
    $Res Function(CallSettingsRequest) _then,
  ) = _$CallSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    AudioSettingsRequest? audio,
    BackstageSettingsRequest? backstage,
    BroadcastSettingsRequest? broadcasting,
    FrameRecordingSettingsRequest? frameRecording,
    GeofenceSettingsRequest? geofencing,
    IndividualRecordingSettingsRequest? individualRecording,
    IngressSettingsRequest? ingress,
    LimitsSettingsRequest? limits,
    RawRecordingSettingsRequest? rawRecording,
    RecordSettingsRequest? recording,
    RingSettingsRequest? ring,
    ScreensharingSettingsRequest? screensharing,
    SessionSettingsRequest? session,
    ThumbnailsSettingsRequest? thumbnails,
    TranscriptionSettingsRequest? transcription,
    VideoSettingsRequest? video,
  });
}

/// @nodoc
class _$CallSettingsRequestCopyWithImpl<$Res>
    implements $CallSettingsRequestCopyWith<$Res> {
  _$CallSettingsRequestCopyWithImpl(this._self, this._then);

  final CallSettingsRequest _self;
  final $Res Function(CallSettingsRequest) _then;

  /// Create a copy of CallSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audio = freezed,
    Object? backstage = freezed,
    Object? broadcasting = freezed,
    Object? frameRecording = freezed,
    Object? geofencing = freezed,
    Object? individualRecording = freezed,
    Object? ingress = freezed,
    Object? limits = freezed,
    Object? rawRecording = freezed,
    Object? recording = freezed,
    Object? ring = freezed,
    Object? screensharing = freezed,
    Object? session = freezed,
    Object? thumbnails = freezed,
    Object? transcription = freezed,
    Object? video = freezed,
  }) {
    return _then(
      CallSettingsRequest(
        audio: freezed == audio
            ? _self.audio
            : audio // ignore: cast_nullable_to_non_nullable
                  as AudioSettingsRequest?,
        backstage: freezed == backstage
            ? _self.backstage
            : backstage // ignore: cast_nullable_to_non_nullable
                  as BackstageSettingsRequest?,
        broadcasting: freezed == broadcasting
            ? _self.broadcasting
            : broadcasting // ignore: cast_nullable_to_non_nullable
                  as BroadcastSettingsRequest?,
        frameRecording: freezed == frameRecording
            ? _self.frameRecording
            : frameRecording // ignore: cast_nullable_to_non_nullable
                  as FrameRecordingSettingsRequest?,
        geofencing: freezed == geofencing
            ? _self.geofencing
            : geofencing // ignore: cast_nullable_to_non_nullable
                  as GeofenceSettingsRequest?,
        individualRecording: freezed == individualRecording
            ? _self.individualRecording
            : individualRecording // ignore: cast_nullable_to_non_nullable
                  as IndividualRecordingSettingsRequest?,
        ingress: freezed == ingress
            ? _self.ingress
            : ingress // ignore: cast_nullable_to_non_nullable
                  as IngressSettingsRequest?,
        limits: freezed == limits
            ? _self.limits
            : limits // ignore: cast_nullable_to_non_nullable
                  as LimitsSettingsRequest?,
        rawRecording: freezed == rawRecording
            ? _self.rawRecording
            : rawRecording // ignore: cast_nullable_to_non_nullable
                  as RawRecordingSettingsRequest?,
        recording: freezed == recording
            ? _self.recording
            : recording // ignore: cast_nullable_to_non_nullable
                  as RecordSettingsRequest?,
        ring: freezed == ring
            ? _self.ring
            : ring // ignore: cast_nullable_to_non_nullable
                  as RingSettingsRequest?,
        screensharing: freezed == screensharing
            ? _self.screensharing
            : screensharing // ignore: cast_nullable_to_non_nullable
                  as ScreensharingSettingsRequest?,
        session: freezed == session
            ? _self.session
            : session // ignore: cast_nullable_to_non_nullable
                  as SessionSettingsRequest?,
        thumbnails: freezed == thumbnails
            ? _self.thumbnails
            : thumbnails // ignore: cast_nullable_to_non_nullable
                  as ThumbnailsSettingsRequest?,
        transcription: freezed == transcription
            ? _self.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as TranscriptionSettingsRequest?,
        video: freezed == video
            ? _self.video
            : video // ignore: cast_nullable_to_non_nullable
                  as VideoSettingsRequest?,
      ),
    );
  }
}
