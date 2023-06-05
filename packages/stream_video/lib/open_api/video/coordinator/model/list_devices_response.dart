//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListDevicesResponse {
  /// Returns a new [ListDevicesResponse] instance.
  ListDevicesResponse({
    this.devices = const [],
    required this.duration,
  });

  /// List of devices
  List<Device> devices;

  String duration;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListDevicesResponse &&
     other.devices == devices &&
     other.duration == duration;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (devices.hashCode) +
    (duration.hashCode);

  @override
  String toString() => 'ListDevicesResponse[devices=$devices, duration=$duration]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'devices'] = this.devices;
      json[r'duration'] = this.duration;
    return json;
  }

  /// Returns a new [ListDevicesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListDevicesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ListDevicesResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ListDevicesResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ListDevicesResponse(
        devices: Device.listFromJson(json[r'devices']),
        duration: mapValueOfType<String>(json, r'duration')!,
      );
    }
    return null;
  }

  static List<ListDevicesResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListDevicesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListDevicesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListDevicesResponse> mapFromJson(dynamic json) {
    final map = <String, ListDevicesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListDevicesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListDevicesResponse-objects as value to a dart map
  static Map<String, List<ListDevicesResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListDevicesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListDevicesResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'devices',
    'duration',
  };
}

