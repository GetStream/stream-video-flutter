// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BroadcastSettingsRequest extends BroadcastSettingsRequest {
  @override
  final bool? enabled;
  @override
  final HLSSettingsRequest? hls;
  @override
  final RTMPSettingsRequest? rtmp;

  factory _$BroadcastSettingsRequest(
          [void Function(BroadcastSettingsRequestBuilder)? updates]) =>
      (BroadcastSettingsRequestBuilder()..update(updates))._build();

  _$BroadcastSettingsRequest._({this.enabled, this.hls, this.rtmp}) : super._();
  @override
  BroadcastSettingsRequest rebuild(
          void Function(BroadcastSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BroadcastSettingsRequestBuilder toBuilder() =>
      BroadcastSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BroadcastSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'BroadcastSettingsRequest')
          ..add('enabled', enabled)
          ..add('hls', hls)
          ..add('rtmp', rtmp))
        .toString();
  }
}

class BroadcastSettingsRequestBuilder
    implements
        Builder<BroadcastSettingsRequest, BroadcastSettingsRequestBuilder> {
  _$BroadcastSettingsRequest? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  HLSSettingsRequestBuilder? _hls;
  HLSSettingsRequestBuilder get hls =>
      _$this._hls ??= HLSSettingsRequestBuilder();
  set hls(HLSSettingsRequestBuilder? hls) => _$this._hls = hls;

  RTMPSettingsRequestBuilder? _rtmp;
  RTMPSettingsRequestBuilder get rtmp =>
      _$this._rtmp ??= RTMPSettingsRequestBuilder();
  set rtmp(RTMPSettingsRequestBuilder? rtmp) => _$this._rtmp = rtmp;

  BroadcastSettingsRequestBuilder() {
    BroadcastSettingsRequest._defaults(this);
  }

  BroadcastSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _hls = $v.hls?.toBuilder();
      _rtmp = $v.rtmp?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BroadcastSettingsRequest other) {
    _$v = other as _$BroadcastSettingsRequest;
  }

  @override
  void update(void Function(BroadcastSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BroadcastSettingsRequest build() => _build();

  _$BroadcastSettingsRequest _build() {
    _$BroadcastSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$BroadcastSettingsRequest._(
            enabled: enabled,
            hls: _hls?.build(),
            rtmp: _rtmp?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'hls';
        _hls?.build();
        _$failedField = 'rtmp';
        _rtmp?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BroadcastSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
