// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BroadcastSettingsResponse extends BroadcastSettingsResponse {
  @override
  final bool enabled;
  @override
  final HLSSettingsResponse hls;
  @override
  final RTMPSettingsResponse rtmp;

  factory _$BroadcastSettingsResponse(
          [void Function(BroadcastSettingsResponseBuilder)? updates]) =>
      (BroadcastSettingsResponseBuilder()..update(updates))._build();

  _$BroadcastSettingsResponse._(
      {required this.enabled, required this.hls, required this.rtmp})
      : super._();
  @override
  BroadcastSettingsResponse rebuild(
          void Function(BroadcastSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BroadcastSettingsResponseBuilder toBuilder() =>
      BroadcastSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BroadcastSettingsResponse &&
        enabled == other.enabled &&
        hls == other.hls &&
        rtmp == other.rtmp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, hls.hashCode);
    _$hash = $jc(_$hash, rtmp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BroadcastSettingsResponse')
          ..add('enabled', enabled)
          ..add('hls', hls)
          ..add('rtmp', rtmp))
        .toString();
  }
}

class BroadcastSettingsResponseBuilder
    implements
        Builder<BroadcastSettingsResponse, BroadcastSettingsResponseBuilder> {
  _$BroadcastSettingsResponse? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  HLSSettingsResponseBuilder? _hls;
  HLSSettingsResponseBuilder get hls =>
      _$this._hls ??= HLSSettingsResponseBuilder();
  set hls(HLSSettingsResponseBuilder? hls) => _$this._hls = hls;

  RTMPSettingsResponseBuilder? _rtmp;
  RTMPSettingsResponseBuilder get rtmp =>
      _$this._rtmp ??= RTMPSettingsResponseBuilder();
  set rtmp(RTMPSettingsResponseBuilder? rtmp) => _$this._rtmp = rtmp;

  BroadcastSettingsResponseBuilder() {
    BroadcastSettingsResponse._defaults(this);
  }

  BroadcastSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _hls = $v.hls.toBuilder();
      _rtmp = $v.rtmp.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BroadcastSettingsResponse other) {
    _$v = other as _$BroadcastSettingsResponse;
  }

  @override
  void update(void Function(BroadcastSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BroadcastSettingsResponse build() => _build();

  _$BroadcastSettingsResponse _build() {
    _$BroadcastSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$BroadcastSettingsResponse._(
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'BroadcastSettingsResponse', 'enabled'),
            hls: hls.build(),
            rtmp: rtmp.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'hls';
        hls.build();
        _$failedField = 'rtmp';
        rtmp.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BroadcastSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
