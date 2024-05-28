//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserBannedEvent {
  /// Returns a new [UserBannedEvent] instance.
  UserBannedEvent({
    required this.channelId,
    required this.channelType,
    required this.cid,
    required this.createdAt,
    required this.createdBy,
    this.expiration,
    this.reason,
    required this.shadow,
    this.team,
    this.type = 'user.banned',
    this.user,
  });

  String channelId;

  String channelType;

  String cid;

  DateTime createdAt;

  UserObject createdBy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  bool shadow;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserBannedEvent &&
    other.channelId == channelId &&
    other.channelType == channelType &&
    other.cid == cid &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    other.expiration == expiration &&
    other.reason == reason &&
    other.shadow == shadow &&
    other.team == team &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (channelId.hashCode) +
    (channelType.hashCode) +
    (cid.hashCode) +
    (createdAt.hashCode) +
    (createdBy.hashCode) +
    (expiration == null ? 0 : expiration!.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (shadow.hashCode) +
    (team == null ? 0 : team!.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'UserBannedEvent[channelId=$channelId, channelType=$channelType, cid=$cid, createdAt=$createdAt, createdBy=$createdBy, expiration=$expiration, reason=$reason, shadow=$shadow, team=$team, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'channel_id'] = this.channelId;
      json[r'channel_type'] = this.channelType;
      json[r'cid'] = this.cid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'created_by'] = this.createdBy;
    if (this.expiration != null) {
      json[r'expiration'] = this.expiration!.toUtc().toIso8601String();
    } else {
      json[r'expiration'] = null;
    }
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'shadow'] = this.shadow;
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [UserBannedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserBannedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserBannedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserBannedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserBannedEvent(
        channelId: mapValueOfType<String>(json, r'channel_id')!,
        channelType: mapValueOfType<String>(json, r'channel_type')!,
        cid: mapValueOfType<String>(json, r'cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by'])!,
        expiration: mapDateTime(json, r'expiration', r''),
        reason: mapValueOfType<String>(json, r'reason'),
        shadow: mapValueOfType<bool>(json, r'shadow')!,
        team: mapValueOfType<String>(json, r'team'),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<UserBannedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserBannedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserBannedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserBannedEvent> mapFromJson(dynamic json) {
    final map = <String, UserBannedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserBannedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserBannedEvent-objects as value to a dart map
  static Map<String, List<UserBannedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserBannedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserBannedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'channel_id',
    'channel_type',
    'cid',
    'created_at',
    'created_by',
    'shadow',
    'type',
  };
}

