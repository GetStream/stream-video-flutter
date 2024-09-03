//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserEventPayload {
  /// Returns a new [UserEventPayload] instance.
  UserEventPayload({
    required this.banned,
    this.blockedUserIds = const [],
    required this.createdAt,
    this.custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    required this.id,
    this.image,
    this.invisible,
    required this.language,
    this.lastActive,
    this.name,
    required this.online,
    this.privacySettings,
    this.revokeTokensIssuedBefore,
    required this.role,
    this.teams = const [],
    required this.updatedAt,
  });

  bool banned;

  List<String> blockedUserIds;

  DateTime createdAt;

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
  String? image;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? invisible;

  String language;

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
  String? name;

  bool online;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PrivacySettingsResponse? privacySettings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? revokeTokensIssuedBefore;

  String role;

  List<String> teams;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserEventPayload &&
    other.banned == banned &&
    _deepEquality.equals(other.blockedUserIds, blockedUserIds) &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.deactivatedAt == deactivatedAt &&
    other.deletedAt == deletedAt &&
    other.id == id &&
    other.image == image &&
    other.invisible == invisible &&
    other.language == language &&
    other.lastActive == lastActive &&
    other.name == name &&
    other.online == online &&
    other.privacySettings == privacySettings &&
    other.revokeTokensIssuedBefore == revokeTokensIssuedBefore &&
    other.role == role &&
    _deepEquality.equals(other.teams, teams) &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (banned.hashCode) +
    (blockedUserIds.hashCode) +
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deactivatedAt == null ? 0 : deactivatedAt!.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (id.hashCode) +
    (image == null ? 0 : image!.hashCode) +
    (invisible == null ? 0 : invisible!.hashCode) +
    (language.hashCode) +
    (lastActive == null ? 0 : lastActive!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (online.hashCode) +
    (privacySettings == null ? 0 : privacySettings!.hashCode) +
    (revokeTokensIssuedBefore == null ? 0 : revokeTokensIssuedBefore!.hashCode) +
    (role.hashCode) +
    (teams.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'UserEventPayload[banned=$banned, blockedUserIds=$blockedUserIds, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, id=$id, image=$image, invisible=$invisible, language=$language, lastActive=$lastActive, name=$name, online=$online, privacySettings=$privacySettings, revokeTokensIssuedBefore=$revokeTokensIssuedBefore, role=$role, teams=$teams, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'banned'] = this.banned;
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
    if (this.invisible != null) {
      json[r'invisible'] = this.invisible;
    } else {
      json[r'invisible'] = null;
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
      json[r'online'] = this.online;
    if (this.privacySettings != null) {
      json[r'privacy_settings'] = this.privacySettings;
    } else {
      json[r'privacy_settings'] = null;
    }
    if (this.revokeTokensIssuedBefore != null) {
      json[r'revoke_tokens_issued_before'] = this.revokeTokensIssuedBefore!.toUtc().toIso8601String();
    } else {
      json[r'revoke_tokens_issued_before'] = null;
    }
      json[r'role'] = this.role;
      json[r'teams'] = this.teams;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [UserEventPayload] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserEventPayload? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserEventPayload[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserEventPayload[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserEventPayload(
        banned: mapValueOfType<bool>(json, r'banned')!,
        blockedUserIds: json[r'blocked_user_ids'] is Iterable
            ? (json[r'blocked_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deactivatedAt: mapDateTime(json, r'deactivated_at', r''),
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        invisible: mapValueOfType<bool>(json, r'invisible'),
        language: mapValueOfType<String>(json, r'language')!,
        lastActive: mapDateTime(json, r'last_active', r''),
        name: mapValueOfType<String>(json, r'name'),
        online: mapValueOfType<bool>(json, r'online')!,
        privacySettings: PrivacySettingsResponse.fromJson(json[r'privacy_settings']),
        revokeTokensIssuedBefore: mapDateTime(json, r'revoke_tokens_issued_before', r''),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<UserEventPayload> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserEventPayload>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserEventPayload.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserEventPayload> mapFromJson(dynamic json) {
    final map = <String, UserEventPayload>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserEventPayload.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserEventPayload-objects as value to a dart map
  static Map<String, List<UserEventPayload>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserEventPayload>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserEventPayload.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'banned',
    'blocked_user_ids',
    'created_at',
    'custom',
    'id',
    'language',
    'online',
    'role',
    'teams',
    'updated_at',
  };
}

