// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_rtmp_broadcasts_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StartRTMPBroadcastsResponse extends StartRTMPBroadcastsResponse {
  @override
  final String duration;

  factory _$StartRTMPBroadcastsResponse(
          [void Function(StartRTMPBroadcastsResponseBuilder)? updates]) =>
      (StartRTMPBroadcastsResponseBuilder()..update(updates))._build();

  _$StartRTMPBroadcastsResponse._({required this.duration}) : super._();
  @override
  StartRTMPBroadcastsResponse rebuild(
          void Function(StartRTMPBroadcastsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StartRTMPBroadcastsResponseBuilder toBuilder() =>
      StartRTMPBroadcastsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StartRTMPBroadcastsResponse && duration == other.duration;
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
    return (newBuiltValueToStringHelper(r'StartRTMPBroadcastsResponse')
          ..add('duration', duration))
        .toString();
  }
}

class StartRTMPBroadcastsResponseBuilder
    implements
        Builder<StartRTMPBroadcastsResponse,
            StartRTMPBroadcastsResponseBuilder> {
  _$StartRTMPBroadcastsResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  StartRTMPBroadcastsResponseBuilder() {
    StartRTMPBroadcastsResponse._defaults(this);
  }

  StartRTMPBroadcastsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StartRTMPBroadcastsResponse other) {
    _$v = other as _$StartRTMPBroadcastsResponse;
  }

  @override
  void update(void Function(StartRTMPBroadcastsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StartRTMPBroadcastsResponse build() => _build();

  _$StartRTMPBroadcastsResponse _build() {
    final _$result = _$v ??
        _$StartRTMPBroadcastsResponse._(
          duration: BuiltValueNullFieldError.checkNotNull(
              duration, r'StartRTMPBroadcastsResponse', 'duration'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
