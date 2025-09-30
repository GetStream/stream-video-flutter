//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class User {
  /// Returns a new [User] instance.
  User({
    this.avgResponseTime,
    this.banExpires,
    required this.banned,
    this.createdAt,
    this.custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    required this.id,
    this.invisible,
    this.language,
    this.lastActive,
    this.lastEngagedAt,
    required this.online,
    this.privacySettings,
    this.revokeTokensIssuedBefore,
    required this.role,
    this.teams = const [],
    this.teamsRole = const {},
    this.updatedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? avgResponseTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? banExpires;

  bool banned;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deactivatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? invisible;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? language;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastActive;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastEngagedAt;

  bool online;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PrivacySettings? privacySettings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? revokeTokensIssuedBefore;

  String role;

  List<String> teams;

  Map<String, String> teamsRole;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          other.avgResponseTime == avgResponseTime &&
          other.banExpires == banExpires &&
          other.banned == banned &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.deactivatedAt == deactivatedAt &&
          other.deletedAt == deletedAt &&
          other.id == id &&
          other.invisible == invisible &&
          other.language == language &&
          other.lastActive == lastActive &&
          other.lastEngagedAt == lastEngagedAt &&
          other.online == online &&
          other.privacySettings == privacySettings &&
          other.revokeTokensIssuedBefore == revokeTokensIssuedBefore &&
          other.role == role &&
          _deepEquality.equals(other.teams, teams) &&
          _deepEquality.equals(other.teamsRole, teamsRole) &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (avgResponseTime == null ? 0 : avgResponseTime!.hashCode) +
      (banExpires == null ? 0 : banExpires!.hashCode) +
      (banned.hashCode) +
      (createdAt == null ? 0 : createdAt!.hashCode) +
      (custom.hashCode) +
      (deactivatedAt == null ? 0 : deactivatedAt!.hashCode) +
      (deletedAt == null ? 0 : deletedAt!.hashCode) +
      (id.hashCode) +
      (invisible == null ? 0 : invisible!.hashCode) +
      (language == null ? 0 : language!.hashCode) +
      (lastActive == null ? 0 : lastActive!.hashCode) +
      (lastEngagedAt == null ? 0 : lastEngagedAt!.hashCode) +
      (online.hashCode) +
      (privacySettings == null ? 0 : privacySettings!.hashCode) +
      (revokeTokensIssuedBefore == null
          ? 0
          : revokeTokensIssuedBefore!.hashCode) +
      (role.hashCode) +
      (teams.hashCode) +
      (teamsRole.hashCode) +
      (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() =>
      'User[avgResponseTime=$avgResponseTime, banExpires=$banExpires, banned=$banned, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, id=$id, invisible=$invisible, language=$language, lastActive=$lastActive, lastEngagedAt=$lastEngagedAt, online=$online, privacySettings=$privacySettings, revokeTokensIssuedBefore=$revokeTokensIssuedBefore, role=$role, teams=$teams, teamsRole=$teamsRole, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.avgResponseTime != null) {
      json[r'avg_response_time'] = this.avgResponseTime;
    } else {
      json[r'avg_response_time'] = null;
    }
    if (this.banExpires != null) {
      json[r'ban_expires'] = this.banExpires!.toUtc().toIso8601String();
    } else {
      json[r'ban_expires'] = null;
    }
    json[r'banned'] = this.banned;
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'created_at'] = null;
    }
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
    if (this.invisible != null) {
      json[r'invisible'] = this.invisible;
    } else {
      json[r'invisible'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    if (this.lastActive != null) {
      json[r'last_active'] = this.lastActive!.toUtc().toIso8601String();
    } else {
      json[r'last_active'] = null;
    }
    if (this.lastEngagedAt != null) {
      json[r'last_engaged_at'] = this.lastEngagedAt!.toUtc().toIso8601String();
    } else {
      json[r'last_engaged_at'] = null;
    }
    json[r'online'] = this.online;
    if (this.privacySettings != null) {
      json[r'privacy_settings'] = this.privacySettings;
    } else {
      json[r'privacy_settings'] = null;
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
    if (this.updatedAt != null) {
      json[r'updated_at'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updated_at'] = null;
    }
    return json;
  }

  /// Returns a new [User] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static User? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "User[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "User[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return User(
        avgResponseTime: mapValueOfType<int>(json, r'avg_response_time'),
        banExpires: mapDateTime(json, r'ban_expires', r''),
        banned: mapValueOfType<bool>(json, r'banned')!,
        createdAt: mapDateTime(json, r'created_at', r''),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deactivatedAt: mapDateTime(json, r'deactivated_at', r''),
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        id: mapValueOfType<String>(json, r'id')!,
        invisible: mapValueOfType<bool>(json, r'invisible'),
        language: mapValueOfType<String>(json, r'language'),
        lastActive: mapDateTime(json, r'last_active', r''),
        lastEngagedAt: mapDateTime(json, r'last_engaged_at', r''),
        online: mapValueOfType<bool>(json, r'online')!,
        privacySettings: PrivacySettings.fromJson(json[r'privacy_settings']),
        revokeTokensIssuedBefore:
            mapDateTime(json, r'revoke_tokens_issued_before', r''),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        teamsRole: mapCastOfType<String, String>(json, r'teams_role')!,
        updatedAt: mapDateTime(json, r'updated_at', r''),
      );
    }
    return null;
  }

  static List<User> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <User>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = User.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, User> mapFromJson(dynamic json) {
    final map = <String, User>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = User.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of User-objects as value to a dart map
  static Map<String, List<User>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<User>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = User.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'banned',
    'custom',
    'id',
    'online',
    'role',
    'teams_role',
  };
}
