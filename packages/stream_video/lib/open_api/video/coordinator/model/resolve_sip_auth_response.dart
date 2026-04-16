//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ResolveSipAuthResponse {
  /// Returns a new [ResolveSipAuthResponse] instance.
  ResolveSipAuthResponse({
    required this.authResult,
    required this.duration,
    this.password,
    this.trunkId,
    this.username,
  });

  /// Authentication result: password, accept, or no_trunk_found
  String authResult;

  String duration;

  /// Password for digest authentication (when auth_result is password)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? password;

  /// ID of the matched SIP trunk
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trunkId;

  /// Username for digest authentication (when auth_result is password)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResolveSipAuthResponse &&
          other.authResult == authResult &&
          other.duration == duration &&
          other.password == password &&
          other.trunkId == trunkId &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (authResult.hashCode) +
      (duration.hashCode) +
      (password == null ? 0 : password!.hashCode) +
      (trunkId == null ? 0 : trunkId!.hashCode) +
      (username == null ? 0 : username!.hashCode);

  @override
  String toString() =>
      'ResolveSipAuthResponse[authResult=$authResult, duration=$duration, password=$password, trunkId=$trunkId, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'auth_result'] = this.authResult;
    json[r'duration'] = this.duration;
    if (this.password != null) {
      json[r'password'] = this.password;
    } else {
      json[r'password'] = null;
    }
    if (this.trunkId != null) {
      json[r'trunk_id'] = this.trunkId;
    } else {
      json[r'trunk_id'] = null;
    }
    if (this.username != null) {
      json[r'username'] = this.username;
    } else {
      json[r'username'] = null;
    }
    return json;
  }

  /// Returns a new [ResolveSipAuthResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ResolveSipAuthResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'auth_result'),
            'Required key "ResolveSipAuthResponse[auth_result]" is missing from JSON.');
        assert(json[r'auth_result'] != null,
            'Required key "ResolveSipAuthResponse[auth_result]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "ResolveSipAuthResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "ResolveSipAuthResponse[duration]" has a null value in JSON.');
        return true;
      }());

      return ResolveSipAuthResponse(
        authResult: mapValueOfType<String>(json, r'auth_result')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        password: mapValueOfType<String>(json, r'password'),
        trunkId: mapValueOfType<String>(json, r'trunk_id'),
        username: mapValueOfType<String>(json, r'username'),
      );
    }
    return null;
  }

  static List<ResolveSipAuthResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ResolveSipAuthResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ResolveSipAuthResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ResolveSipAuthResponse> mapFromJson(dynamic json) {
    final map = <String, ResolveSipAuthResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ResolveSipAuthResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ResolveSipAuthResponse-objects as value to a dart map
  static Map<String, List<ResolveSipAuthResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ResolveSipAuthResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ResolveSipAuthResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'auth_result',
    'duration',
  };
}
