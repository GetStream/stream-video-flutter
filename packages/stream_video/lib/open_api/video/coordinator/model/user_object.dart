//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserObject {
  /// Returns a new [UserObject] instance.
  UserObject({
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
    required this.online,
    this.privacySettings,
    this.pushNotifications,
    this.revokeTokensIssuedBefore,
    required this.role,
    this.teams = const [],
    this.updatedAt,
  });

  /// Expiration date of the ban
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? banExpires;

  /// Whether a user is banned or not
  bool banned;

  /// Date/time of creation
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  Map<String, Object> custom;

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
  bool? invisible;

  /// Preferred language of a user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? language;

  /// Date of last activity
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastActive;

  /// Whether a user online or not
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
  PushNotificationSettings? pushNotifications;

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

  /// Date/time of the last update
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserObject &&
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
    other.online == online &&
    other.privacySettings == privacySettings &&
    other.pushNotifications == pushNotifications &&
    other.revokeTokensIssuedBefore == revokeTokensIssuedBefore &&
    other.role == role &&
    _deepEquality.equals(other.teams, teams) &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
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
    (online.hashCode) +
    (privacySettings == null ? 0 : privacySettings!.hashCode) +
    (pushNotifications == null ? 0 : pushNotifications!.hashCode) +
    (revokeTokensIssuedBefore == null ? 0 : revokeTokensIssuedBefore!.hashCode) +
    (role.hashCode) +
    (teams.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode);

  @override
  String toString() => 'UserObject[banExpires=$banExpires, banned=$banned, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, id=$id, invisible=$invisible, language=$language, lastActive=$lastActive, online=$online, privacySettings=$privacySettings, pushNotifications=$pushNotifications, revokeTokensIssuedBefore=$revokeTokensIssuedBefore, role=$role, teams=$teams, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
      json[r'online'] = this.online;
    if (this.privacySettings != null) {
      json[r'privacy_settings'] = this.privacySettings;
    } else {
      json[r'privacy_settings'] = null;
    }
    if (this.pushNotifications != null) {
      json[r'push_notifications'] = this.pushNotifications;
    } else {
      json[r'push_notifications'] = null;
    }
    if (this.revokeTokensIssuedBefore != null) {
      json[r'revoke_tokens_issued_before'] = this.revokeTokensIssuedBefore!.toUtc().toIso8601String();
    } else {
      json[r'revoke_tokens_issued_before'] = null;
    }
      json[r'role'] = this.role;
      json[r'teams'] = this.teams;
    if (this.updatedAt != null) {
      json[r'updated_at'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updated_at'] = null;
    }
    return json;
  }

  /// Returns a new [UserObject] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserObject? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserObject[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserObject[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserObject(
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
        online: mapValueOfType<bool>(json, r'online')!,
        privacySettings: PrivacySettings.fromJson(json[r'privacy_settings']),
        pushNotifications: PushNotificationSettings.fromJson(json[r'push_notifications']),
        revokeTokensIssuedBefore: mapDateTime(json, r'revoke_tokens_issued_before', r''),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        updatedAt: mapDateTime(json, r'updated_at', r''),
      );
    }
    return null;
  }

  static List<UserObject> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserObject>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserObject.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserObject> mapFromJson(dynamic json) {
    final map = <String, UserObject>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserObject.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserObject-objects as value to a dart map
  static Map<String, List<UserObject>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserObject>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserObject.listFromJson(entry.value, growable: growable,);
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
  };
}

