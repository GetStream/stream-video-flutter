//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ChannelMember {
  /// Returns a new [ChannelMember] instance.
  ChannelMember({
    this.banExpires,
    required this.banned,
    required this.channelRole,
    required this.createdAt,
    this.custom = const {},
    this.deletedAt,
    this.inviteAcceptedAt,
    this.inviteRejectedAt,
    this.invited,
    this.isModerator,
    required this.notificationsMuted,
    required this.shadowBanned,
    this.status,
    required this.updatedAt,
    this.user,
    this.userId,
  });

  /// Expiration date of the ban
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? banExpires;

  /// Whether member is banned this channel or not
  bool banned;

  /// Role of the member in the channel
  String channelRole;

  /// Date/time of creation
  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  /// Date when invite was accepted
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? inviteAcceptedAt;

  /// Date when invite was rejected
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? inviteRejectedAt;

  /// Whether member was invited or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? invited;

  /// Whether member is channel moderator or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isModerator;

  bool notificationsMuted;

  /// Whether member is shadow banned in this channel or not
  bool shadowBanned;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? status;

  /// Date/time of the last update
  DateTime updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ChannelMember &&
    other.banExpires == banExpires &&
    other.banned == banned &&
    other.channelRole == channelRole &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.deletedAt == deletedAt &&
    other.inviteAcceptedAt == inviteAcceptedAt &&
    other.inviteRejectedAt == inviteRejectedAt &&
    other.invited == invited &&
    other.isModerator == isModerator &&
    other.notificationsMuted == notificationsMuted &&
    other.shadowBanned == shadowBanned &&
    other.status == status &&
    other.updatedAt == updatedAt &&
    other.user == user &&
    other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (banExpires == null ? 0 : banExpires!.hashCode) +
    (banned.hashCode) +
    (channelRole.hashCode) +
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (inviteAcceptedAt == null ? 0 : inviteAcceptedAt!.hashCode) +
    (inviteRejectedAt == null ? 0 : inviteRejectedAt!.hashCode) +
    (invited == null ? 0 : invited!.hashCode) +
    (isModerator == null ? 0 : isModerator!.hashCode) +
    (notificationsMuted.hashCode) +
    (shadowBanned.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (updatedAt.hashCode) +
    (user == null ? 0 : user!.hashCode) +
    (userId == null ? 0 : userId!.hashCode);

  @override
  String toString() => 'ChannelMember[banExpires=$banExpires, banned=$banned, channelRole=$channelRole, createdAt=$createdAt, custom=$custom, deletedAt=$deletedAt, inviteAcceptedAt=$inviteAcceptedAt, inviteRejectedAt=$inviteRejectedAt, invited=$invited, isModerator=$isModerator, notificationsMuted=$notificationsMuted, shadowBanned=$shadowBanned, status=$status, updatedAt=$updatedAt, user=$user, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.banExpires != null) {
      json[r'ban_expires'] = this.banExpires!.toUtc().toIso8601String();
    } else {
      json[r'ban_expires'] = null;
    }
      json[r'banned'] = this.banned;
      json[r'channel_role'] = this.channelRole;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
    if (this.inviteAcceptedAt != null) {
      json[r'invite_accepted_at'] = this.inviteAcceptedAt!.toUtc().toIso8601String();
    } else {
      json[r'invite_accepted_at'] = null;
    }
    if (this.inviteRejectedAt != null) {
      json[r'invite_rejected_at'] = this.inviteRejectedAt!.toUtc().toIso8601String();
    } else {
      json[r'invite_rejected_at'] = null;
    }
    if (this.invited != null) {
      json[r'invited'] = this.invited;
    } else {
      json[r'invited'] = null;
    }
    if (this.isModerator != null) {
      json[r'is_moderator'] = this.isModerator;
    } else {
      json[r'is_moderator'] = null;
    }
      json[r'notifications_muted'] = this.notificationsMuted;
      json[r'shadow_banned'] = this.shadowBanned;
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
    return json;
  }

  /// Returns a new [ChannelMember] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ChannelMember? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ChannelMember[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ChannelMember[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ChannelMember(
        banExpires: mapDateTime(json, r'ban_expires', r''),
        banned: mapValueOfType<bool>(json, r'banned')!,
        channelRole: mapValueOfType<String>(json, r'channel_role')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', r''),
        inviteAcceptedAt: mapDateTime(json, r'invite_accepted_at', r''),
        inviteRejectedAt: mapDateTime(json, r'invite_rejected_at', r''),
        invited: mapValueOfType<bool>(json, r'invited'),
        isModerator: mapValueOfType<bool>(json, r'is_moderator'),
        notificationsMuted: mapValueOfType<bool>(json, r'notifications_muted')!,
        shadowBanned: mapValueOfType<bool>(json, r'shadow_banned')!,
        status: mapValueOfType<String>(json, r'status'),
        updatedAt: mapDateTime(json, r'updated_at', r'')!,
        user: UserObject.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id'),
      );
    }
    return null;
  }

  static List<ChannelMember> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ChannelMember>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ChannelMember.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ChannelMember> mapFromJson(dynamic json) {
    final map = <String, ChannelMember>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ChannelMember.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ChannelMember-objects as value to a dart map
  static Map<String, List<ChannelMember>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ChannelMember>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ChannelMember.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'banned',
    'channel_role',
    'created_at',
    'custom',
    'notifications_muted',
    'shadow_banned',
    'updated_at',
  };
}

