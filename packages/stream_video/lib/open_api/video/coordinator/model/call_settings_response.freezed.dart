// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallSettingsResponse {

 AudioSettingsResponse get audio; BackstageSettingsResponse get backstage; BroadcastSettingsResponse get broadcasting; FrameRecordingSettingsResponse get frameRecording; GeofenceSettingsResponse get geofencing; IndividualRecordingSettingsResponse get individualRecording; IngressSettingsResponse? get ingress; LimitsSettingsResponse get limits; RawRecordingSettingsResponse get rawRecording; RecordSettingsResponse get recording; RingSettingsResponse get ring; ScreensharingSettingsResponse get screensharing; SessionSettingsResponse get session; ThumbnailsSettingsResponse get thumbnails; TranscriptionSettingsResponse get transcription; VideoSettingsResponse get video;
/// Create a copy of CallSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallSettingsResponseCopyWith<CallSettingsResponse> get copyWith => _$CallSettingsResponseCopyWithImpl<CallSettingsResponse>(this as CallSettingsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallSettingsResponse&&(identical(other.audio, audio) || other.audio == audio)&&(identical(other.backstage, backstage) || other.backstage == backstage)&&(identical(other.broadcasting, broadcasting) || other.broadcasting == broadcasting)&&(identical(other.frameRecording, frameRecording) || other.frameRecording == frameRecording)&&(identical(other.geofencing, geofencing) || other.geofencing == geofencing)&&(identical(other.individualRecording, individualRecording) || other.individualRecording == individualRecording)&&(identical(other.ingress, ingress) || other.ingress == ingress)&&(identical(other.limits, limits) || other.limits == limits)&&(identical(other.rawRecording, rawRecording) || other.rawRecording == rawRecording)&&(identical(other.recording, recording) || other.recording == recording)&&(identical(other.ring, ring) || other.ring == ring)&&(identical(other.screensharing, screensharing) || other.screensharing == screensharing)&&(identical(other.session, session) || other.session == session)&&(identical(other.thumbnails, thumbnails) || other.thumbnails == thumbnails)&&(identical(other.transcription, transcription) || other.transcription == transcription)&&(identical(other.video, video) || other.video == video));
}


@override
int get hashCode => Object.hash(runtimeType,audio,backstage,broadcasting,frameRecording,geofencing,individualRecording,ingress,limits,rawRecording,recording,ring,screensharing,session,thumbnails,transcription,video);

@override
String toString() {
  return 'CallSettingsResponse(audio: $audio, backstage: $backstage, broadcasting: $broadcasting, frameRecording: $frameRecording, geofencing: $geofencing, individualRecording: $individualRecording, ingress: $ingress, limits: $limits, rawRecording: $rawRecording, recording: $recording, ring: $ring, screensharing: $screensharing, session: $session, thumbnails: $thumbnails, transcription: $transcription, video: $video)';
}


}

/// @nodoc
abstract mixin class $CallSettingsResponseCopyWith<$Res>  {
  factory $CallSettingsResponseCopyWith(CallSettingsResponse value, $Res Function(CallSettingsResponse) _then) = _$CallSettingsResponseCopyWithImpl;
@useResult
$Res call({
 AudioSettingsResponse audio, BackstageSettingsResponse backstage, BroadcastSettingsResponse broadcasting, FrameRecordingSettingsResponse frameRecording, GeofenceSettingsResponse geofencing, IndividualRecordingSettingsResponse individualRecording, IngressSettingsResponse? ingress, LimitsSettingsResponse limits, RawRecordingSettingsResponse rawRecording, RecordSettingsResponse recording, RingSettingsResponse ring, ScreensharingSettingsResponse screensharing, SessionSettingsResponse session, ThumbnailsSettingsResponse thumbnails, TranscriptionSettingsResponse transcription, VideoSettingsResponse video
});




}
/// @nodoc
class _$CallSettingsResponseCopyWithImpl<$Res>
    implements $CallSettingsResponseCopyWith<$Res> {
  _$CallSettingsResponseCopyWithImpl(this._self, this._then);

  final CallSettingsResponse _self;
  final $Res Function(CallSettingsResponse) _then;

/// Create a copy of CallSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? audio = null,Object? backstage = null,Object? broadcasting = null,Object? frameRecording = null,Object? geofencing = null,Object? individualRecording = null,Object? ingress = freezed,Object? limits = null,Object? rawRecording = null,Object? recording = null,Object? ring = null,Object? screensharing = null,Object? session = null,Object? thumbnails = null,Object? transcription = null,Object? video = null,}) {
  return _then(CallSettingsResponse(
audio: null == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as AudioSettingsResponse,backstage: null == backstage ? _self.backstage : backstage // ignore: cast_nullable_to_non_nullable
as BackstageSettingsResponse,broadcasting: null == broadcasting ? _self.broadcasting : broadcasting // ignore: cast_nullable_to_non_nullable
as BroadcastSettingsResponse,frameRecording: null == frameRecording ? _self.frameRecording : frameRecording // ignore: cast_nullable_to_non_nullable
as FrameRecordingSettingsResponse,geofencing: null == geofencing ? _self.geofencing : geofencing // ignore: cast_nullable_to_non_nullable
as GeofenceSettingsResponse,individualRecording: null == individualRecording ? _self.individualRecording : individualRecording // ignore: cast_nullable_to_non_nullable
as IndividualRecordingSettingsResponse,ingress: freezed == ingress ? _self.ingress : ingress // ignore: cast_nullable_to_non_nullable
as IngressSettingsResponse?,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as LimitsSettingsResponse,rawRecording: null == rawRecording ? _self.rawRecording : rawRecording // ignore: cast_nullable_to_non_nullable
as RawRecordingSettingsResponse,recording: null == recording ? _self.recording : recording // ignore: cast_nullable_to_non_nullable
as RecordSettingsResponse,ring: null == ring ? _self.ring : ring // ignore: cast_nullable_to_non_nullable
as RingSettingsResponse,screensharing: null == screensharing ? _self.screensharing : screensharing // ignore: cast_nullable_to_non_nullable
as ScreensharingSettingsResponse,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionSettingsResponse,thumbnails: null == thumbnails ? _self.thumbnails : thumbnails // ignore: cast_nullable_to_non_nullable
as ThumbnailsSettingsResponse,transcription: null == transcription ? _self.transcription : transcription // ignore: cast_nullable_to_non_nullable
as TranscriptionSettingsResponse,video: null == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as VideoSettingsResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [CallSettingsResponse].
extension CallSettingsResponsePatterns on CallSettingsResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
