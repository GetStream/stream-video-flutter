// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EdgeResponse {
  String get continentCode;
  String get countryIsoCode;
  int get green;
  String get id;
  String get latencyTestUrl;
  double get latitude;
  double get longitude;
  int get red;
  String get subdivisionIsoCode;
  int get yellow;

  /// Create a copy of EdgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EdgeResponseCopyWith<EdgeResponse> get copyWith =>
      _$EdgeResponseCopyWithImpl<EdgeResponse>(
        this as EdgeResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EdgeResponse &&
            (identical(other.continentCode, continentCode) ||
                other.continentCode == continentCode) &&
            (identical(other.countryIsoCode, countryIsoCode) ||
                other.countryIsoCode == countryIsoCode) &&
            (identical(other.green, green) || other.green == green) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.latencyTestUrl, latencyTestUrl) ||
                other.latencyTestUrl == latencyTestUrl) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.red, red) || other.red == red) &&
            (identical(other.subdivisionIsoCode, subdivisionIsoCode) ||
                other.subdivisionIsoCode == subdivisionIsoCode) &&
            (identical(other.yellow, yellow) || other.yellow == yellow));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    continentCode,
    countryIsoCode,
    green,
    id,
    latencyTestUrl,
    latitude,
    longitude,
    red,
    subdivisionIsoCode,
    yellow,
  );

  @override
  String toString() {
    return 'EdgeResponse(continentCode: $continentCode, countryIsoCode: $countryIsoCode, green: $green, id: $id, latencyTestUrl: $latencyTestUrl, latitude: $latitude, longitude: $longitude, red: $red, subdivisionIsoCode: $subdivisionIsoCode, yellow: $yellow)';
  }
}

/// @nodoc
abstract mixin class $EdgeResponseCopyWith<$Res> {
  factory $EdgeResponseCopyWith(
    EdgeResponse value,
    $Res Function(EdgeResponse) _then,
  ) = _$EdgeResponseCopyWithImpl;
  @useResult
  $Res call({
    String continentCode,
    String countryIsoCode,
    int green,
    String id,
    String latencyTestUrl,
    double latitude,
    double longitude,
    int red,
    String subdivisionIsoCode,
    int yellow,
  });
}

/// @nodoc
class _$EdgeResponseCopyWithImpl<$Res> implements $EdgeResponseCopyWith<$Res> {
  _$EdgeResponseCopyWithImpl(this._self, this._then);

  final EdgeResponse _self;
  final $Res Function(EdgeResponse) _then;

  /// Create a copy of EdgeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? continentCode = null,
    Object? countryIsoCode = null,
    Object? green = null,
    Object? id = null,
    Object? latencyTestUrl = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? red = null,
    Object? subdivisionIsoCode = null,
    Object? yellow = null,
  }) {
    return _then(
      EdgeResponse(
        continentCode: null == continentCode
            ? _self.continentCode
            : continentCode // ignore: cast_nullable_to_non_nullable
                  as String,
        countryIsoCode: null == countryIsoCode
            ? _self.countryIsoCode
            : countryIsoCode // ignore: cast_nullable_to_non_nullable
                  as String,
        green: null == green
            ? _self.green
            : green // ignore: cast_nullable_to_non_nullable
                  as int,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        latencyTestUrl: null == latencyTestUrl
            ? _self.latencyTestUrl
            : latencyTestUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        red: null == red
            ? _self.red
            : red // ignore: cast_nullable_to_non_nullable
                  as int,
        subdivisionIsoCode: null == subdivisionIsoCode
            ? _self.subdivisionIsoCode
            : subdivisionIsoCode // ignore: cast_nullable_to_non_nullable
                  as String,
        yellow: null == yellow
            ? _self.yellow
            : yellow // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
