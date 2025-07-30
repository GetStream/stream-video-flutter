// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screensharing_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScreensharingSettingsResponse extends ScreensharingSettingsResponse {
  @override
  final bool accessRequestEnabled;
  @override
  final bool enabled;
  @override
  final TargetResolution? targetResolution;

  factory _$ScreensharingSettingsResponse(
          [void Function(ScreensharingSettingsResponseBuilder)? updates]) =>
      (ScreensharingSettingsResponseBuilder()..update(updates))._build();

  _$ScreensharingSettingsResponse._(
      {required this.accessRequestEnabled,
      required this.enabled,
      this.targetResolution})
      : super._();
  @override
  ScreensharingSettingsResponse rebuild(
          void Function(ScreensharingSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreensharingSettingsResponseBuilder toBuilder() =>
      ScreensharingSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreensharingSettingsResponse &&
        accessRequestEnabled == other.accessRequestEnabled &&
        enabled == other.enabled &&
        targetResolution == other.targetResolution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessRequestEnabled.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, targetResolution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScreensharingSettingsResponse')
          ..add('accessRequestEnabled', accessRequestEnabled)
          ..add('enabled', enabled)
          ..add('targetResolution', targetResolution))
        .toString();
  }
}

class ScreensharingSettingsResponseBuilder
    implements
        Builder<ScreensharingSettingsResponse,
            ScreensharingSettingsResponseBuilder> {
  _$ScreensharingSettingsResponse? _$v;

  bool? _accessRequestEnabled;
  bool? get accessRequestEnabled => _$this._accessRequestEnabled;
  set accessRequestEnabled(bool? accessRequestEnabled) =>
      _$this._accessRequestEnabled = accessRequestEnabled;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  TargetResolutionBuilder? _targetResolution;
  TargetResolutionBuilder get targetResolution =>
      _$this._targetResolution ??= TargetResolutionBuilder();
  set targetResolution(TargetResolutionBuilder? targetResolution) =>
      _$this._targetResolution = targetResolution;

  ScreensharingSettingsResponseBuilder() {
    ScreensharingSettingsResponse._defaults(this);
  }

  ScreensharingSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessRequestEnabled = $v.accessRequestEnabled;
      _enabled = $v.enabled;
      _targetResolution = $v.targetResolution?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScreensharingSettingsResponse other) {
    _$v = other as _$ScreensharingSettingsResponse;
  }

  @override
  void update(void Function(ScreensharingSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreensharingSettingsResponse build() => _build();

  _$ScreensharingSettingsResponse _build() {
    _$ScreensharingSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$ScreensharingSettingsResponse._(
            accessRequestEnabled: BuiltValueNullFieldError.checkNotNull(
                accessRequestEnabled,
                r'ScreensharingSettingsResponse',
                'accessRequestEnabled'),
            enabled: BuiltValueNullFieldError.checkNotNull(
                enabled, r'ScreensharingSettingsResponse', 'enabled'),
            targetResolution: _targetResolution?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'targetResolution';
        _targetResolution?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ScreensharingSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
