//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ICEServer {
  /// Returns a new [ICEServer] instance.
  ICEServer({
    required this.password,
    this.urls = const [],
    required this.username,
  });

  String password;

  List<String> urls;

  String username;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ICEServer &&
     other.password == password &&
     other.urls == urls &&
     other.username == username;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (password.hashCode) +
    (urls.hashCode) +
    (username.hashCode);

  @override
  String toString() => 'ICEServer[password=$password, urls=$urls, username=$username]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'password'] = this.password;
      json[r'urls'] = this.urls;
      json[r'username'] = this.username;
    return json;
  }

  /// Returns a new [ICEServer] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ICEServer? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ICEServer[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ICEServer[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ICEServer(
        password: mapValueOfType<String>(json, r'password')!,
        urls: json[r'urls'] is List
            ? (json[r'urls'] as List).cast<String>()
            : const [],
        username: mapValueOfType<String>(json, r'username')!,
      );
    }
    return null;
  }

  static List<ICEServer> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ICEServer>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ICEServer.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ICEServer> mapFromJson(dynamic json) {
    final map = <String, ICEServer>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ICEServer.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ICEServer-objects as value to a dart map
  static Map<String, List<ICEServer>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ICEServer>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ICEServer.listFromJson(entry.value, growable: growable,);
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

