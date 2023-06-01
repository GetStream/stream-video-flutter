//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateGuestResponse {
  /// Returns a new [CreateGuestResponse] instance.
  CreateGuestResponse({
    required this.accessToken,
    required this.duration,
    required this.user,
  });

  /// the access token to authenticate the user
  String accessToken;

  String duration;

  UserResponse user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateGuestResponse &&
     other.accessToken == accessToken &&
     other.duration == duration &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessToken.hashCode) +
    (duration.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'CreateGuestResponse[accessToken=$accessToken, duration=$duration, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_token'] = this.accessToken;
      json[r'duration'] = this.duration;
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CreateGuestResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateGuestResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CreateGuestResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CreateGuestResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CreateGuestResponse(
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CreateGuestResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateGuestResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateGuestResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateGuestResponse> mapFromJson(dynamic json) {
    final map = <String, CreateGuestResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateGuestResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateGuestResponse-objects as value to a dart map
  static Map<String, List<CreateGuestResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateGuestResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateGuestResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_token',
    'duration',
    'user',
  };
}

