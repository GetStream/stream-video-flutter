//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LimitsSettingsResponse {
  /// Returns a new [LimitsSettingsResponse] instance.
  LimitsSettingsResponse({
    this.maxDurationSeconds,
    this.maxParticipants,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxDurationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxParticipants;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LimitsSettingsResponse &&
    other.maxDurationSeconds == maxDurationSeconds &&
    other.maxParticipants == maxParticipants;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (maxDurationSeconds == null ? 0 : maxDurationSeconds!.hashCode) +
    (maxParticipants == null ? 0 : maxParticipants!.hashCode);

  @override
  String toString() => 'LimitsSettingsResponse[maxDurationSeconds=$maxDurationSeconds, maxParticipants=$maxParticipants]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.maxDurationSeconds != null) {
      json[r'max_duration_seconds'] = this.maxDurationSeconds;
    } else {
      json[r'max_duration_seconds'] = null;
    }
    if (this.maxParticipants != null) {
      json[r'max_participants'] = this.maxParticipants;
    } else {
      json[r'max_participants'] = null;
    }
    return json;
  }

  /// Returns a new [LimitsSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LimitsSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LimitsSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LimitsSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LimitsSettingsResponse(
        maxDurationSeconds: mapValueOfType<int>(json, r'max_duration_seconds'),
        maxParticipants: mapValueOfType<int>(json, r'max_participants'),
      );
    }
    return null;
  }

  static List<LimitsSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LimitsSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LimitsSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LimitsSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, LimitsSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LimitsSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LimitsSettingsResponse-objects as value to a dart map
  static Map<String, List<LimitsSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LimitsSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LimitsSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

