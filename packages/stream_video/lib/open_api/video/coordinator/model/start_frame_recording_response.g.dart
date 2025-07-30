// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_frame_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartFrameRecordingResponse extends StartFrameRecordingResponse {
  @override
  final String duration;

  factory _$StartFrameRecordingResponse(
          [void Function(StartFrameRecordingResponseBuilder)? updates]) =>
      (StartFrameRecordingResponseBuilder()..update(updates))._build();

  _$StartFrameRecordingResponse._({required this.duration}) : super._();
  @override
  StartFrameRecordingResponse rebuild(
          void Function(StartFrameRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartFrameRecordingResponseBuilder toBuilder() =>
      StartFrameRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartFrameRecordingResponse && duration == other.duration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StartFrameRecordingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StartFrameRecordingResponseBuilder
    implements
        Builder<StartFrameRecordingResponse,
            StartFrameRecordingResponseBuilder> {
  _$StartFrameRecordingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StartFrameRecordingResponseBuilder() {
    StartFrameRecordingResponse._defaults(this);
  }

  StartFrameRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartFrameRecordingResponse other) {
    _$v = other as _$StartFrameRecordingResponse;
  }

  @override
  void update(void Function(StartFrameRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartFrameRecordingResponse build() => _build();

  _$StartFrameRecordingResponse _build() {
    final _$result = _$v ??
        _$StartFrameRecordingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StartFrameRecordingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
