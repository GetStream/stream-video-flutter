// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HLSSettingsResponse extends HLSSettingsResponse {
  @override
  final bool autoOn;
  @override
  final bool enabled;
  @override
  final BuiltList<String> qualityTracks;

  factory _$HLSSettingsResponse(
          [void Function(HLSSettingsResponseBuilder)? updates]) =>
      (HLSSettingsResponseBuilder()..update(updates))._build();

  _$HLSSettingsResponse._(
      {required this.autoOn,
      required this.enabled,
      required this.qualityTracks})
      : super._();
  @override
  HLSSettingsResponse rebuild(
          void Function(HLSSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HLSSettingsResponseBuilder toBuilder() =>
      HLSSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HLSSettingsResponse &&
        autoOn == other.autoOn &&
        enabled == other.enabled &&
        qualityTracks == other.qualityTracks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoOn.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, qualityTracks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HLSSettingsResponse')
          ..add('autoOn', autoOn)
          ..add('enabled', enabled)
          ..add('qualityTracks', qualityTracks))
        .toString();
  }
}

class HLSSettingsResponseBuilder
    implements Builder<HLSSettingsResponse, HLSSettingsResponseBuilder> {
  _$HLSSettingsResponse? _$v;

  bool? _autoOn;
  bool? get autoOn => _$this._autoOn;
  set autoOn(bool? autoOn) => _$this._autoOn = autoOn;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ListBuilder<String>? _qualityTracks;
  ListBuilder<String> get qualityTracks =>
      _$this._qualityTracks ??= ListBuilder<String>();
  set qualityTracks(ListBuilder<String>? qualityTracks) =>
      _$this._qualityTracks = qualityTracks;

  HLSSettingsResponseBuilder() {
    HLSSettingsResponse._defaults(this);
  }

  HLSSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoOn = $v.autoOn;
      _enabled = $v.enabled;
      _qualityTracks = $v.qualityTracks.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HLSSettingsResponse other) {
    _$v = other as _$HLSSettingsResponse;
  }

  @override
  void update(void Function(HLSSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HLSSettingsResponse build() => _build();

  _$HLSSettingsResponse _build() {
    _$HLSSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$HLSSettingsResponse._(
            autoOn: BuiltValueNullFieldError.checkNotNull(
                autoOn, r'HLSSettingsResponse', 'autoOn'),
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'HLSSettingsResponse', 'enabled'),
            qualityTracks: qualityTracks.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'qualityTracks';
        qualityTracks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HLSSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
