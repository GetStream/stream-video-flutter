// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_rtmp_broadcasts_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StopRTMPBroadcastsResponse extends StopRTMPBroadcastsResponse {
  @override
  final String duration;

  factory _$StopRTMPBroadcastsResponse(
          [void Function(StopRTMPBroadcastsResponseBuilder)? updates]) =>
      (StopRTMPBroadcastsResponseBuilder()..update(updates))._build();

  _$StopRTMPBroadcastsResponse._({required this.duration}) : super._();
  @override
  StopRTMPBroadcastsResponse rebuild(
          void Function(StopRTMPBroadcastsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StopRTMPBroadcastsResponseBuilder toBuilder() =>
      StopRTMPBroadcastsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StopRTMPBroadcastsResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StopRTMPBroadcastsResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StopRTMPBroadcastsResponseBuilder
    implements
        Builder<StopRTMPBroadcastsResponse, StopRTMPBroadcastsResponseBuilder> {
  _$StopRTMPBroadcastsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StopRTMPBroadcastsResponseBuilder() {
    StopRTMPBroadcastsResponse._defaults(this);
  }

  StopRTMPBroadcastsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StopRTMPBroadcastsResponse other) {
    _$v = other as _$StopRTMPBroadcastsResponse;
  }

  @override
  void update(void Function(StopRTMPBroadcastsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StopRTMPBroadcastsResponse build() => _build();

  _$StopRTMPBroadcastsResponse _build() {
    final _$result = _$v ??
        _$StopRTMPBroadcastsResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StopRTMPBroadcastsResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
