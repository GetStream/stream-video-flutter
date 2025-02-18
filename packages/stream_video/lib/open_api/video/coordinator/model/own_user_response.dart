//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OwnUserResponse {
  /// Returns a new [OwnUserResponse] instance.
  OwnUserResponse({
    this.blockedUserIds = const [],
    required this.createdAt,
    this.custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    this.devices = const [],
    required this.id,
    this.image,
    required this.language,
    this.lastActive,
    this.name,
    this.privacySettings,
    this.pushNotifications,
    this.revokeTokensIssuedBefore,
    required this.role,
    this.teams = const [],
    required this.updatedAt,
  });

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

  List<DeviceResponse> devices;

  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? image;

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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? privacySettings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PushNotificationSettingsResponse? pushNotifications;

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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnUserResponse &&
          _deepEquality.equals(other.blockedUserIds, blockedUserIds) &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.deactivatedAt == deactivatedAt &&
          other.deletedAt == deletedAt &&
          _deepEquality.equals(other.devices, devices) &&
          other.id == id &&
          other.image == image &&
          other.language == language &&
          other.lastActive == lastActive &&
          other.name == name &&
          other.privacySettings == privacySettings &&
          other.pushNotifications == pushNotifications &&
          other.revokeTokensIssuedBefore == revokeTokensIssuedBefore &&
          other.role == role &&
          _deepEquality.equals(other.teams, teams) &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (blockedUserIds.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (deactivatedAt == null ? 0 : deactivatedAt!.hashCode) +
      (deletedAt == null ? 0 : deletedAt!.hashCode) +
      (devices.hashCode) +
      (id.hashCode) +
      (image == null ? 0 : image!.hashCode) +
      (language.hashCode) +
      (lastActive == null ? 0 : lastActive!.hashCode) +
      (name == null ? 0 : name!.hashCode) +
      (privacySettings == null ? 0 : privacySettings!.hashCode) +
      (pushNotifications == null ? 0 : pushNotifications!.hashCode) +
      (revokeTokensIssuedBefore == null
          ? 0
          : revokeTokensIssuedBefore!.hashCode) +
      (role.hashCode) +
      (teams.hashCode) +
      (updatedAt.hashCode);

  @override
  String toString() =>
      'OwnUserResponse[blockedUserIds=$blockedUserIds, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, devices=$devices, id=$id, image=$image, language=$language, lastActive=$lastActive, name=$name, privacySettings=$privacySettings, pushNotifications=$pushNotifications, revokeTokensIssuedBefore=$revokeTokensIssuedBefore, role=$role, teams=$teams, updatedAt=$updatedAt]';

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
    json[r'devices'] = this.devices;
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
      json[r'revoke_tokens_issued_before'] =
          this.revokeTokensIssuedBefore!.toUtc().toIso8601String();
    } else {
      json[r'revoke_tokens_issued_before'] = null;
    }
    json[r'role'] = this.role;
    json[r'teams'] = this.teams;
    json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [OwnUserResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OwnUserResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "OwnUserResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "OwnUserResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OwnUserResponse(
        blockedUserIds: json[r'blocked_user_ids'] is Iterable
            ? (json[r'blocked_user_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deactivatedAt: mapDateTime(json, r'deactivated_at', r''),
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        devices: DeviceResponse.listFromJson(json[r'devices']),
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        language: mapValueOfType<String>(json, r'language')!,
        lastActive: mapDateTime(json, r'last_active', r''),
        name: mapValueOfType<String>(json, r'name'),
        privacySettings: mapValueOfType<Object>(json, r'privacy_settings'),
        pushNotifications: PushNotificationSettingsResponse.fromJson(
            json[r'push_notifications']),
        revokeTokensIssuedBefore:
            mapDateTime(json, r'revoke_tokens_issued_before', r''),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<OwnUserResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <OwnUserResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OwnUserResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OwnUserResponse> mapFromJson(dynamic json) {
    final map = <String, OwnUserResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OwnUserResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OwnUserResponse-objects as value to a dart map
  static Map<String, List<OwnUserResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<OwnUserResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OwnUserResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'custom',
    'devices',
    'id',
    'language',
    'role',
    'teams',
    'updated_at',
  };
}
