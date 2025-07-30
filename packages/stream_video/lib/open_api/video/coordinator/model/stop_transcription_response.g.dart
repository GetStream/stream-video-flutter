// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_transcription_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopTranscriptionResponse extends StopTranscriptionResponse {
  @override
  final String duration;

  factory _$StopTranscriptionResponse(
          [void Function(StopTranscriptionResponseBuilder)? updates]) =>
      (StopTranscriptionResponseBuilder()..update(updates))._build();

  _$StopTranscriptionResponse._({required this.duration}) : super._();
  @override
  StopTranscriptionResponse rebuild(
          void Function(StopTranscriptionResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopTranscriptionResponseBuilder toBuilder() =>
      StopTranscriptionResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopTranscriptionResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopTranscriptionResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopTranscriptionResponseBuilder
    implements
        Builder<StopTranscriptionResponse, StopTranscriptionResponseBuilder> {
  _$StopTranscriptionResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopTranscriptionResponseBuilder() {
    StopTranscriptionResponse._defaults(this);
  }

  StopTranscriptionResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopTranscriptionResponse other) {
    _$v = other as _$StopTranscriptionResponse;
  }

  @override
  void update(void Function(StopTranscriptionResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopTranscriptionResponse build() => _build();

  _$StopTranscriptionResponse _build() {
    final _$result = _$v ??
        _$StopTranscriptionResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopTranscriptionResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
