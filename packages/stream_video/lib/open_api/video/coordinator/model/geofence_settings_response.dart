//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GeofenceSettingsResponse {
  /// Returns a new [GeofenceSettingsResponse] instance.
  GeofenceSettingsResponse({
    this.names = const [],
  });

  List<String> names;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GeofenceSettingsResponse &&
    _deepEquality.equals(other.names, names);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (names.hashCode);

  @override
  String toString() => 'GeofenceSettingsResponse[names=$names]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'names'] = this.names;
    return json;
  }

  /// Returns a new [GeofenceSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GeofenceSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GeofenceSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GeofenceSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GeofenceSettingsResponse(
        names: json[r'names'] is Iterable
            ? (json[r'names'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<GeofenceSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GeofenceSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GeofenceSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GeofenceSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, GeofenceSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GeofenceSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GeofenceSettingsResponse-objects as value to a dart map
  static Map<String, List<GeofenceSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GeofenceSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GeofenceSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'names',
  };
}

