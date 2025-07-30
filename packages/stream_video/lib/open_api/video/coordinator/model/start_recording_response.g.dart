// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_recording_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartRecordingResponse extends StartRecordingResponse {
  @override
  final String duration;

  factory _$StartRecordingResponse(
          [void Function(StartRecordingResponseBuilder)? updates]) =>
      (StartRecordingResponseBuilder()..update(updates))._build();

  _$StartRecordingResponse._({required this.duration}) : super._();
  @override
  StartRecordingResponse rebuild(
          void Function(StartRecordingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartRecordingResponseBuilder toBuilder() =>
      StartRecordingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartRecordingResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StartRecordingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StartRecordingResponseBuilder
    implements Builder<StartRecordingResponse, StartRecordingResponseBuilder> {
  _$StartRecordingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StartRecordingResponseBuilder() {
    StartRecordingResponse._defaults(this);
  }

  StartRecordingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartRecordingResponse other) {
    _$v = other as _$StartRecordingResponse;
  }

  @override
  void update(void Function(StartRecordingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartRecordingResponse build() => _build();

  _$StartRecordingResponse _build() {
    final _$result = _$v ??
        _$StartRecordingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StartRecordingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
