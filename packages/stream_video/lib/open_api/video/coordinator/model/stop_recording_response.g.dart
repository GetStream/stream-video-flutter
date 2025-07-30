// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopRecordingResponse extends StopRecordingResponse {
  @override
  final String duration;

  factory _$StopRecordingResponse(
          [void Function(StopRecordingResponseBuilder)? updates]) =>
      (StopRecordingResponseBuilder()..update(updates))._build();

  _$StopRecordingResponse._({required this.duration}) : super._();
  @override
  StopRecordingResponse rebuild(
          void Function(StopRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopRecordingResponseBuilder toBuilder() =>
      StopRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopRecordingResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopRecordingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopRecordingResponseBuilder
    implements Builder<StopRecordingResponse, StopRecordingResponseBuilder> {
  _$StopRecordingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopRecordingResponseBuilder() {
    StopRecordingResponse._defaults(this);
  }

  StopRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopRecordingResponse other) {
    _$v = other as _$StopRecordingResponse;
  }

  @override
  void update(void Function(StopRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopRecordingResponse build() => _build();

  _$StopRecordingResponse _build() {
    final _$result = _$v ??
        _$StopRecordingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopRecordingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
