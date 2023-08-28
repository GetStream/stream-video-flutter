//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSAuthMessageRequest {
  /// Returns a new [WSAuthMessageRequest] instance.
  WSAuthMessageRequest({
    required this.token,
    required this.userDetails,
  });

  String token;

  ConnectUserDetailsRequest userDetails;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WSAuthMessageRequest &&
     other.token == token &&
     other.userDetails == userDetails;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (token.hashCode) +
    (userDetails.hashCode);

  @override
  String toString() => 'WSAuthMessageRequest[token=$token, userDetails=$userDetails]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'token'] = this.token;
      json[r'user_details'] = this.userDetails;
    return json;
  }

  /// Returns a new [WSAuthMessageRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WSAuthMessageRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WSAuthMessageRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WSAuthMessageRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WSAuthMessageRequest(
        token: mapValueOfType<String>(json, r'token')!,
        userDetails: ConnectUserDetailsRequest.fromJson(json[r'user_details'])!,
      );
    }
    return null;
  }

  static List<WSAuthMessageRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WSAuthMessageRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSAuthMessageRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WSAuthMessageRequest> mapFromJson(dynamic json) {
    final map = <String, WSAuthMessageRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSAuthMessageRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WSAuthMessageRequest-objects as value to a dart map
  static Map<String, List<WSAuthMessageRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WSAuthMessageRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WSAuthMessageRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'token',
    'user_details',
  };
}

