//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EdgeResponse {
  /// Returns a new [EdgeResponse] instance.
  EdgeResponse({
    required this.continentCode,
    required this.countryIsoCode,
    required this.green,
    required this.id,
    required this.latencyTestUrl,
    required this.latitude,
    required this.longitude,
    required this.red,
    required this.subdivisionIsoCode,
    required this.yellow,
  });

  String continentCode;

  String countryIsoCode;

  int green;

  String id;

  String latencyTestUrl;

  double latitude;

  double longitude;

  int red;

  String subdivisionIsoCode;

  int yellow;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EdgeResponse &&
     other.continentCode == continentCode &&
     other.countryIsoCode == countryIsoCode &&
     other.green == green &&
     other.id == id &&
     other.latencyTestUrl == latencyTestUrl &&
     other.latitude == latitude &&
     other.longitude == longitude &&
     other.red == red &&
     other.subdivisionIsoCode == subdivisionIsoCode &&
     other.yellow == yellow;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (continentCode.hashCode) +
    (countryIsoCode.hashCode) +
    (green.hashCode) +
    (id.hashCode) +
    (latencyTestUrl.hashCode) +
    (latitude.hashCode) +
    (longitude.hashCode) +
    (red.hashCode) +
    (subdivisionIsoCode.hashCode) +
    (yellow.hashCode);

  @override
  String toString() => 'EdgeResponse[continentCode=$continentCode, countryIsoCode=$countryIsoCode, green=$green, id=$id, latencyTestUrl=$latencyTestUrl, latitude=$latitude, longitude=$longitude, red=$red, subdivisionIsoCode=$subdivisionIsoCode, yellow=$yellow]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'continent_code'] = this.continentCode;
      json[r'country_iso_code'] = this.countryIsoCode;
      json[r'green'] = this.green;
      json[r'id'] = this.id;
      json[r'latency_test_url'] = this.latencyTestUrl;
      json[r'latitude'] = this.latitude;
      json[r'longitude'] = this.longitude;
      json[r'red'] = this.red;
      json[r'subdivision_iso_code'] = this.subdivisionIsoCode;
      json[r'yellow'] = this.yellow;
    return json;
  }

  /// Returns a new [EdgeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EdgeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EdgeResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EdgeResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EdgeResponse(
        continentCode: mapValueOfType<String>(json, r'continent_code')!,
        countryIsoCode: mapValueOfType<String>(json, r'country_iso_code')!,
        green: mapValueOfType<int>(json, r'green')!,
        id: mapValueOfType<String>(json, r'id')!,
        latencyTestUrl: mapValueOfType<String>(json, r'latency_test_url')!,
        latitude: mapValueOfType<double>(json, r'latitude')!,
        longitude: mapValueOfType<double>(json, r'longitude')!,
        red: mapValueOfType<int>(json, r'red')!,
        subdivisionIsoCode: mapValueOfType<String>(json, r'subdivision_iso_code')!,
        yellow: mapValueOfType<int>(json, r'yellow')!,
      );
    }
    return null;
  }

  static List<EdgeResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EdgeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EdgeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EdgeResponse> mapFromJson(dynamic json) {
    final map = <String, EdgeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EdgeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EdgeResponse-objects as value to a dart map
  static Map<String, List<EdgeResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EdgeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EdgeResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'continent_code',
    'country_iso_code',
    'green',
    'id',
    'latency_test_url',
    'latitude',
    'longitude',
    'red',
    'subdivision_iso_code',
    'yellow',
  };
}

