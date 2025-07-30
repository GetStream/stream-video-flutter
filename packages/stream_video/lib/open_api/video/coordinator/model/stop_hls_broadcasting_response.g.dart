// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_hls_broadcasting_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopHLSBroadcastingResponse extends StopHLSBroadcastingResponse {
  @override
  final String duration;

  factory _$StopHLSBroadcastingResponse(
          [void Function(StopHLSBroadcastingResponseBuilder)? updates]) =>
      (StopHLSBroadcastingResponseBuilder()..update(updates))._build();

  _$StopHLSBroadcastingResponse._({required this.duration}) : super._();
  @override
  StopHLSBroadcastingResponse rebuild(
          void Function(StopHLSBroadcastingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopHLSBroadcastingResponseBuilder toBuilder() =>
      StopHLSBroadcastingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopHLSBroadcastingResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopHLSBroadcastingResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopHLSBroadcastingResponseBuilder
    implements
        Builder<StopHLSBroadcastingResponse,
            StopHLSBroadcastingResponseBuilder> {
  _$StopHLSBroadcastingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopHLSBroadcastingResponseBuilder() {
    StopHLSBroadcastingResponse._defaults(this);
  }

  StopHLSBroadcastingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopHLSBroadcastingResponse other) {
    _$v = other as _$StopHLSBroadcastingResponse;
  }

  @override
  void update(void Function(StopHLSBroadcastingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopHLSBroadcastingResponse build() => _build();

  _$StopHLSBroadcastingResponse _build() {
    final _$result = _$v ??
        _$StopHLSBroadcastingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopHLSBroadcastingResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
