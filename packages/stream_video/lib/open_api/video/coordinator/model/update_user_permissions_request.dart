//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateUserPermissionsRequest {
  /// Returns a new [UpdateUserPermissionsRequest] instance.
  UpdateUserPermissionsRequest({
    this.grantPermissions = const [],
    this.revokePermissions = const [],
    required this.userId,
  });

  List<String> grantPermissions;

  List<String> revokePermissions;

  String userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateUserPermissionsRequest &&
     other.grantPermissions == grantPermissions &&
     other.revokePermissions == revokePermissions &&
     other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (grantPermissions.hashCode) +
    (revokePermissions.hashCode) +
    (userId.hashCode);

  @override
  String toString() => 'UpdateUserPermissionsRequest[grantPermissions=$grantPermissions, revokePermissions=$revokePermissions, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'grant_permissions'] = this.grantPermissions;
      json[r'revoke_permissions'] = this.revokePermissions;
      json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [UpdateUserPermissionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateUserPermissionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateUserPermissionsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateUserPermissionsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateUserPermissionsRequest(
        grantPermissions: json[r'grant_permissions'] is List
            ? (json[r'grant_permissions'] as List).cast<String>()
            : const [],
        revokePermissions: json[r'revoke_permissions'] is List
            ? (json[r'revoke_permissions'] as List).cast<String>()
            : const [],
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<UpdateUserPermissionsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateUserPermissionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateUserPermissionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateUserPermissionsRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateUserPermissionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateUserPermissionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateUserPermissionsRequest-objects as value to a dart map
  static Map<String, List<UpdateUserPermissionsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateUserPermissionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateUserPermissionsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

