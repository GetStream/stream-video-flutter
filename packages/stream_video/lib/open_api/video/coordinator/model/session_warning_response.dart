//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SessionWarningResponse {
  /// Returns a new [SessionWarningResponse] instance.
  SessionWarningResponse({
    required this.code,
    this.time,
    required this.warning,
  });

  String code;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? time;

  String warning;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionWarningResponse &&
          other.code == code &&
          other.time == time &&
          other.warning == warning;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (code.hashCode) +
      (time == null ? 0 : time!.hashCode) +
      (warning.hashCode);

  @override
  String toString() =>
      'SessionWarningResponse[code=$code, time=$time, warning=$warning]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'code'] = this.code;
    if (this.time != null) {
      json[r'time'] = this.time!.toUtc().toIso8601String();
    } else {
      json[r'time'] = null;
    }
    json[r'warning'] = this.warning;
    return json;
  }

  /// Returns a new [SessionWarningResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SessionWarningResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'code'),
            'Required key "SessionWarningResponse[code]" is missing from JSON.');
        assert(json[r'code'] != null,
            'Required key "SessionWarningResponse[code]" has a null value in JSON.');
        assert(json.containsKey(r'warning'),
            'Required key "SessionWarningResponse[warning]" is missing from JSON.');
        assert(json[r'warning'] != null,
            'Required key "SessionWarningResponse[warning]" has a null value in JSON.');
        return true;
      }());

      return SessionWarningResponse(
        code: mapValueOfType<String>(json, r'code')!,
        time: mapDateTime(json, r'time', r''),
        warning: mapValueOfType<String>(json, r'warning')!,
      );
    }
    return null;
  }

  static List<SessionWarningResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SessionWarningResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SessionWarningResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SessionWarningResponse> mapFromJson(dynamic json) {
    final map = <String, SessionWarningResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SessionWarningResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SessionWarningResponse-objects as value to a dart map
  static Map<String, List<SessionWarningResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SessionWarningResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SessionWarningResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'code',
    'warning',
  };
}
