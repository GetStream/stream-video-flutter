//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ICEServerResponse {
  /// Returns a new [ICEServerResponse] instance.
  ICEServerResponse({
    required this.password,
    this.urls = const [],
    required this.username,
  });

  /// ICE server password
  String password;

  /// ICE server URLs
  List<String> urls;

  /// ICE server username
  String username;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ICEServerResponse &&
          other.password == password &&
          _deepEquality.equals(other.urls, urls) &&
          other.username == username;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (password.hashCode) + (urls.hashCode) + (username.hashCode);

  @override
  String toString() =>
      'ICEServerResponse[password=$password, urls=$urls, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'password'] = this.password;
    json[r'urls'] = this.urls;
    json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [ICEServerResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ICEServerResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'password'),
            'Required key "ICEServerResponse[password]" is missing from JSON.');
        assert(json[r'password'] != null,
            'Required key "ICEServerResponse[password]" has a null value in JSON.');
        assert(json.containsKey(r'urls'),
            'Required key "ICEServerResponse[urls]" is missing from JSON.');
        assert(json[r'urls'] != null,
            'Required key "ICEServerResponse[urls]" has a null value in JSON.');
        assert(json.containsKey(r'username'),
            'Required key "ICEServerResponse[username]" is missing from JSON.');
        assert(json[r'username'] != null,
            'Required key "ICEServerResponse[username]" has a null value in JSON.');
        return true;
      }());

      return ICEServerResponse(
        password: mapValueOfType<String>(json, r'password')!,
        urls: json[r'urls'] is Iterable
            ? (json[r'urls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<ICEServerResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ICEServerResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ICEServerResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ICEServerResponse> mapFromJson(dynamic json) {
    final map = <String, ICEServerResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ICEServerResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ICEServerResponse-objects as value to a dart map
  static Map<String, List<ICEServerResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ICEServerResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ICEServerResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'password',
    'urls',
    'username',
  };
}
