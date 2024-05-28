//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ScreensharingSettingsResponse {
  /// Returns a new [ScreensharingSettingsResponse] instance.
  ScreensharingSettingsResponse({
    required this.accessRequestEnabled,
    required this.enabled,
    this.targetResolution,
  });

  bool accessRequestEnabled;

  bool enabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TargetResolution? targetResolution;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ScreensharingSettingsResponse &&
    other.accessRequestEnabled == accessRequestEnabled &&
    other.enabled == enabled &&
    other.targetResolution == targetResolution;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (enabled.hashCode) +
    (targetResolution == null ? 0 : targetResolution!.hashCode);

  @override
  String toString() => 'ScreensharingSettingsResponse[accessRequestEnabled=$accessRequestEnabled, enabled=$enabled, targetResolution=$targetResolution]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'enabled'] = this.enabled;
    if (this.targetResolution != null) {
      json[r'target_resolution'] = this.targetResolution;
    } else {
      json[r'target_resolution'] = null;
    }
    return json;
  }

  /// Returns a new [ScreensharingSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ScreensharingSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ScreensharingSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ScreensharingSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ScreensharingSettingsResponse(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        targetResolution: TargetResolution.fromJson(json[r'target_resolution']),
      );
    }
    return null;
  }

  static List<ScreensharingSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ScreensharingSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ScreensharingSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ScreensharingSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, ScreensharingSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ScreensharingSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ScreensharingSettingsResponse-objects as value to a dart map
  static Map<String, List<ScreensharingSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ScreensharingSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ScreensharingSettingsResponse.listFromJson(entry.value, growable: growable,);
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

