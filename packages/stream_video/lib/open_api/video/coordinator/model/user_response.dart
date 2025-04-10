//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserResponse {
  /// Returns a new [UserResponse] instance.
  UserResponse({
    this.blockedUserIds = const [],
    required this.createdAt,
    this.custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    required this.id,
    this.image,
    required this.language,
    this.lastActive,
    this.name,
    this.revokeTokensIssuedBefore,
    required this.role,
    this.teams = const [],
    this.teamsRole = const {},
    required this.updatedAt,
  });

  List<String> blockedUserIds;

  /// Date/time of creation
  DateTime createdAt;

  /// Custom data for this object
  // MANUAL_EDIT: allow null values
  Map<String, Object?> custom;

  /// Date of deactivation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deactivatedAt;

  /// Date/time of deletion
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  /// Unique user identifier
  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? image;

  /// Preferred language of a user
  String language;

  /// Date of last activity
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastActive;

  /// Optional name of user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  /// Revocation date for tokens
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? revokeTokensIssuedBefore;

  /// Determines the set of user permissions
  String role;

  /// List of teams user is a part of
  List<String> teams;

  Map<String, String> teamsRole;

  /// Date/time of the last update
  DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResponse &&
          _deepEquality.equals(other.blockedUserIds, blockedUserIds) &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.deactivatedAt == deactivatedAt &&
          other.deletedAt == deletedAt &&
          other.id == id &&
          other.image == image &&
          other.language == language &&
          other.lastActive == lastActive &&
          other.name == name &&
          other.revokeTokensIssuedBefore == revokeTokensIssuedBefore &&
          other.role == role &&
          _deepEquality.equals(other.teams, teams) &&
          _deepEquality.equals(other.teamsRole, teamsRole) &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (blockedUserIds.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (deactivatedAt == null ? 0 : deactivatedAt!.hashCode) +
      (deletedAt == null ? 0 : deletedAt!.hashCode) +
      (id.hashCode) +
      (image == null ? 0 : image!.hashCode) +
      (language.hashCode) +
      (lastActive == null ? 0 : lastActive!.hashCode) +
      (name == null ? 0 : name!.hashCode) +
      (revokeTokensIssuedBefore == null
          ? 0
          : revokeTokensIssuedBefore!.hashCode) +
      (role.hashCode) +
      (teams.hashCode) +
      (teamsRole.hashCode) +
      (updatedAt.hashCode);

  @override
  String toString() =>
      'UserResponse[blockedUserIds=$blockedUserIds, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, id=$id, image=$image, language=$language, lastActive=$lastActive, name=$name, revokeTokensIssuedBefore=$revokeTokensIssuedBefore, role=$role, teams=$teams, teamsRole=$teamsRole, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'blocked_user_ids'] = this.blockedUserIds;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    if (this.deactivatedAt != null) {
      json[r'deactivated_at'] = this.deactivatedAt!.toUtc().toIso8601String();
    } else {
      json[r'deactivated_at'] = null;
    }
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
    json[r'id'] = this.id;
    if (this.image != null) {
      json[r'image'] = this.image;
    } else {
      json[r'image'] = null;
    }
    json[r'language'] = this.language;
    if (this.lastActive != null) {
      json[r'last_active'] = this.lastActive!.toUtc().toIso8601String();
    } else {
      json[r'last_active'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.revokeTokensIssuedBefore != null) {
      json[r'revoke_tokens_issued_before'] =
          this.revokeTokensIssuedBefore!.toUtc().toIso8601String();
    } else {
      json[r'revoke_tokens_issued_before'] = null;
    }
    json[r'role'] = this.role;
    json[r'teams'] = this.teams;
    json[r'teams_role'] = this.teamsRole;
    json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [UserResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "UserResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "UserResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserResponse(
        blockedUserIds: json[r'blocked_user_ids'] is Iterable
            ? (json[r'blocked_user_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'created_at', r'')!,
        // MANUAL_EDIT: allow null values
        custom: mapCastOfType<String, Object?>(json, r'custom')!,
        deactivatedAt: mapDateTime(json, r'deactivated_at', r''),
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        language: mapValueOfType<String>(json, r'language')!,
        lastActive: mapDateTime(json, r'last_active', r''),
        name: mapValueOfType<String>(json, r'name'),
        revokeTokensIssuedBefore:
            mapDateTime(json, r'revoke_tokens_issued_before', r''),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        teamsRole:
            mapCastOfType<String, String>(json, r'teams_role') ?? const {},
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<UserResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UserResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserResponse> mapFromJson(dynamic json) {
    final map = <String, UserResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserResponse-objects as value to a dart map
  static Map<String, List<UserResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UserResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'blocked_user_ids',
    'created_at',
    'custom',
    'id',
    'language',
    'role',
    'teams',
    'updated_at',
  };
}
