// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hls_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HLSSettingsRequest extends HLSSettingsRequest {
  @override
  final bool? autoOn;
  @override
  final bool? enabled;
  @override
  final BuiltList<String> qualityTracks;

  factory _$HLSSettingsRequest(
          [void Function(HLSSettingsRequestBuilder)? updates]) =>
      (HLSSettingsRequestBuilder()..update(updates))._build();

  _$HLSSettingsRequest._(
      {this.autoOn, this.enabled, required this.qualityTracks})
      : super._();
  @override
  HLSSettingsRequest rebuild(
          void Function(HLSSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HLSSettingsRequestBuilder toBuilder() =>
      HLSSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HLSSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'HLSSettingsRequest')
          ..add('autoOn', autoOn)
          ..add('enabled', enabled)
          ..add('qualityTracks', qualityTracks))
        .toString();
  }
}

class HLSSettingsRequestBuilder
    implements Builder<HLSSettingsRequest, HLSSettingsRequestBuilder> {
  _$HLSSettingsRequest? _$v;

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

  HLSSettingsRequestBuilder() {
    HLSSettingsRequest._defaults(this);
  }

  HLSSettingsRequestBuilder get _$this {
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
  void replace(HLSSettingsRequest other) {
    _$v = other as _$HLSSettingsRequest;
  }

  @override
  void update(void Function(HLSSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HLSSettingsRequest build() => _build();

  _$HLSSettingsRequest _build() {
    _$HLSSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$HLSSettingsRequest._(
            autoOn: autoOn,
            enabled: enabled,
            qualityTracks: qualityTracks.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'qualityTracks';
        qualityTracks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HLSSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
