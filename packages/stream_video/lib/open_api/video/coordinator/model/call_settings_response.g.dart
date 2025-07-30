// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallSettingsResponse extends CallSettingsResponse {
  @override
  final AudioSettingsResponse audio;
  @override
  final BackstageSettingsResponse backstage;
  @override
  final BroadcastSettingsResponse broadcasting;
  @override
  final FrameRecordingSettingsResponse frameRecording;
  @override
  final GeofenceSettingsResponse geofencing;
  @override
  final LimitsSettingsResponse limits;
  @override
  final RecordSettingsResponse recording;
  @override
  final RingSettingsResponse ring;
  @override
  final ScreensharingSettingsResponse screensharing;
  @override
  final SessionSettingsResponse session;
  @override
  final ThumbnailsSettingsResponse thumbnails;
  @override
  final TranscriptionSettingsResponse transcription;
  @override
  final VideoSettingsResponse video;

  factory _$CallSettingsResponse(
          [void Function(CallSettingsResponseBuilder)? updates]) =>
      (CallSettingsResponseBuilder()..update(updates))._build();

  _$CallSettingsResponse._(
      {required this.audio,
      required this.backstage,
      required this.broadcasting,
      required this.frameRecording,
      required this.geofencing,
      required this.limits,
      required this.recording,
      required this.ring,
      required this.screensharing,
      required this.session,
      required this.thumbnails,
      required this.transcription,
      required this.video})
      : super._();
  @override
  CallSettingsResponse rebuild(
          void Function(CallSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallSettingsResponseBuilder toBuilder() =>
      CallSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallSettingsResponse &&
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
    return (newBuiltValueToStringHelper(r'CallSettingsResponse')
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

class CallSettingsResponseBuilder
    implements Builder<CallSettingsResponse, CallSettingsResponseBuilder> {
  _$CallSettingsResponse? _$v;

  AudioSettingsResponseBuilder? _audio;
  AudioSettingsResponseBuilder get audio =>
      _$this._audio ??= AudioSettingsResponseBuilder();
  set audio(AudioSettingsResponseBuilder? audio) => _$this._audio = audio;

  BackstageSettingsResponseBuilder? _backstage;
  BackstageSettingsResponseBuilder get backstage =>
      _$this._backstage ??= BackstageSettingsResponseBuilder();
  set backstage(BackstageSettingsResponseBuilder? backstage) =>
      _$this._backstage = backstage;

  BroadcastSettingsResponseBuilder? _broadcasting;
  BroadcastSettingsResponseBuilder get broadcasting =>
      _$this._broadcasting ??= BroadcastSettingsResponseBuilder();
  set broadcasting(BroadcastSettingsResponseBuilder? broadcasting) =>
      _$this._broadcasting = broadcasting;

  FrameRecordingSettingsResponseBuilder? _frameRecording;
  FrameRecordingSettingsResponseBuilder get frameRecording =>
      _$this._frameRecording ??= FrameRecordingSettingsResponseBuilder();
  set frameRecording(FrameRecordingSettingsResponseBuilder? frameRecording) =>
      _$this._frameRecording = frameRecording;

  GeofenceSettingsResponseBuilder? _geofencing;
  GeofenceSettingsResponseBuilder get geofencing =>
      _$this._geofencing ??= GeofenceSettingsResponseBuilder();
  set geofencing(GeofenceSettingsResponseBuilder? geofencing) =>
      _$this._geofencing = geofencing;

  LimitsSettingsResponseBuilder? _limits;
  LimitsSettingsResponseBuilder get limits =>
      _$this._limits ??= LimitsSettingsResponseBuilder();
  set limits(LimitsSettingsResponseBuilder? limits) => _$this._limits = limits;

  RecordSettingsResponseBuilder? _recording;
  RecordSettingsResponseBuilder get recording =>
      _$this._recording ??= RecordSettingsResponseBuilder();
  set recording(RecordSettingsResponseBuilder? recording) =>
      _$this._recording = recording;

  RingSettingsResponseBuilder? _ring;
  RingSettingsResponseBuilder get ring =>
      _$this._ring ??= RingSettingsResponseBuilder();
  set ring(RingSettingsResponseBuilder? ring) => _$this._ring = ring;

  ScreensharingSettingsResponseBuilder? _screensharing;
  ScreensharingSettingsResponseBuilder get screensharing =>
      _$this._screensharing ??= ScreensharingSettingsResponseBuilder();
  set screensharing(ScreensharingSettingsResponseBuilder? screensharing) =>
      _$this._screensharing = screensharing;

  SessionSettingsResponseBuilder? _session;
  SessionSettingsResponseBuilder get session =>
      _$this._session ??= SessionSettingsResponseBuilder();
  set session(SessionSettingsResponseBuilder? session) =>
      _$this._session = session;

  ThumbnailsSettingsResponseBuilder? _thumbnails;
  ThumbnailsSettingsResponseBuilder get thumbnails =>
      _$this._thumbnails ??= ThumbnailsSettingsResponseBuilder();
  set thumbnails(ThumbnailsSettingsResponseBuilder? thumbnails) =>
      _$this._thumbnails = thumbnails;

  TranscriptionSettingsResponseBuilder? _transcription;
  TranscriptionSettingsResponseBuilder get transcription =>
      _$this._transcription ??= TranscriptionSettingsResponseBuilder();
  set transcription(TranscriptionSettingsResponseBuilder? transcription) =>
      _$this._transcription = transcription;

  VideoSettingsResponseBuilder? _video;
  VideoSettingsResponseBuilder get video =>
      _$this._video ??= VideoSettingsResponseBuilder();
  set video(VideoSettingsResponseBuilder? video) => _$this._video = video;

  CallSettingsResponseBuilder() {
    CallSettingsResponse._defaults(this);
  }

  CallSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audio = $v.audio.toBuilder();
      _backstage = $v.backstage.toBuilder();
      _broadcasting = $v.broadcasting.toBuilder();
      _frameRecording = $v.frameRecording.toBuilder();
      _geofencing = $v.geofencing.toBuilder();
      _limits = $v.limits.toBuilder();
      _recording = $v.recording.toBuilder();
      _ring = $v.ring.toBuilder();
      _screensharing = $v.screensharing.toBuilder();
      _session = $v.session.toBuilder();
      _thumbnails = $v.thumbnails.toBuilder();
      _transcription = $v.transcription.toBuilder();
      _video = $v.video.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallSettingsResponse other) {
    _$v = other as _$CallSettingsResponse;
  }

  @override
  void update(void Function(CallSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallSettingsResponse build() => _build();

  _$CallSettingsResponse _build() {
    _$CallSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$CallSettingsResponse._(
            audio: audio.build(),
            backstage: backstage.build(),
            broadcasting: broadcasting.build(),
            frameRecording: frameRecording.build(),
            geofencing: geofencing.build(),
            limits: limits.build(),
            recording: recording.build(),
            ring: ring.build(),
            screensharing: screensharing.build(),
            session: session.build(),
            thumbnails: thumbnails.build(),
            transcription: transcription.build(),
            video: video.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'audio';
        audio.build();
        _$failedField = 'backstage';
        backstage.build();
        _$failedField = 'broadcasting';
        broadcasting.build();
        _$failedField = 'frameRecording';
        frameRecording.build();
        _$failedField = 'geofencing';
        geofencing.build();
        _$failedField = 'limits';
        limits.build();
        _$failedField = 'recording';
        recording.build();
        _$failedField = 'ring';
        ring.build();
        _$failedField = 'screensharing';
        screensharing.build();
        _$failedField = 'session';
        session.build();
        _$failedField = 'thumbnails';
        thumbnails.build();
        _$failedField = 'transcription';
        transcription.build();
        _$failedField = 'video';
        video.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
