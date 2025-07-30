// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeofenceSettingsRequest extends GeofenceSettingsRequest {
  @override
  final BuiltList<String>? names;

  factory _$GeofenceSettingsRequest(
          [void Function(GeofenceSettingsRequestBuilder)? updates]) =>
      (GeofenceSettingsRequestBuilder()..update(updates))._build();

  _$GeofenceSettingsRequest._({this.names}) : super._();
  @override
  GeofenceSettingsRequest rebuild(
          void Function(GeofenceSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeofenceSettingsRequestBuilder toBuilder() =>
      GeofenceSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeofenceSettingsRequest && names == other.names;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, names.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GeofenceSettingsRequest')
          ..add('names', names))
        .toString();
  }
}

class GeofenceSettingsRequestBuilder
    implements
        Builder<GeofenceSettingsRequest, GeofenceSettingsRequestBuilder> {
  _$GeofenceSettingsRequest? _$v;

  ListBuilder<String>? _names;
  ListBuilder<String> get names => _$this._names ??= ListBuilder<String>();
  set names(ListBuilder<String>? names) => _$this._names = names;

  GeofenceSettingsRequestBuilder() {
    GeofenceSettingsRequest._defaults(this);
  }

  GeofenceSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _names = $v.names?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeofenceSettingsRequest other) {
    _$v = other as _$GeofenceSettingsRequest;
  }

  @override
  void update(void Function(GeofenceSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeofenceSettingsRequest build() => _build();

  _$GeofenceSettingsRequest _build() {
    _$GeofenceSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$GeofenceSettingsRequest._(
            names: _names?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'names';
        _names?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeofenceSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
