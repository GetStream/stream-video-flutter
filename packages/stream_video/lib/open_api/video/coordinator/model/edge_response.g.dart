// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EdgeResponse extends EdgeResponse {
  @override
  final String continentCode;
  @override
  final String countryIsoCode;
  @override
  final int green;
  @override
  final String id;
  @override
  final String latencyTestUrl;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int red;
  @override
  final String subdivisionIsoCode;
  @override
  final int yellow;

  factory _$EdgeResponse([void Function(EdgeResponseBuilder)? updates]) =>
      (EdgeResponseBuilder()..update(updates))._build();

  _$EdgeResponse._(
      {required this.continentCode,
      required this.countryIsoCode,
      required this.green,
      required this.id,
      required this.latencyTestUrl,
      required this.latitude,
      required this.longitude,
      required this.red,
      required this.subdivisionIsoCode,
      required this.yellow})
      : super._();
  @override
  EdgeResponse rebuild(void Function(EdgeResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EdgeResponseBuilder toBuilder() => EdgeResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EdgeResponse &&
        continentCode == other.continentCode &&
        countryIsoCode == other.countryIsoCode &&
        green == other.green &&
        id == other.id &&
        latencyTestUrl == other.latencyTestUrl &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        red == other.red &&
        subdivisionIsoCode == other.subdivisionIsoCode &&
        yellow == other.yellow;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, continentCode.hashCode);
    _$hash = $jc(_$hash, countryIsoCode.hashCode);
    _$hash = $jc(_$hash, green.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, latencyTestUrl.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, red.hashCode);
    _$hash = $jc(_$hash, subdivisionIsoCode.hashCode);
    _$hash = $jc(_$hash, yellow.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EdgeResponse')
          ..add('continentCode', continentCode)
          ..add('countryIsoCode', countryIsoCode)
          ..add('green', green)
          ..add('id', id)
          ..add('latencyTestUrl', latencyTestUrl)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('red', red)
          ..add('subdivisionIsoCode', subdivisionIsoCode)
          ..add('yellow', yellow))
        .toString();
  }
}

class EdgeResponseBuilder
    implements Builder<EdgeResponse, EdgeResponseBuilder> {
  _$EdgeResponse? _$v;

  String? _continentCode;
  String? get continentCode => _$this._continentCode;
  set continentCode(String? continentCode) =>
      _$this._continentCode = continentCode;

  String? _countryIsoCode;
  String? get countryIsoCode => _$this._countryIsoCode;
  set countryIsoCode(String? countryIsoCode) =>
      _$this._countryIsoCode = countryIsoCode;

  int? _green;
  int? get green => _$this._green;
  set green(int? green) => _$this._green = green;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _latencyTestUrl;
  String? get latencyTestUrl => _$this._latencyTestUrl;
  set latencyTestUrl(String? latencyTestUrl) =>
      _$this._latencyTestUrl = latencyTestUrl;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  int? _red;
  int? get red => _$this._red;
  set red(int? red) => _$this._red = red;

  String? _subdivisionIsoCode;
  String? get subdivisionIsoCode => _$this._subdivisionIsoCode;
  set subdivisionIsoCode(String? subdivisionIsoCode) =>
      _$this._subdivisionIsoCode = subdivisionIsoCode;

  int? _yellow;
  int? get yellow => _$this._yellow;
  set yellow(int? yellow) => _$this._yellow = yellow;

  EdgeResponseBuilder() {
    EdgeResponse._defaults(this);
  }

  EdgeResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _continentCode = $v.continentCode;
      _countryIsoCode = $v.countryIsoCode;
      _green = $v.green;
      _id = $v.id;
      _latencyTestUrl = $v.latencyTestUrl;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _red = $v.red;
      _subdivisionIsoCode = $v.subdivisionIsoCode;
      _yellow = $v.yellow;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EdgeResponse other) {
    _$v = other as _$EdgeResponse;
  }

  @override
  void update(void Function(EdgeResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EdgeResponse build() => _build();

  _$EdgeResponse _build() {
    final _$result = _$v ??
        _$EdgeResponse._(
          continentCode: BuiltValueNullFieldError.checkNotNull(
              continentCode, r'EdgeResponse', 'continentCode'),
          countryIsoCode: BuiltValueNullFieldError.checkNotNull(
              countryIsoCode, r'EdgeResponse', 'countryIsoCode'),
          green: BuiltValueNullFieldError.checkNotNull(
              green, r'EdgeResponse', 'green'),
          id: BuiltValueNullFieldError.checkNotNull(id, r'EdgeResponse', 'id'),
          latencyTestUrl: BuiltValueNullFieldError.checkNotNull(
              latencyTestUrl, r'EdgeResponse', 'latencyTestUrl'),
          latitude: BuiltValueNullFieldError.checkNotNull(
              latitude, r'EdgeResponse', 'latitude'),
          longitude: BuiltValueNullFieldError.checkNotNull(
              longitude, r'EdgeResponse', 'longitude'),
          red: BuiltValueNullFieldError.checkNotNull(
              red, r'EdgeResponse', 'red'),
          subdivisionIsoCode: BuiltValueNullFieldError.checkNotNull(
              subdivisionIsoCode, r'EdgeResponse', 'subdivisionIsoCode'),
          yellow: BuiltValueNullFieldError.checkNotNull(
              yellow, r'EdgeResponse', 'yellow'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
