//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserUnmutedEvent {
  /// Returns a new [UserUnmutedEvent] instance.
  UserUnmutedEvent({
    required this.createdAt,
    this.targetUser,
    this.targetUsers = const [],
    this.type = 'user.unmuted',
    this.user,
  });

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? targetUser;

  List<String> targetUsers;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserUnmutedEvent &&
    other.createdAt == createdAt &&
    other.targetUser == targetUser &&
    _deepEquality.equals(other.targetUsers, targetUsers) &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (targetUser == null ? 0 : targetUser!.hashCode) +
    (targetUsers.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'UserUnmutedEvent[createdAt=$createdAt, targetUser=$targetUser, targetUsers=$targetUsers, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.targetUser != null) {
      json[r'target_user'] = this.targetUser;
    } else {
      json[r'target_user'] = null;
    }
      json[r'target_users'] = this.targetUsers;
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [UserUnmutedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserUnmutedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserUnmutedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserUnmutedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserUnmutedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        targetUser: mapValueOfType<String>(json, r'target_user'),
        targetUsers: json[r'target_users'] is Iterable
            ? (json[r'target_users'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<UserUnmutedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserUnmutedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserUnmutedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserUnmutedEvent> mapFromJson(dynamic json) {
    final map = <String, UserUnmutedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserUnmutedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserUnmutedEvent-objects as value to a dart map
  static Map<String, List<UserUnmutedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserUnmutedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserUnmutedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'type',
  };
}

