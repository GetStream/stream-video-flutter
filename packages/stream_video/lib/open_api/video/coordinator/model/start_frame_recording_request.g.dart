// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_frame_recording_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartFrameRecordingRequest extends StartFrameRecordingRequest {
  @override
  final String? recordingExternalStorage;

  factory _$StartFrameRecordingRequest(
          [void Function(StartFrameRecordingRequestBuilder)? updates]) =>
      (StartFrameRecordingRequestBuilder()..update(updates))._build();

  _$StartFrameRecordingRequest._({this.recordingExternalStorage}) : super._();
  @override
  StartFrameRecordingRequest rebuild(
          void Function(StartFrameRecordingRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartFrameRecordingRequestBuilder toBuilder() =>
      StartFrameRecordingRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartFrameRecordingRequest &&
        recordingExternalStorage == other.recordingExternalStorage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recordingExternalStorage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StartFrameRecordingRequest')
          ..add('recordingExternalStorage', recordingExternalStorage))
        .toString();
  }
}

class StartFrameRecordingRequestBuilder
    implements
        Builder<StartFrameRecordingRequest, StartFrameRecordingRequestBuilder> {
  _$StartFrameRecordingRequest? _$v;

  String? _recordingExternalStorage;
  String? get recordingExternalStorage => _$this._recordingExternalStorage;
  set recordingExternalStorage(String? recordingExternalStorage) =>
      _$this._recordingExternalStorage = recordingExternalStorage;

  StartFrameRecordingRequestBuilder() {
    StartFrameRecordingRequest._defaults(this);
  }

  StartFrameRecordingRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recordingExternalStorage = $v.recordingExternalStorage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartFrameRecordingRequest other) {
    _$v = other as _$StartFrameRecordingRequest;
  }

  @override
  void update(void Function(StartFrameRecordingRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartFrameRecordingRequest build() => _build();

  _$StartFrameRecordingRequest _build() {
    final _$result = _$v ??
        _$StartFrameRecordingRequest._(
          recordingExternalStorage: recordingExternalStorage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
