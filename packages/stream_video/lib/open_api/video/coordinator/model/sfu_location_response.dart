//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SFULocationResponse {
  /// Returns a new [SFULocationResponse] instance.
  SFULocationResponse({
    required this.coordinates,
    required this.datacenter,
    required this.id,
    required this.location,
  });

  Coordinates coordinates;

  String datacenter;

  String id;

  Location location;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SFULocationResponse &&
    other.coordinates == coordinates &&
    other.datacenter == datacenter &&
    other.id == id &&
    other.location == location;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (coordinates.hashCode) +
    (datacenter.hashCode) +
    (id.hashCode) +
    (location.hashCode);

  @override
  String toString() => 'SFULocationResponse[coordinates=$coordinates, datacenter=$datacenter, id=$id, location=$location]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'coordinates'] = this.coordinates;
      json[r'datacenter'] = this.datacenter;
      json[r'id'] = this.id;
      json[r'location'] = this.location;
    return json;
  }

  /// Returns a new [SFULocationResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SFULocationResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SFULocationResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SFULocationResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SFULocationResponse(
        coordinates: Coordinates.fromJson(json[r'coordinates'])!,
        datacenter: mapValueOfType<String>(json, r'datacenter')!,
        id: mapValueOfType<String>(json, r'id')!,
        location: Location.fromJson(json[r'location'])!,
      );
    }
    return null;
  }

  static List<SFULocationResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SFULocationResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SFULocationResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SFULocationResponse> mapFromJson(dynamic json) {
    final map = <String, SFULocationResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SFULocationResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SFULocationResponse-objects as value to a dart map
  static Map<String, List<SFULocationResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SFULocationResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SFULocationResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'coordinates',
    'datacenter',
    'id',
    'location',
  };
}

