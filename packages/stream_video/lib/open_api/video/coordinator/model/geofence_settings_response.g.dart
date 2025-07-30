// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofence_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GeofenceSettingsResponse extends GeofenceSettingsResponse {
  @override
  final BuiltList<String> names;

  factory _$GeofenceSettingsResponse(
          [void Function(GeofenceSettingsResponseBuilder)? updates]) =>
      (GeofenceSettingsResponseBuilder()..update(updates))._build();

  _$GeofenceSettingsResponse._({required this.names}) : super._();
  @override
  GeofenceSettingsResponse rebuild(
          void Function(GeofenceSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GeofenceSettingsResponseBuilder toBuilder() =>
      GeofenceSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GeofenceSettingsResponse && names == other.names;
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
    return (newBuiltValueToStringHelper(r'GeofenceSettingsResponse')
          ..add('names', names))
        .toString();
  }
}

class GeofenceSettingsResponseBuilder
    implements
        Builder<GeofenceSettingsResponse, GeofenceSettingsResponseBuilder> {
  _$GeofenceSettingsResponse? _$v;

  ListBuilder<String>? _names;
  ListBuilder<String> get names => _$this._names ??= ListBuilder<String>();
  set names(ListBuilder<String>? names) => _$this._names = names;

  GeofenceSettingsResponseBuilder() {
    GeofenceSettingsResponse._defaults(this);
  }

  GeofenceSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _names = $v.names.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GeofenceSettingsResponse other) {
    _$v = other as _$GeofenceSettingsResponse;
  }

  @override
  void update(void Function(GeofenceSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GeofenceSettingsResponse build() => _build();

  _$GeofenceSettingsResponse _build() {
    _$GeofenceSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$GeofenceSettingsResponse._(
            names: names.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'names';
        names.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GeofenceSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
