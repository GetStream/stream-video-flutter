//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SessionSettingsResponse {
  /// Returns a new [SessionSettingsResponse] instance.
  SessionSettingsResponse({
    required this.inactivityTimeoutSeconds,
  });

  /// Minimum value: 5
  /// Maximum value: 900
  int inactivityTimeoutSeconds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionSettingsResponse &&
          other.inactivityTimeoutSeconds == inactivityTimeoutSeconds;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (inactivityTimeoutSeconds.hashCode);

  @override
  String toString() =>
      'SessionSettingsResponse[inactivityTimeoutSeconds=$inactivityTimeoutSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'inactivity_timeout_seconds'] = this.inactivityTimeoutSeconds;
    return json;
  }

  /// Returns a new [SessionSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SessionSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "SessionSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "SessionSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SessionSettingsResponse(
        inactivityTimeoutSeconds:
            mapValueOfType<int>(json, r'inactivity_timeout_seconds')!,
      );
    }
    return null;
  }

  static List<SessionSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SessionSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SessionSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, SessionSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SessionSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SessionSettingsResponse-objects as value to a dart map
  static Map<String, List<SessionSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SessionSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SessionSettingsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'inactivity_timeout_seconds',
  };
}
