//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LocationResponse {
  /// Returns a new [LocationResponse] instance.
  LocationResponse({
    required this.continentCode,
    required this.countryIsoCode,
    required this.subdivisionIsoCode,
  });

  /// Continent code
  String continentCode;

  /// Country ISO code
  String countryIsoCode;

  /// Subdivision ISO code
  String subdivisionIsoCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationResponse &&
          other.continentCode == continentCode &&
          other.countryIsoCode == countryIsoCode &&
          other.subdivisionIsoCode == subdivisionIsoCode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (continentCode.hashCode) +
      (countryIsoCode.hashCode) +
      (subdivisionIsoCode.hashCode);

  @override
  String toString() =>
      'LocationResponse[continentCode=$continentCode, countryIsoCode=$countryIsoCode, subdivisionIsoCode=$subdivisionIsoCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'continent_code'] = this.continentCode;
    json[r'country_iso_code'] = this.countryIsoCode;
    json[r'subdivision_iso_code'] = this.subdivisionIsoCode;
    return json;
  }

  /// Returns a new [LocationResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LocationResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'continent_code'),
            'Required key "LocationResponse[continent_code]" is missing from JSON.');
        assert(json[r'continent_code'] != null,
            'Required key "LocationResponse[continent_code]" has a null value in JSON.');
        assert(json.containsKey(r'country_iso_code'),
            'Required key "LocationResponse[country_iso_code]" is missing from JSON.');
        assert(json[r'country_iso_code'] != null,
            'Required key "LocationResponse[country_iso_code]" has a null value in JSON.');
        assert(json.containsKey(r'subdivision_iso_code'),
            'Required key "LocationResponse[subdivision_iso_code]" is missing from JSON.');
        assert(json[r'subdivision_iso_code'] != null,
            'Required key "LocationResponse[subdivision_iso_code]" has a null value in JSON.');
        return true;
      }());

      return LocationResponse(
        continentCode: mapValueOfType<String>(json, r'continent_code')!,
        countryIsoCode: mapValueOfType<String>(json, r'country_iso_code')!,
        subdivisionIsoCode:
            mapValueOfType<String>(json, r'subdivision_iso_code')!,
      );
    }
    return null;
  }

  static List<LocationResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <LocationResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LocationResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LocationResponse> mapFromJson(dynamic json) {
    final map = <String, LocationResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LocationResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LocationResponse-objects as value to a dart map
  static Map<String, List<LocationResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<LocationResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LocationResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'continent_code',
    'country_iso_code',
    'subdivision_iso_code',
  };
}
