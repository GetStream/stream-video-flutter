//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ScreensharingSettings {
  /// Returns a new [ScreensharingSettings] instance.
  ScreensharingSettings({
    required this.accessRequestEnabled,
    required this.enabled,
  });

  bool accessRequestEnabled;

  bool enabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ScreensharingSettings &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.enabled == enabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (enabled.hashCode);

  @override
  String toString() => 'ScreensharingSettings[accessRequestEnabled=$accessRequestEnabled, enabled=$enabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'enabled'] = this.enabled;
    return json;
  }

  /// Returns a new [ScreensharingSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ScreensharingSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ScreensharingSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ScreensharingSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ScreensharingSettings(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
      );
    }
    return null;
  }

  static List<ScreensharingSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ScreensharingSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ScreensharingSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ScreensharingSettings> mapFromJson(dynamic json) {
    final map = <String, ScreensharingSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ScreensharingSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ScreensharingSettings-objects as value to a dart map
  static Map<String, List<ScreensharingSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ScreensharingSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ScreensharingSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_request_enabled',
    'enabled',
  };
}

