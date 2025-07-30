// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FrameRecordingResponse extends FrameRecordingResponse {
  @override
  final String status;

  factory _$FrameRecordingResponse(
          [void Function(FrameRecordingResponseBuilder)? updates]) =>
      (FrameRecordingResponseBuilder()..update(updates))._build();

  _$FrameRecordingResponse._({required this.status}) : super._();
  @override
  FrameRecordingResponse rebuild(
          void Function(FrameRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FrameRecordingResponseBuilder toBuilder() =>
      FrameRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FrameRecordingResponse && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FrameRecordingResponse')
          ..add('status', status))
        .toString();
  }
}

class FrameRecordingResponseBuilder
    implements Builder<FrameRecordingResponse, FrameRecordingResponseBuilder> {
  _$FrameRecordingResponse? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  FrameRecordingResponseBuilder() {
    FrameRecordingResponse._defaults(this);
  }

  FrameRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FrameRecordingResponse other) {
    _$v = other as _$FrameRecordingResponse;
  }

  @override
  void update(void Function(FrameRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FrameRecordingResponse build() => _build();

  _$FrameRecordingResponse _build() {
    final _$result = _$v ??
        _$FrameRecordingResponse._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'FrameRecordingResponse', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
