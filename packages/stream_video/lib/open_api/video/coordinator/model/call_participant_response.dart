//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallParticipantResponse {
  /// Returns a new [CallParticipantResponse] instance.
  CallParticipantResponse({
    required this.joinedAt,
    required this.user,
  });

  DateTime joinedAt;

  UserResponse user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallParticipantResponse &&
     other.joinedAt == joinedAt &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (joinedAt.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'CallParticipantResponse[joinedAt=$joinedAt, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'joined_at'] = this.joinedAt.toUtc().toIso8601String();
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallParticipantResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallParticipantResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallParticipantResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallParticipantResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallParticipantResponse(
        joinedAt: mapDateTime(json, r'joined_at', '')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallParticipantResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallParticipantResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallParticipantResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallParticipantResponse> mapFromJson(dynamic json) {
    final map = <String, CallParticipantResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallParticipantResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallParticipantResponse-objects as value to a dart map
  static Map<String, List<CallParticipantResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallParticipantResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallParticipantResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'joined_at',
    'user',
  };
}

