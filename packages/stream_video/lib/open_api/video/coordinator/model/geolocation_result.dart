//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GeolocationResult {
  /// Returns a new [GeolocationResult] instance.
  GeolocationResult({
    required this.accuracyRadius,
    required this.city,
    required this.continent,
    required this.continentCode,
    required this.country,
    required this.countryIsoCode,
    required this.latitude,
    required this.longitude,
    required this.subdivision,
    required this.subdivisionIsoCode,
  });

  int accuracyRadius;

  String city;

  String continent;

  String continentCode;

  String country;

  String countryIsoCode;

  double latitude;

  double longitude;

  String subdivision;

  String subdivisionIsoCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GeolocationResult &&
    other.accuracyRadius == accuracyRadius &&
    other.city == city &&
    other.continent == continent &&
    other.continentCode == continentCode &&
    other.country == country &&
    other.countryIsoCode == countryIsoCode &&
    other.latitude == latitude &&
    other.longitude == longitude &&
    other.subdivision == subdivision &&
    other.subdivisionIsoCode == subdivisionIsoCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accuracyRadius.hashCode) +
    (city.hashCode) +
    (continent.hashCode) +
    (continentCode.hashCode) +
    (country.hashCode) +
    (countryIsoCode.hashCode) +
    (latitude.hashCode) +
    (longitude.hashCode) +
    (subdivision.hashCode) +
    (subdivisionIsoCode.hashCode);

  @override
  String toString() => 'GeolocationResult[accuracyRadius=$accuracyRadius, city=$city, continent=$continent, continentCode=$continentCode, country=$country, countryIsoCode=$countryIsoCode, latitude=$latitude, longitude=$longitude, subdivision=$subdivision, subdivisionIsoCode=$subdivisionIsoCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'accuracy_radius'] = this.accuracyRadius;
      json[r'city'] = this.city;
      json[r'continent'] = this.continent;
      json[r'continent_code'] = this.continentCode;
      json[r'country'] = this.country;
      json[r'country_iso_code'] = this.countryIsoCode;
      json[r'latitude'] = this.latitude;
      json[r'longitude'] = this.longitude;
      json[r'subdivision'] = this.subdivision;
      json[r'subdivision_iso_code'] = this.subdivisionIsoCode;
    return json;
  }

  /// Returns a new [GeolocationResult] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GeolocationResult? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GeolocationResult[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GeolocationResult[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GeolocationResult(
        accuracyRadius: mapValueOfType<int>(json, r'accuracy_radius')!,
        city: mapValueOfType<String>(json, r'city')!,
        continent: mapValueOfType<String>(json, r'continent')!,
        continentCode: mapValueOfType<String>(json, r'continent_code')!,
        country: mapValueOfType<String>(json, r'country')!,
        countryIsoCode: mapValueOfType<String>(json, r'country_iso_code')!,
        latitude: mapValueOfType<double>(json, r'latitude')!,
        longitude: mapValueOfType<double>(json, r'longitude')!,
        subdivision: mapValueOfType<String>(json, r'subdivision')!,
        subdivisionIsoCode: mapValueOfType<String>(json, r'subdivision_iso_code')!,
      );
    }
    return null;
  }

  static List<GeolocationResult> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GeolocationResult>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GeolocationResult.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GeolocationResult> mapFromJson(dynamic json) {
    final map = <String, GeolocationResult>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GeolocationResult.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GeolocationResult-objects as value to a dart map
  static Map<String, List<GeolocationResult>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GeolocationResult>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GeolocationResult.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'accuracy_radius',
    'city',
    'continent',
    'continent_code',
    'country',
    'country_iso_code',
    'latitude',
    'longitude',
    'subdivision',
    'subdivision_iso_code',
  };
}

