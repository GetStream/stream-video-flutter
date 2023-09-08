//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MemberResponse {
  /// Returns a new [MemberResponse] instance.
  MemberResponse({
    required this.createdAt,
    this.custom = const {},
    this.deletedAt,
    this.role,
    required this.updatedAt,
    required this.user,
    required this.userId,
  });

  /// Date/time of creation
  DateTime createdAt;

  /// Custom member response data
  Map<String, Object> custom;

  /// Date/time of deletion
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? role;

  /// Date/time of the last update
  DateTime updatedAt;

  UserResponse user;

  String userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MemberResponse &&
     other.createdAt == createdAt &&
     other.custom == custom &&
     other.deletedAt == deletedAt &&
     other.role == role &&
     other.updatedAt == updatedAt &&
     other.user == user &&
     other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (updatedAt.hashCode) +
    (user.hashCode) +
    (userId.hashCode);

  @override
  String toString() => 'MemberResponse[createdAt=$createdAt, custom=$custom, deletedAt=$deletedAt, role=$role, updatedAt=$updatedAt, user=$user, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
      json[r'user'] = this.user;
      json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [MemberResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MemberResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MemberResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MemberResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MemberResponse(
        createdAt: mapDateTime(json, r'created_at', '')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', ''),
        role: mapValueOfType<String>(json, r'role'),
        updatedAt: mapDateTime(json, r'updated_at', '')!,
        user: UserResponse.fromJson(json[r'user'])!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<MemberResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MemberResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MemberResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MemberResponse> mapFromJson(dynamic json) {
    final map = <String, MemberResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MemberResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MemberResponse-objects as value to a dart map
  static Map<String, List<MemberResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MemberResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MemberResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'custom',
    'updated_at',
    'user',
    'user_id',
  };
}

