// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thumbnails_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ThumbnailsSettingsRequest extends ThumbnailsSettingsRequest {
  @override
  final bool? enabled;

  factory _$ThumbnailsSettingsRequest(
          [void Function(ThumbnailsSettingsRequestBuilder)? updates]) =>
      (ThumbnailsSettingsRequestBuilder()..update(updates))._build();

  _$ThumbnailsSettingsRequest._({this.enabled}) : super._();
  @override
  ThumbnailsSettingsRequest rebuild(
          void Function(ThumbnailsSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThumbnailsSettingsRequestBuilder toBuilder() =>
      ThumbnailsSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThumbnailsSettingsRequest && enabled == other.enabled;
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
    return (newBuiltValueToStringHelper(r'ThumbnailsSettingsRequest')
          ..add('enabled', enabled))
        .toString();
  }
}

class ThumbnailsSettingsRequestBuilder
    implements
        Builder<ThumbnailsSettingsRequest, ThumbnailsSettingsRequestBuilder> {
  _$ThumbnailsSettingsRequest? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ThumbnailsSettingsRequestBuilder() {
    ThumbnailsSettingsRequest._defaults(this);
  }

  ThumbnailsSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThumbnailsSettingsRequest other) {
    _$v = other as _$ThumbnailsSettingsRequest;
  }

  @override
  void update(void Function(ThumbnailsSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ThumbnailsSettingsRequest build() => _build();

  _$ThumbnailsSettingsRequest _build() {
    final _$result = _$v ??
        _$ThumbnailsSettingsRequest._(
          enabled: enabled,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
