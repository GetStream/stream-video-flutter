//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoordinatesResponse {
  /// Returns a new [CoordinatesResponse] instance.
  CoordinatesResponse({
    required this.latitude,
    required this.longitude,
  });

  /// Latitude coordinate
  double latitude;

  /// Longitude coordinate
  double longitude;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoordinatesResponse &&
          other.latitude == latitude &&
          other.longitude == longitude;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (latitude.hashCode) + (longitude.hashCode);

  @override
  String toString() =>
      'CoordinatesResponse[latitude=$latitude, longitude=$longitude]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'latitude'] = this.latitude;
    json[r'longitude'] = this.longitude;
    return json;
  }

  /// Returns a new [CoordinatesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoordinatesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'latitude'),
            'Required key "CoordinatesResponse[latitude]" is missing from JSON.');
        assert(json[r'latitude'] != null,
            'Required key "CoordinatesResponse[latitude]" has a null value in JSON.');
        assert(json.containsKey(r'longitude'),
            'Required key "CoordinatesResponse[longitude]" is missing from JSON.');
        assert(json[r'longitude'] != null,
            'Required key "CoordinatesResponse[longitude]" has a null value in JSON.');
        return true;
      }());

      return CoordinatesResponse(
        latitude: mapValueOfType<double>(json, r'latitude')!,
        longitude: mapValueOfType<double>(json, r'longitude')!,
      );
    }
    return null;
  }

  static List<CoordinatesResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CoordinatesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoordinatesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoordinatesResponse> mapFromJson(dynamic json) {
    final map = <String, CoordinatesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoordinatesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoordinatesResponse-objects as value to a dart map
  static Map<String, List<CoordinatesResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CoordinatesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoordinatesResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'latitude',
    'longitude',
  };
}
