//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserDeletedEvent {
  /// Returns a new [UserDeletedEvent] instance.
  UserDeletedEvent({
    required this.createdAt,
    required this.deleteConversationChannels,
    required this.hardDelete,
    required this.markMessagesDeleted,
    this.type = 'user.deleted',
    this.user,
  });

  DateTime createdAt;

  bool deleteConversationChannels;

  bool hardDelete;

  bool markMessagesDeleted;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserDeletedEvent &&
    other.createdAt == createdAt &&
    other.deleteConversationChannels == deleteConversationChannels &&
    other.hardDelete == hardDelete &&
    other.markMessagesDeleted == markMessagesDeleted &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (deleteConversationChannels.hashCode) +
    (hardDelete.hashCode) +
    (markMessagesDeleted.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'UserDeletedEvent[createdAt=$createdAt, deleteConversationChannels=$deleteConversationChannels, hardDelete=$hardDelete, markMessagesDeleted=$markMessagesDeleted, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'delete_conversation_channels'] = this.deleteConversationChannels;
      json[r'hard_delete'] = this.hardDelete;
      json[r'mark_messages_deleted'] = this.markMessagesDeleted;
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [UserDeletedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserDeletedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserDeletedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserDeletedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserDeletedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        deleteConversationChannels: mapValueOfType<bool>(json, r'delete_conversation_channels')!,
        hardDelete: mapValueOfType<bool>(json, r'hard_delete')!,
        markMessagesDeleted: mapValueOfType<bool>(json, r'mark_messages_deleted')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<UserDeletedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserDeletedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserDeletedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserDeletedEvent> mapFromJson(dynamic json) {
    final map = <String, UserDeletedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserDeletedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserDeletedEvent-objects as value to a dart map
  static Map<String, List<UserDeletedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserDeletedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserDeletedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'delete_conversation_channels',
    'hard_delete',
    'mark_messages_deleted',
    'type',
  };
}

