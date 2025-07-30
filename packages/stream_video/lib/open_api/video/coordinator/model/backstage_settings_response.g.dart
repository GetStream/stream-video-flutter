// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backstage_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackstageSettingsResponse extends BackstageSettingsResponse {
  @override
  final bool enabled;
  @override
  final int? joinAheadTimeSeconds;

  factory _$BackstageSettingsResponse(
          [void Function(BackstageSettingsResponseBuilder)? updates]) =>
      (BackstageSettingsResponseBuilder()..update(updates))._build();

  _$BackstageSettingsResponse._(
      {required this.enabled, this.joinAheadTimeSeconds})
      : super._();
  @override
  BackstageSettingsResponse rebuild(
          void Function(BackstageSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackstageSettingsResponseBuilder toBuilder() =>
      BackstageSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackstageSettingsResponse &&
        enabled == other.enabled &&
        joinAheadTimeSeconds == other.joinAheadTimeSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, joinAheadTimeSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BackstageSettingsResponse')
          ..add('enabled', enabled)
          ..add('joinAheadTimeSeconds', joinAheadTimeSeconds))
        .toString();
  }
}

class BackstageSettingsResponseBuilder
    implements
        Builder<BackstageSettingsResponse, BackstageSettingsResponseBuilder> {
  _$BackstageSettingsResponse? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _joinAheadTimeSeconds;
  int? get joinAheadTimeSeconds => _$this._joinAheadTimeSeconds;
  set joinAheadTimeSeconds(int? joinAheadTimeSeconds) =>
      _$this._joinAheadTimeSeconds = joinAheadTimeSeconds;

  BackstageSettingsResponseBuilder() {
    BackstageSettingsResponse._defaults(this);
  }

  BackstageSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _joinAheadTimeSeconds = $v.joinAheadTimeSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackstageSettingsResponse other) {
    _$v = other as _$BackstageSettingsResponse;
  }

  @override
  void update(void Function(BackstageSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackstageSettingsResponse build() => _build();

  _$BackstageSettingsResponse _build() {
    final _$result = _$v ??
        _$BackstageSettingsResponse._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'BackstageSettingsResponse', 'enabled'),
          joinAheadTimeSeconds: joinAheadTimeSeconds,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
