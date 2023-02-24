//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DatacenterResponse {
  /// Returns a new [DatacenterResponse] instance.
  DatacenterResponse({
    required this.coordinates,
    required this.latencyUrl,
    required this.name,
  });

  Coordinates coordinates;

  String latencyUrl;

  String name;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DatacenterResponse &&
     other.coordinates == coordinates &&
     other.latencyUrl == latencyUrl &&
     other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coordinates.hashCode) +
    (latencyUrl.hashCode) +
    (name.hashCode);

  @override
  String toString() => 'DatacenterResponse[coordinates=$coordinates, latencyUrl=$latencyUrl, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'coordinates'] = this.coordinates;
      json[r'latency_url'] = this.latencyUrl;
      json[r'name'] = this.name;
    return json;
  }

  /// Returns a new [DatacenterResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DatacenterResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DatacenterResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DatacenterResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DatacenterResponse(
        coordinates: Coordinates.fromJson(json[r'coordinates'])!,
        latencyUrl: mapValueOfType<String>(json, r'latency_url')!,
        name: mapValueOfType<String>(json, r'name')!,
      );
    }
    return null;
  }

  static List<DatacenterResponse>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DatacenterResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DatacenterResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DatacenterResponse> mapFromJson(dynamic json) {
    final map = <String, DatacenterResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DatacenterResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DatacenterResponse-objects as value to a dart map
  static Map<String, List<DatacenterResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DatacenterResponse>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DatacenterResponse.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coordinates',
    'latency_url',
    'name',
  };
}

