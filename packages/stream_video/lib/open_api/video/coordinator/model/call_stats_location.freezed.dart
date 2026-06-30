// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsLocation {
  int? get accuracyRadiusMeters;
  String? get city;
  String? get continent;
  String? get country;
  String? get countryIsoCode;
  double? get latitude;
  double? get longitude;
  String? get subdivision;

  /// Create a copy of CallStatsLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsLocationCopyWith<CallStatsLocation> get copyWith =>
      _$CallStatsLocationCopyWithImpl<CallStatsLocation>(
        this as CallStatsLocation,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsLocation &&
            (identical(other.accuracyRadiusMeters, accuracyRadiusMeters) ||
                other.accuracyRadiusMeters == accuracyRadiusMeters) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.continent, continent) ||
                other.continent == continent) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.countryIsoCode, countryIsoCode) ||
                other.countryIsoCode == countryIsoCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.subdivision, subdivision) ||
                other.subdivision == subdivision));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accuracyRadiusMeters,
    city,
    continent,
    country,
    countryIsoCode,
    latitude,
    longitude,
    subdivision,
  );

  @override
  String toString() {
    return 'CallStatsLocation(accuracyRadiusMeters: $accuracyRadiusMeters, city: $city, continent: $continent, country: $country, countryIsoCode: $countryIsoCode, latitude: $latitude, longitude: $longitude, subdivision: $subdivision)';
  }
}

/// @nodoc
abstract mixin class $CallStatsLocationCopyWith<$Res> {
  factory $CallStatsLocationCopyWith(
    CallStatsLocation value,
    $Res Function(CallStatsLocation) _then,
  ) = _$CallStatsLocationCopyWithImpl;
  @useResult
  $Res call({
    int? accuracyRadiusMeters,
    String? city,
    String? continent,
    String? country,
    String? countryIsoCode,
    double? latitude,
    double? longitude,
    String? subdivision,
  });
}

/// @nodoc
class _$CallStatsLocationCopyWithImpl<$Res>
    implements $CallStatsLocationCopyWith<$Res> {
  _$CallStatsLocationCopyWithImpl(this._self, this._then);

  final CallStatsLocation _self;
  final $Res Function(CallStatsLocation) _then;

  /// Create a copy of CallStatsLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accuracyRadiusMeters = freezed,
    Object? city = freezed,
    Object? continent = freezed,
    Object? country = freezed,
    Object? countryIsoCode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? subdivision = freezed,
  }) {
    return _then(
      CallStatsLocation(
        accuracyRadiusMeters: freezed == accuracyRadiusMeters
            ? _self.accuracyRadiusMeters
            : accuracyRadiusMeters // ignore: cast_nullable_to_non_nullable
                  as int?,
        city: freezed == city
            ? _self.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        continent: freezed == continent
            ? _self.continent
            : continent // ignore: cast_nullable_to_non_nullable
                  as String?,
        country: freezed == country
            ? _self.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryIsoCode: freezed == countryIsoCode
            ? _self.countryIsoCode
            : countryIsoCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: freezed == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        subdivision: freezed == subdivision
            ? _self.subdivision
            : subdivision // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
