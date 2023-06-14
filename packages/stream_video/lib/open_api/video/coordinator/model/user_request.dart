//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserRequest {
  /// Returns a new [UserRequest] instance.
  UserRequest({
    this.custom = const {},
    required this.id,
    this.image,
    this.name,
    this.role,
    this.teams = const [],
  });

  Map<String, Object> custom;

  /// User ID
  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? image;

  /// Optional name of user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? role;

  List<String> teams;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserRequest &&
     other.custom == custom &&
     other.id == id &&
     other.image == image &&
     other.name == name &&
     other.role == role &&
     other.teams == teams;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (id.hashCode) +
    (image == null ? 0 : image!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (teams.hashCode);

  @override
  String toString() => 'UserRequest[custom=$custom, id=$id, image=$image, name=$name, role=$role, teams=$teams]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'id'] = this.id;
    if (this.image != null) {
      json[r'image'] = this.image;
    } else {
      json[r'image'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
      json[r'teams'] = this.teams;
    return json;
  }

  /// Returns a new [UserRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        name: mapValueOfType<String>(json, r'name'),
        role: mapValueOfType<String>(json, r'role'),
        teams: json[r'teams'] is List
            ? (json[r'teams'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }

  static List<UserRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserRequest> mapFromJson(dynamic json) {
    final map = <String, UserRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserRequest-objects as value to a dart map
  static Map<String, List<UserRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

