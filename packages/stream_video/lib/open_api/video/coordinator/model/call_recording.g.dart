// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_recording.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallRecording extends CallRecording {
  @override
  final DateTime endTime;
  @override
  final String filename;
  @override
  final String sessionId;
  @override
  final DateTime startTime;
  @override
  final String url;

  factory _$CallRecording([void Function(CallRecordingBuilder)? updates]) =>
      (CallRecordingBuilder()..update(updates))._build();

  _$CallRecording._(
      {required this.endTime,
      required this.filename,
      required this.sessionId,
      required this.startTime,
      required this.url})
      : super._();
  @override
  CallRecording rebuild(void Function(CallRecordingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallRecordingBuilder toBuilder() => CallRecordingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallRecording &&
        endTime == other.endTime &&
        filename == other.filename &&
        sessionId == other.sessionId &&
        startTime == other.startTime &&
        url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, filename.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallRecording')
          ..add('endTime', endTime)
          ..add('filename', filename)
          ..add('sessionId', sessionId)
          ..add('startTime', startTime)
          ..add('url', url))
        .toString();
  }
}

class CallRecordingBuilder
    implements Builder<CallRecording, CallRecordingBuilder> {
  _$CallRecording? _$v;

  DateTime? _endTime;
  DateTime? get endTime => _$this._endTime;
  set endTime(DateTime? endTime) => _$this._endTime = endTime;

  String? _filename;
  String? get filename => _$this._filename;
  set filename(String? filename) => _$this._filename = filename;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  DateTime? _startTime;
  DateTime? get startTime => _$this._startTime;
  set startTime(DateTime? startTime) => _$this._startTime = startTime;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  CallRecordingBuilder() {
    CallRecording._defaults(this);
  }

  CallRecordingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _endTime = $v.endTime;
      _filename = $v.filename;
      _sessionId = $v.sessionId;
      _startTime = $v.startTime;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallRecording other) {
    _$v = other as _$CallRecording;
  }

  @override
  void update(void Function(CallRecordingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallRecording build() => _build();

  _$CallRecording _build() {
    final _$result = _$v ??
        _$CallRecording._(
          endTime: BuiltValueNullFieldError.checkNotNull(
              endTime, r'CallRecording', 'endTime'),
          filename: BuiltValueNullFieldError.checkNotNull(
              filename, r'CallRecording', 'filename'),
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'CallRecording', 'sessionId'),
          startTime: BuiltValueNullFieldError.checkNotNull(
              startTime, r'CallRecording', 'startTime'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'CallRecording', 'url'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
