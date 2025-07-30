// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screensharing_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScreensharingSettingsRequest extends ScreensharingSettingsRequest {
  @override
  final bool? accessRequestEnabled;
  @override
  final bool? enabled;
  @override
  final TargetResolution? targetResolution;

  factory _$ScreensharingSettingsRequest(
          [void Function(ScreensharingSettingsRequestBuilder)? updates]) =>
      (ScreensharingSettingsRequestBuilder()..update(updates))._build();

  _$ScreensharingSettingsRequest._(
      {this.accessRequestEnabled, this.enabled, this.targetResolution})
      : super._();
  @override
  ScreensharingSettingsRequest rebuild(
          void Function(ScreensharingSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreensharingSettingsRequestBuilder toBuilder() =>
      ScreensharingSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreensharingSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'ScreensharingSettingsRequest')
          ..add('accessRequestEnabled', accessRequestEnabled)
          ..add('enabled', enabled)
          ..add('targetResolution', targetResolution))
        .toString();
  }
}

class ScreensharingSettingsRequestBuilder
    implements
        Builder<ScreensharingSettingsRequest,
            ScreensharingSettingsRequestBuilder> {
  _$ScreensharingSettingsRequest? _$v;

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

  ScreensharingSettingsRequestBuilder() {
    ScreensharingSettingsRequest._defaults(this);
  }

  ScreensharingSettingsRequestBuilder get _$this {
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
  void replace(ScreensharingSettingsRequest other) {
    _$v = other as _$ScreensharingSettingsRequest;
  }

  @override
  void update(void Function(ScreensharingSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreensharingSettingsRequest build() => _build();

  _$ScreensharingSettingsRequest _build() {
    _$ScreensharingSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$ScreensharingSettingsRequest._(
            accessRequestEnabled: accessRequestEnabled,
            enabled: enabled,
            targetResolution: _targetResolution?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'targetResolution';
        _targetResolution?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ScreensharingSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
