// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_hls_broadcasting_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartHLSBroadcastingResponse extends StartHLSBroadcastingResponse {
  @override
  final String duration;
  @override
  final String playlistUrl;

  factory _$StartHLSBroadcastingResponse(
          [void Function(StartHLSBroadcastingResponseBuilder)? updates]) =>
      (StartHLSBroadcastingResponseBuilder()..update(updates))._build();

  _$StartHLSBroadcastingResponse._(
      {required this.duration, required this.playlistUrl})
      : super._();
  @override
  StartHLSBroadcastingResponse rebuild(
          void Function(StartHLSBroadcastingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartHLSBroadcastingResponseBuilder toBuilder() =>
      StartHLSBroadcastingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartHLSBroadcastingResponse &&
        duration == other.duration &&
        playlistUrl == other.playlistUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, playlistUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StartHLSBroadcastingResponse')
          ..add('duration', duration)
          ..add('playlistUrl', playlistUrl))
        .toString();
  }
}

class StartHLSBroadcastingResponseBuilder
    implements
        Builder<StartHLSBroadcastingResponse,
            StartHLSBroadcastingResponseBuilder> {
  _$StartHLSBroadcastingResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  String? _playlistUrl;
  String? get playlistUrl => _$this._playlistUrl;
  set playlistUrl(String? playlistUrl) => _$this._playlistUrl = playlistUrl;

  StartHLSBroadcastingResponseBuilder() {
    StartHLSBroadcastingResponse._defaults(this);
  }

  StartHLSBroadcastingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _playlistUrl = $v.playlistUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartHLSBroadcastingResponse other) {
    _$v = other as _$StartHLSBroadcastingResponse;
  }

  @override
  void update(void Function(StartHLSBroadcastingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartHLSBroadcastingResponse build() => _build();

  _$StartHLSBroadcastingResponse _build() {
    final _$result = _$v ??
        _$StartHLSBroadcastingResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StartHLSBroadcastingResponse', 'duration'),
          playlistUrl: BuiltValueNullFieldError.checkNotNull(
              playlistUrl, r'StartHLSBroadcastingResponse', 'playlistUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
