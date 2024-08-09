//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BackstageSettingsResponse {
  /// Returns a new [BackstageSettingsResponse] instance.
  BackstageSettingsResponse({
    required this.enabled,
    this.joinAheadTimeSeconds,
  });

  bool enabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? joinAheadTimeSeconds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BackstageSettingsResponse &&
    other.enabled == enabled &&
    other.joinAheadTimeSeconds == joinAheadTimeSeconds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (joinAheadTimeSeconds == null ? 0 : joinAheadTimeSeconds!.hashCode);

  @override
  String toString() => 'BackstageSettingsResponse[enabled=$enabled, joinAheadTimeSeconds=$joinAheadTimeSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
    if (this.joinAheadTimeSeconds != null) {
      json[r'join_ahead_time_seconds'] = this.joinAheadTimeSeconds;
    } else {
      json[r'join_ahead_time_seconds'] = null;
    }
    return json;
  }

  /// Returns a new [BackstageSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BackstageSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BackstageSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BackstageSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BackstageSettingsResponse(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        joinAheadTimeSeconds: mapValueOfType<int>(json, r'join_ahead_time_seconds'),
      );
    }
    return null;
  }

  static List<BackstageSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BackstageSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BackstageSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BackstageSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, BackstageSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BackstageSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BackstageSettingsResponse-objects as value to a dart map
  static Map<String, List<BackstageSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BackstageSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BackstageSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
  };
}

