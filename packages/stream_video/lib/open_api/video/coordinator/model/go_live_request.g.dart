// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveRequest extends GoLiveRequest {
  @override
  final String? recordingStorageName;
  @override
  final bool? startClosedCaption;
  @override
  final bool? startHls;
  @override
  final bool? startRecording;
  @override
  final bool? startTranscription;
  @override
  final String? transcriptionStorageName;

  factory _$GoLiveRequest([void Function(GoLiveRequestBuilder)? updates]) =>
      (GoLiveRequestBuilder()..update(updates))._build();

  _$GoLiveRequest._(
      {this.recordingStorageName,
      this.startClosedCaption,
      this.startHls,
      this.startRecording,
      this.startTranscription,
      this.transcriptionStorageName})
      : super._();
  @override
  GoLiveRequest rebuild(void Function(GoLiveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveRequestBuilder toBuilder() => GoLiveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveRequest &&
        recordingStorageName == other.recordingStorageName &&
        startClosedCaption == other.startClosedCaption &&
        startHls == other.startHls &&
        startRecording == other.startRecording &&
        startTranscription == other.startTranscription &&
        transcriptionStorageName == other.transcriptionStorageName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recordingStorageName.hashCode);
    _$hash = $jc(_$hash, startClosedCaption.hashCode);
    _$hash = $jc(_$hash, startHls.hashCode);
    _$hash = $jc(_$hash, startRecording.hashCode);
    _$hash = $jc(_$hash, startTranscription.hashCode);
    _$hash = $jc(_$hash, transcriptionStorageName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveRequest')
          ..add('recordingStorageName', recordingStorageName)
          ..add('startClosedCaption', startClosedCaption)
          ..add('startHls', startHls)
          ..add('startRecording', startRecording)
          ..add('startTranscription', startTranscription)
          ..add('transcriptionStorageName', transcriptionStorageName))
        .toString();
  }
}

class GoLiveRequestBuilder
    implements Builder<GoLiveRequest, GoLiveRequestBuilder> {
  _$GoLiveRequest? _$v;

  String? _recordingStorageName;
  String? get recordingStorageName => _$this._recordingStorageName;
  set recordingStorageName(String? recordingStorageName) =>
      _$this._recordingStorageName = recordingStorageName;

  bool? _startClosedCaption;
  bool? get startClosedCaption => _$this._startClosedCaption;
  set startClosedCaption(bool? startClosedCaption) =>
      _$this._startClosedCaption = startClosedCaption;

  bool? _startHls;
  bool? get startHls => _$this._startHls;
  set startHls(bool? startHls) => _$this._startHls = startHls;

  bool? _startRecording;
  bool? get startRecording => _$this._startRecording;
  set startRecording(bool? startRecording) =>
      _$this._startRecording = startRecording;

  bool? _startTranscription;
  bool? get startTranscription => _$this._startTranscription;
  set startTranscription(bool? startTranscription) =>
      _$this._startTranscription = startTranscription;

  String? _transcriptionStorageName;
  String? get transcriptionStorageName => _$this._transcriptionStorageName;
  set transcriptionStorageName(String? transcriptionStorageName) =>
      _$this._transcriptionStorageName = transcriptionStorageName;

  GoLiveRequestBuilder() {
    GoLiveRequest._defaults(this);
  }

  GoLiveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recordingStorageName = $v.recordingStorageName;
      _startClosedCaption = $v.startClosedCaption;
      _startHls = $v.startHls;
      _startRecording = $v.startRecording;
      _startTranscription = $v.startTranscription;
      _transcriptionStorageName = $v.transcriptionStorageName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveRequest other) {
    _$v = other as _$GoLiveRequest;
  }

  @override
  void update(void Function(GoLiveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveRequest build() => _build();

  _$GoLiveRequest _build() {
    final _$result = _$v ??
        _$GoLiveRequest._(
          recordingStorageName: recordingStorageName,
          startClosedCaption: startClosedCaption,
          startHls: startHls,
          startRecording: startRecording,
          startTranscription: startTranscription,
          transcriptionStorageName: transcriptionStorageName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
