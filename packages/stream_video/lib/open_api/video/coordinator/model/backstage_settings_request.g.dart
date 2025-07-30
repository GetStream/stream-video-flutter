// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backstage_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BackstageSettingsRequest extends BackstageSettingsRequest {
  @override
  final bool? enabled;
  @override
  final int? joinAheadTimeSeconds;

  factory _$BackstageSettingsRequest(
          [void Function(BackstageSettingsRequestBuilder)? updates]) =>
      (BackstageSettingsRequestBuilder()..update(updates))._build();

  _$BackstageSettingsRequest._({this.enabled, this.joinAheadTimeSeconds})
      : super._();
  @override
  BackstageSettingsRequest rebuild(
          void Function(BackstageSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BackstageSettingsRequestBuilder toBuilder() =>
      BackstageSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BackstageSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'BackstageSettingsRequest')
          ..add('enabled', enabled)
          ..add('joinAheadTimeSeconds', joinAheadTimeSeconds))
        .toString();
  }
}

class BackstageSettingsRequestBuilder
    implements
        Builder<BackstageSettingsRequest, BackstageSettingsRequestBuilder> {
  _$BackstageSettingsRequest? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  int? _joinAheadTimeSeconds;
  int? get joinAheadTimeSeconds => _$this._joinAheadTimeSeconds;
  set joinAheadTimeSeconds(int? joinAheadTimeSeconds) =>
      _$this._joinAheadTimeSeconds = joinAheadTimeSeconds;

  BackstageSettingsRequestBuilder() {
    BackstageSettingsRequest._defaults(this);
  }

  BackstageSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _joinAheadTimeSeconds = $v.joinAheadTimeSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BackstageSettingsRequest other) {
    _$v = other as _$BackstageSettingsRequest;
  }

  @override
  void update(void Function(BackstageSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BackstageSettingsRequest build() => _build();

  _$BackstageSettingsRequest _build() {
    final _$result = _$v ??
        _$BackstageSettingsRequest._(
          enabled: enabled,
          joinAheadTimeSeconds: joinAheadTimeSeconds,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
