//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetCallEdgeServerRequest {
  /// Returns a new [GetCallEdgeServerRequest] instance.
  GetCallEdgeServerRequest({
    this.latencyMeasurements = const {},
  });

  Map<String, List<double>> latencyMeasurements;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCallEdgeServerRequest &&
     other.latencyMeasurements == latencyMeasurements;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (latencyMeasurements.hashCode);

  @override
  String toString() => 'GetCallEdgeServerRequest[latencyMeasurements=$latencyMeasurements]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'latency_measurements'] = this.latencyMeasurements;
    return json;
  }

  /// Returns a new [GetCallEdgeServerRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCallEdgeServerRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetCallEdgeServerRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetCallEdgeServerRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetCallEdgeServerRequest(
        latencyMeasurements: json[r'latency_measurements'] == null
          ? const {}
            : mapCastOfType<String, List<double>>(json, r'latency_measurements') ?? const {},
      );
    }
    return null;
  }

  static List<GetCallEdgeServerRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCallEdgeServerRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCallEdgeServerRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCallEdgeServerRequest> mapFromJson(dynamic json) {
    final map = <String, GetCallEdgeServerRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCallEdgeServerRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCallEdgeServerRequest-objects as value to a dart map
  static Map<String, List<GetCallEdgeServerRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCallEdgeServerRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCallEdgeServerRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'latency_measurements',
  };
}

