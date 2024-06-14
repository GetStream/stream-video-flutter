//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OwnUser {
  /// Returns a new [OwnUser] instance.
  OwnUser({
    required this.banned,
    this.blockedUserIds = const [],
    this.channelMutes = const [],
    required this.createdAt,
    this.custom = const {},
    this.deactivatedAt,
    this.deletedAt,
    this.devices = const [],
    required this.id,
    this.invisible,
    required this.language,
    this.lastActive,
    this.latestHiddenChannels = const [],
    this.mutes = const [],
    required this.online,
    this.privacySettings,
    this.pushNotifications,
    required this.role,
    this.teams = const [],
    required this.totalUnreadCount,
    required this.unreadChannels,
    required this.unreadCount,
    required this.unreadThreads,
    required this.updatedAt,
  });

  bool banned;

  List<String> blockedUserIds;

  List<ChannelMute> channelMutes;

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

  List<Device> devices;

  String id;

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

  List<String> latestHiddenChannels;

  List<UserMute> mutes;

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

  String role;

  List<String> teams;

  int totalUnreadCount;

  int unreadChannels;

  int unreadCount;

  int unreadThreads;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OwnUser &&
    other.banned == banned &&
    _deepEquality.equals(other.blockedUserIds, blockedUserIds) &&
    _deepEquality.equals(other.channelMutes, channelMutes) &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.deactivatedAt == deactivatedAt &&
    other.deletedAt == deletedAt &&
    _deepEquality.equals(other.devices, devices) &&
    other.id == id &&
    other.invisible == invisible &&
    other.language == language &&
    other.lastActive == lastActive &&
    _deepEquality.equals(other.latestHiddenChannels, latestHiddenChannels) &&
    _deepEquality.equals(other.mutes, mutes) &&
    other.online == online &&
    other.privacySettings == privacySettings &&
    other.pushNotifications == pushNotifications &&
    other.role == role &&
    _deepEquality.equals(other.teams, teams) &&
    other.totalUnreadCount == totalUnreadCount &&
    other.unreadChannels == unreadChannels &&
    other.unreadCount == unreadCount &&
    other.unreadThreads == unreadThreads &&
    other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (banned.hashCode) +
    (blockedUserIds.hashCode) +
    (channelMutes.hashCode) +
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deactivatedAt == null ? 0 : deactivatedAt!.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (devices.hashCode) +
    (id.hashCode) +
    (invisible == null ? 0 : invisible!.hashCode) +
    (language.hashCode) +
    (lastActive == null ? 0 : lastActive!.hashCode) +
    (latestHiddenChannels.hashCode) +
    (mutes.hashCode) +
    (online.hashCode) +
    (privacySettings == null ? 0 : privacySettings!.hashCode) +
    (pushNotifications == null ? 0 : pushNotifications!.hashCode) +
    (role.hashCode) +
    (teams.hashCode) +
    (totalUnreadCount.hashCode) +
    (unreadChannels.hashCode) +
    (unreadCount.hashCode) +
    (unreadThreads.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'OwnUser[banned=$banned, blockedUserIds=$blockedUserIds, channelMutes=$channelMutes, createdAt=$createdAt, custom=$custom, deactivatedAt=$deactivatedAt, deletedAt=$deletedAt, devices=$devices, id=$id, invisible=$invisible, language=$language, lastActive=$lastActive, latestHiddenChannels=$latestHiddenChannels, mutes=$mutes, online=$online, privacySettings=$privacySettings, pushNotifications=$pushNotifications, role=$role, teams=$teams, totalUnreadCount=$totalUnreadCount, unreadChannels=$unreadChannels, unreadCount=$unreadCount, unreadThreads=$unreadThreads, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'banned'] = this.banned;
      json[r'blocked_user_ids'] = this.blockedUserIds;
      json[r'channel_mutes'] = this.channelMutes;
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
      json[r'latest_hidden_channels'] = this.latestHiddenChannels;
      json[r'mutes'] = this.mutes;
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
      json[r'role'] = this.role;
      json[r'teams'] = this.teams;
      json[r'total_unread_count'] = this.totalUnreadCount;
      json[r'unread_channels'] = this.unreadChannels;
      json[r'unread_count'] = this.unreadCount;
      json[r'unread_threads'] = this.unreadThreads;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [OwnUser] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OwnUser? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OwnUser[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OwnUser[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OwnUser(
        banned: mapValueOfType<bool>(json, r'banned')!,
        blockedUserIds: json[r'blocked_user_ids'] is Iterable
            ? (json[r'blocked_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        channelMutes: ChannelMute.listFromJson(json[r'channel_mutes']),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deactivatedAt: mapDateTime(json, r'deactivated_at', r''),
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        devices: Device.listFromJson(json[r'devices']),
        id: mapValueOfType<String>(json, r'id')!,
        invisible: mapValueOfType<bool>(json, r'invisible'),
        language: mapValueOfType<String>(json, r'language')!,
        lastActive: mapDateTime(json, r'last_active', r''),
        latestHiddenChannels: json[r'latest_hidden_channels'] is Iterable
            ? (json[r'latest_hidden_channels'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        mutes: UserMute.listFromJson(json[r'mutes']),
        online: mapValueOfType<bool>(json, r'online')!,
        privacySettings: PrivacySettings.fromJson(json[r'privacy_settings']),
        pushNotifications: PushNotificationSettings.fromJson(json[r'push_notifications']),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is Iterable
            ? (json[r'teams'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        totalUnreadCount: mapValueOfType<int>(json, r'total_unread_count')!,
        unreadChannels: mapValueOfType<int>(json, r'unread_channels')!,
        unreadCount: mapValueOfType<int>(json, r'unread_count')!,
        unreadThreads: mapValueOfType<int>(json, r'unread_threads')!,
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
      );
    }
    return null;
  }

  static List<OwnUser> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OwnUser>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OwnUser.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OwnUser> mapFromJson(dynamic json) {
    final map = <String, OwnUser>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OwnUser.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OwnUser-objects as value to a dart map
  static Map<String, List<OwnUser>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OwnUser>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OwnUser.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'banned',
    'channel_mutes',
    'created_at',
    'custom',
    'devices',
    'id',
    'language',
    'mutes',
    'online',
    'role',
    'total_unread_count',
    'unread_channels',
    'unread_count',
    'unread_threads',
    'updated_at',
  };
}

