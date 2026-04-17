//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserUnbannedEvent {
  /// Returns a new [UserUnbannedEvent] instance.
  UserUnbannedEvent({
    this.channelCustom = const {},
    this.channelId,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channelType,
    this.cid,
    required this.createdAt,
    this.createdBy,
    this.custom = const {},
    this.receivedAt,
    this.shadow,
    this.team,
    this.type = 'user.unbanned',
    required this.user,
  });

  Map<String, Object> channelCustom;

  /// The ID of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? channelMemberCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? channelMessageCount;

  /// The type of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelType;

  /// The CID of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cid;

  /// Date/time of creation
  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponseCommonFields? createdBy;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  /// Whether the target user was shadow unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? shadow;

  /// The team of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  /// The type of event: \"user.unbanned\" in this case
  String type;

  UserResponseCommonFields user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserUnbannedEvent &&
          _deepEquality.equals(other.channelCustom, channelCustom) &&
          other.channelId == channelId &&
          other.channelMemberCount == channelMemberCount &&
          other.channelMessageCount == channelMessageCount &&
          other.channelType == channelType &&
          other.cid == cid &&
          other.createdAt == createdAt &&
          other.createdBy == createdBy &&
          _deepEquality.equals(other.custom, custom) &&
          other.receivedAt == receivedAt &&
          other.shadow == shadow &&
          other.team == team &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (channelCustom.hashCode) +
      (channelId == null ? 0 : channelId!.hashCode) +
      (channelMemberCount == null ? 0 : channelMemberCount!.hashCode) +
      (channelMessageCount == null ? 0 : channelMessageCount!.hashCode) +
      (channelType == null ? 0 : channelType!.hashCode) +
      (cid == null ? 0 : cid!.hashCode) +
      (createdAt.hashCode) +
      (createdBy == null ? 0 : createdBy!.hashCode) +
      (custom.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (shadow == null ? 0 : shadow!.hashCode) +
      (team == null ? 0 : team!.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'UserUnbannedEvent[channelCustom=$channelCustom, channelId=$channelId, channelMemberCount=$channelMemberCount, channelMessageCount=$channelMessageCount, channelType=$channelType, cid=$cid, createdAt=$createdAt, createdBy=$createdBy, custom=$custom, receivedAt=$receivedAt, shadow=$shadow, team=$team, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'channel_custom'] = this.channelCustom;
    if (this.channelId != null) {
      json[r'channel_id'] = this.channelId;
    } else {
      json[r'channel_id'] = null;
    }
    if (this.channelMemberCount != null) {
      json[r'channel_member_count'] = this.channelMemberCount;
    } else {
      json[r'channel_member_count'] = null;
    }
    if (this.channelMessageCount != null) {
      json[r'channel_message_count'] = this.channelMessageCount;
    } else {
      json[r'channel_message_count'] = null;
    }
    if (this.channelType != null) {
      json[r'channel_type'] = this.channelType;
    } else {
      json[r'channel_type'] = null;
    }
    if (this.cid != null) {
      json[r'cid'] = this.cid;
    } else {
      json[r'cid'] = null;
    }
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.createdBy != null) {
      json[r'created_by'] = this.createdBy;
    } else {
      json[r'created_by'] = null;
    }
    json[r'custom'] = this.custom;
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
    if (this.shadow != null) {
      json[r'shadow'] = this.shadow;
    } else {
      json[r'shadow'] = null;
    }
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [UserUnbannedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserUnbannedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'created_at'),
            'Required key "UserUnbannedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "UserUnbannedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'custom'),
            'Required key "UserUnbannedEvent[custom]" is missing from JSON.');
        assert(json[r'custom'] != null,
            'Required key "UserUnbannedEvent[custom]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "UserUnbannedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "UserUnbannedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "UserUnbannedEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "UserUnbannedEvent[user]" has a null value in JSON.');
        return true;
      }());

      return UserUnbannedEvent(
        channelCustom:
            mapCastOfType<String, Object>(json, r'channel_custom') ?? const {},
        channelId: mapValueOfType<String>(json, r'channel_id'),
        channelMemberCount: mapValueOfType<int>(json, r'channel_member_count'),
        channelMessageCount:
            mapValueOfType<int>(json, r'channel_message_count'),
        channelType: mapValueOfType<String>(json, r'channel_type'),
        cid: mapValueOfType<String>(json, r'cid'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserResponseCommonFields.fromJson(json[r'created_by']),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        shadow: mapValueOfType<bool>(json, r'shadow'),
        team: mapValueOfType<String>(json, r'team'),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponseCommonFields.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<UserUnbannedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UserUnbannedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserUnbannedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserUnbannedEvent> mapFromJson(dynamic json) {
    final map = <String, UserUnbannedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserUnbannedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserUnbannedEvent-objects as value to a dart map
  static Map<String, List<UserUnbannedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UserUnbannedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserUnbannedEvent.listFromJson(
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
    'type',
    'user',
  };
}
