//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserInfoResponse {
  /// Returns a new [UserInfoResponse] instance.
  UserInfoResponse({
    this.custom = const {},
    required this.image,
    required this.name,
    this.roles = const [],
  });

  Map<String, Object> custom;

  String image;

  String name;

  List<String> roles;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserInfoResponse &&
    _deepEquality.equals(other.custom, custom) &&
    other.image == image &&
    other.name == name &&
    _deepEquality.equals(other.roles, roles);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (image.hashCode) +
    (name.hashCode) +
    (roles.hashCode);

  @override
  String toString() => 'UserInfoResponse[custom=$custom, image=$image, name=$name, roles=$roles]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'image'] = this.image;
      json[r'name'] = this.name;
      json[r'roles'] = this.roles;
    return json;
  }

  /// Returns a new [UserInfoResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserInfoResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserInfoResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserInfoResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserInfoResponse(
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        image: mapValueOfType<String>(json, r'image')!,
        name: mapValueOfType<String>(json, r'name')!,
        roles: json[r'roles'] is Iterable
            ? (json[r'roles'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<UserInfoResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserInfoResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserInfoResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserInfoResponse> mapFromJson(dynamic json) {
    final map = <String, UserInfoResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserInfoResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserInfoResponse-objects as value to a dart map
  static Map<String, List<UserInfoResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserInfoResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserInfoResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'custom',
    'image',
    'name',
    'roles',
  };
}

