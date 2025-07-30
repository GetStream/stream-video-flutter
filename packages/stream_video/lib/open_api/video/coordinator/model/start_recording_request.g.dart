// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_recording_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartRecordingRequest extends StartRecordingRequest {
  @override
  final String? recordingExternalStorage;

  factory _$StartRecordingRequest(
          [void Function(StartRecordingRequestBuilder)? updates]) =>
      (StartRecordingRequestBuilder()..update(updates))._build();

  _$StartRecordingRequest._({this.recordingExternalStorage}) : super._();
  @override
  StartRecordingRequest rebuild(
          void Function(StartRecordingRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartRecordingRequestBuilder toBuilder() =>
      StartRecordingRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartRecordingRequest &&
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
    return (newBuiltValueToStringHelper(r'StartRecordingRequest')
          ..add('recordingExternalStorage', recordingExternalStorage))
        .toString();
  }
}

class StartRecordingRequestBuilder
    implements Builder<StartRecordingRequest, StartRecordingRequestBuilder> {
  _$StartRecordingRequest? _$v;

  String? _recordingExternalStorage;
  String? get recordingExternalStorage => _$this._recordingExternalStorage;
  set recordingExternalStorage(String? recordingExternalStorage) =>
      _$this._recordingExternalStorage = recordingExternalStorage;

  StartRecordingRequestBuilder() {
    StartRecordingRequest._defaults(this);
  }

  StartRecordingRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recordingExternalStorage = $v.recordingExternalStorage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartRecordingRequest other) {
    _$v = other as _$StartRecordingRequest;
  }

  @override
  void update(void Function(StartRecordingRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartRecordingRequest build() => _build();

  _$StartRecordingRequest _build() {
    final _$result = _$v ??
        _$StartRecordingRequest._(
          recordingExternalStorage: recordingExternalStorage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
