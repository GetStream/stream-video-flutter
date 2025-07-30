// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_frame_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopFrameRecordingResponse extends StopFrameRecordingResponse {
  @override
  final String duration;

  factory _$StopFrameRecordingResponse(
          [void Function(StopFrameRecordingResponseBuilder)? updates]) =>
      (StopFrameRecordingResponseBuilder()..update(updates))._build();

  _$StopFrameRecordingResponse._({required this.duration}) : super._();
  @override
  StopFrameRecordingResponse rebuild(
          void Function(StopFrameRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopFrameRecordingResponseBuilder toBuilder() =>
      StopFrameRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopFrameRecordingResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopFrameRecordingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopFrameRecordingResponseBuilder
    implements
        Builder<StopFrameRecordingResponse, StopFrameRecordingResponseBuilder> {
  _$StopFrameRecordingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopFrameRecordingResponseBuilder() {
    StopFrameRecordingResponse._defaults(this);
  }

  StopFrameRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopFrameRecordingResponse other) {
    _$v = other as _$StopFrameRecordingResponse;
  }

  @override
  void update(void Function(StopFrameRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopFrameRecordingResponse build() => _build();

  _$StopFrameRecordingResponse _build() {
    final _$result = _$v ??
        _$StopFrameRecordingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopFrameRecordingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
