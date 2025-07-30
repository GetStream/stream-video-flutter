// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RTMPSettingsResponse extends RTMPSettingsResponse {
  @override
  final bool enabled;
  @override
  final String quality;

  factory _$RTMPSettingsResponse(
          [void Function(RTMPSettingsResponseBuilder)? updates]) =>
      (RTMPSettingsResponseBuilder()..update(updates))._build();

  _$RTMPSettingsResponse._({required this.enabled, required this.quality})
      : super._();
  @override
  RTMPSettingsResponse rebuild(
          void Function(RTMPSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RTMPSettingsResponseBuilder toBuilder() =>
      RTMPSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RTMPSettingsResponse &&
        enabled == other.enabled &&
        quality == other.quality;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RTMPSettingsResponse')
          ..add('enabled', enabled)
          ..add('quality', quality))
        .toString();
  }
}

class RTMPSettingsResponseBuilder
    implements Builder<RTMPSettingsResponse, RTMPSettingsResponseBuilder> {
  _$RTMPSettingsResponse? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _quality;
  String? get quality => _$this._quality;
  set quality(String? quality) => _$this._quality = quality;

  RTMPSettingsResponseBuilder() {
    RTMPSettingsResponse._defaults(this);
  }

  RTMPSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _quality = $v.quality;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RTMPSettingsResponse other) {
    _$v = other as _$RTMPSettingsResponse;
  }

  @override
  void update(void Function(RTMPSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RTMPSettingsResponse build() => _build();

  _$RTMPSettingsResponse _build() {
    final _$result = _$v ??
        _$RTMPSettingsResponse._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'RTMPSettingsResponse', 'enabled'),
          quality: BuiltValueNullFieldError.checkNotNull(
              quality, r'RTMPSettingsResponse', 'quality'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
