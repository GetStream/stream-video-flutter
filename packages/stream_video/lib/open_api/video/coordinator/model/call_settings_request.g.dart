// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSettingsRequest extends CallSettingsRequest {
  @override
  final AudioSettingsRequest? audio;
  @override
  final BackstageSettingsRequest? backstage;
  @override
  final BroadcastSettingsRequest? broadcasting;
  @override
  final FrameRecordingSettingsRequest? frameRecording;
  @override
  final GeofenceSettingsRequest? geofencing;
  @override
  final LimitsSettingsRequest? limits;
  @override
  final RecordSettingsRequest? recording;
  @override
  final RingSettingsRequest? ring;
  @override
  final ScreensharingSettingsRequest? screensharing;
  @override
  final SessionSettingsRequest? session;
  @override
  final ThumbnailsSettingsRequest? thumbnails;
  @override
  final TranscriptionSettingsRequest? transcription;
  @override
  final VideoSettingsRequest? video;

  factory _$CallSettingsRequest(
          [void Function(CallSettingsRequestBuilder)? updates]) =>
      (CallSettingsRequestBuilder()..update(updates))._build();

  _$CallSettingsRequest._(
      {this.audio,
      this.backstage,
      this.broadcasting,
      this.frameRecording,
      this.geofencing,
      this.limits,
      this.recording,
      this.ring,
      this.screensharing,
      this.session,
      this.thumbnails,
      this.transcription,
      this.video})
      : super._();
  @override
  CallSettingsRequest rebuild(
          void Function(CallSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSettingsRequestBuilder toBuilder() =>
      CallSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSettingsRequest &&
        audio == other.audio &&
        backstage == other.backstage &&
        broadcasting == other.broadcasting &&
        frameRecording == other.frameRecording &&
        geofencing == other.geofencing &&
        limits == other.limits &&
        recording == other.recording &&
        ring == other.ring &&
        screensharing == other.screensharing &&
        session == other.session &&
        thumbnails == other.thumbnails &&
        transcription == other.transcription &&
        video == other.video;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audio.hashCode);
    _$hash = $jc(_$hash, backstage.hashCode);
    _$hash = $jc(_$hash, broadcasting.hashCode);
    _$hash = $jc(_$hash, frameRecording.hashCode);
    _$hash = $jc(_$hash, geofencing.hashCode);
    _$hash = $jc(_$hash, limits.hashCode);
    _$hash = $jc(_$hash, recording.hashCode);
    _$hash = $jc(_$hash, ring.hashCode);
    _$hash = $jc(_$hash, screensharing.hashCode);
    _$hash = $jc(_$hash, session.hashCode);
    _$hash = $jc(_$hash, thumbnails.hashCode);
    _$hash = $jc(_$hash, transcription.hashCode);
    _$hash = $jc(_$hash, video.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallSettingsRequest')
          ..add('audio', audio)
          ..add('backstage', backstage)
          ..add('broadcasting', broadcasting)
          ..add('frameRecording', frameRecording)
          ..add('geofencing', geofencing)
          ..add('limits', limits)
          ..add('recording', recording)
          ..add('ring', ring)
          ..add('screensharing', screensharing)
          ..add('session', session)
          ..add('thumbnails', thumbnails)
          ..add('transcription', transcription)
          ..add('video', video))
        .toString();
  }
}

class CallSettingsRequestBuilder
    implements Builder<CallSettingsRequest, CallSettingsRequestBuilder> {
  _$CallSettingsRequest? _$v;

  AudioSettingsRequestBuilder? _audio;
  AudioSettingsRequestBuilder get audio =>
      _$this._audio ??= AudioSettingsRequestBuilder();
  set audio(AudioSettingsRequestBuilder? audio) => _$this._audio = audio;

  BackstageSettingsRequestBuilder? _backstage;
  BackstageSettingsRequestBuilder get backstage =>
      _$this._backstage ??= BackstageSettingsRequestBuilder();
  set backstage(BackstageSettingsRequestBuilder? backstage) =>
      _$this._backstage = backstage;

  BroadcastSettingsRequestBuilder? _broadcasting;
  BroadcastSettingsRequestBuilder get broadcasting =>
      _$this._broadcasting ??= BroadcastSettingsRequestBuilder();
  set broadcasting(BroadcastSettingsRequestBuilder? broadcasting) =>
      _$this._broadcasting = broadcasting;

  FrameRecordingSettingsRequestBuilder? _frameRecording;
  FrameRecordingSettingsRequestBuilder get frameRecording =>
      _$this._frameRecording ??= FrameRecordingSettingsRequestBuilder();
  set frameRecording(FrameRecordingSettingsRequestBuilder? frameRecording) =>
      _$this._frameRecording = frameRecording;

  GeofenceSettingsRequestBuilder? _geofencing;
  GeofenceSettingsRequestBuilder get geofencing =>
      _$this._geofencing ??= GeofenceSettingsRequestBuilder();
  set geofencing(GeofenceSettingsRequestBuilder? geofencing) =>
      _$this._geofencing = geofencing;

  LimitsSettingsRequestBuilder? _limits;
  LimitsSettingsRequestBuilder get limits =>
      _$this._limits ??= LimitsSettingsRequestBuilder();
  set limits(LimitsSettingsRequestBuilder? limits) => _$this._limits = limits;

  RecordSettingsRequestBuilder? _recording;
  RecordSettingsRequestBuilder get recording =>
      _$this._recording ??= RecordSettingsRequestBuilder();
  set recording(RecordSettingsRequestBuilder? recording) =>
      _$this._recording = recording;

  RingSettingsRequestBuilder? _ring;
  RingSettingsRequestBuilder get ring =>
      _$this._ring ??= RingSettingsRequestBuilder();
  set ring(RingSettingsRequestBuilder? ring) => _$this._ring = ring;

  ScreensharingSettingsRequestBuilder? _screensharing;
  ScreensharingSettingsRequestBuilder get screensharing =>
      _$this._screensharing ??= ScreensharingSettingsRequestBuilder();
  set screensharing(ScreensharingSettingsRequestBuilder? screensharing) =>
      _$this._screensharing = screensharing;

  SessionSettingsRequestBuilder? _session;
  SessionSettingsRequestBuilder get session =>
      _$this._session ??= SessionSettingsRequestBuilder();
  set session(SessionSettingsRequestBuilder? session) =>
      _$this._session = session;

  ThumbnailsSettingsRequestBuilder? _thumbnails;
  ThumbnailsSettingsRequestBuilder get thumbnails =>
      _$this._thumbnails ??= ThumbnailsSettingsRequestBuilder();
  set thumbnails(ThumbnailsSettingsRequestBuilder? thumbnails) =>
      _$this._thumbnails = thumbnails;

  TranscriptionSettingsRequestBuilder? _transcription;
  TranscriptionSettingsRequestBuilder get transcription =>
      _$this._transcription ??= TranscriptionSettingsRequestBuilder();
  set transcription(TranscriptionSettingsRequestBuilder? transcription) =>
      _$this._transcription = transcription;

  VideoSettingsRequestBuilder? _video;
  VideoSettingsRequestBuilder get video =>
      _$this._video ??= VideoSettingsRequestBuilder();
  set video(VideoSettingsRequestBuilder? video) => _$this._video = video;

  CallSettingsRequestBuilder() {
    CallSettingsRequest._defaults(this);
  }

  CallSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audio = $v.audio?.toBuilder();
      _backstage = $v.backstage?.toBuilder();
      _broadcasting = $v.broadcasting?.toBuilder();
      _frameRecording = $v.frameRecording?.toBuilder();
      _geofencing = $v.geofencing?.toBuilder();
      _limits = $v.limits?.toBuilder();
      _recording = $v.recording?.toBuilder();
      _ring = $v.ring?.toBuilder();
      _screensharing = $v.screensharing?.toBuilder();
      _session = $v.session?.toBuilder();
      _thumbnails = $v.thumbnails?.toBuilder();
      _transcription = $v.transcription?.toBuilder();
      _video = $v.video?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSettingsRequest other) {
    _$v = other as _$CallSettingsRequest;
  }

  @override
  void update(void Function(CallSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSettingsRequest build() => _build();

  _$CallSettingsRequest _build() {
    _$CallSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$CallSettingsRequest._(
            audio: _audio?.build(),
            backstage: _backstage?.build(),
            broadcasting: _broadcasting?.build(),
            frameRecording: _frameRecording?.build(),
            geofencing: _geofencing?.build(),
            limits: _limits?.build(),
            recording: _recording?.build(),
            ring: _ring?.build(),
            screensharing: _screensharing?.build(),
            session: _session?.build(),
            thumbnails: _thumbnails?.build(),
            transcription: _transcription?.build(),
            video: _video?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'audio';
        _audio?.build();
        _$failedField = 'backstage';
        _backstage?.build();
        _$failedField = 'broadcasting';
        _broadcasting?.build();
        _$failedField = 'frameRecording';
        _frameRecording?.build();
        _$failedField = 'geofencing';
        _geofencing?.build();
        _$failedField = 'limits';
        _limits?.build();
        _$failedField = 'recording';
        _recording?.build();
        _$failedField = 'ring';
        _ring?.build();
        _$failedField = 'screensharing';
        _screensharing?.build();
        _$failedField = 'session';
        _session?.build();
        _$failedField = 'thumbnails';
        _thumbnails?.build();
        _$failedField = 'transcription';
        _transcription?.build();
        _$failedField = 'video';
        _video?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
