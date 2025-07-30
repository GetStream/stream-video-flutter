// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnails_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ThumbnailsSettingsResponse extends ThumbnailsSettingsResponse {
  @override
  final bool enabled;

  factory _$ThumbnailsSettingsResponse(
          [void Function(ThumbnailsSettingsResponseBuilder)? updates]) =>
      (ThumbnailsSettingsResponseBuilder()..update(updates))._build();

  _$ThumbnailsSettingsResponse._({required this.enabled}) : super._();
  @override
  ThumbnailsSettingsResponse rebuild(
          void Function(ThumbnailsSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThumbnailsSettingsResponseBuilder toBuilder() =>
      ThumbnailsSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThumbnailsSettingsResponse && enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ThumbnailsSettingsResponse')
          ..add('enabled', enabled))
        .toString();
  }
}

class ThumbnailsSettingsResponseBuilder
    implements
        Builder<ThumbnailsSettingsResponse, ThumbnailsSettingsResponseBuilder> {
  _$ThumbnailsSettingsResponse? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ThumbnailsSettingsResponseBuilder() {
    ThumbnailsSettingsResponse._defaults(this);
  }

  ThumbnailsSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThumbnailsSettingsResponse other) {
    _$v = other as _$ThumbnailsSettingsResponse;
  }

  @override
  void update(void Function(ThumbnailsSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThumbnailsSettingsResponse build() => _build();

  _$ThumbnailsSettingsResponse _build() {
    final _$result = _$v ??
        _$ThumbnailsSettingsResponse._(
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'ThumbnailsSettingsResponse', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
