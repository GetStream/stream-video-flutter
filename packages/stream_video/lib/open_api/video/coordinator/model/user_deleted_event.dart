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
    this.custom = const {},
    required this.deleteConversation,
    required this.deleteConversationChannels,
    required this.deleteMessages,
    required this.deleteUser,
    required this.hardDelete,
    required this.markMessagesDeleted,
    this.receivedAt,
    this.type = 'user.deleted',
    required this.user,
  });

  /// Date/time of creation
  DateTime createdAt;

  Map<String, Object> custom;

  /// The type of deletion that was used for the user's conversations. One of: hard, soft, pruning, (empty string)
  String deleteConversation;

  /// Whether the user's conversation channels were deleted
  bool deleteConversationChannels;

  /// The type of deletion that was used for the user's messages. One of: hard, soft, pruning, (empty string)
  String deleteMessages;

  /// The type of deletion that was used for the user. One of: hard, soft, pruning, (empty string)
  String deleteUser;

  /// Whether the user was hard deleted
  bool hardDelete;

  /// Whether the user's messages were marked as deleted
  bool markMessagesDeleted;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  /// The type of event: \"user.deleted\" in this case
  String type;

  UserResponseCommonFields user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDeletedEvent &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.deleteConversation == deleteConversation &&
          other.deleteConversationChannels == deleteConversationChannels &&
          other.deleteMessages == deleteMessages &&
          other.deleteUser == deleteUser &&
          other.hardDelete == hardDelete &&
          other.markMessagesDeleted == markMessagesDeleted &&
          other.receivedAt == receivedAt &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (createdAt.hashCode) +
      (custom.hashCode) +
      (deleteConversation.hashCode) +
      (deleteConversationChannels.hashCode) +
      (deleteMessages.hashCode) +
      (deleteUser.hashCode) +
      (hardDelete.hashCode) +
      (markMessagesDeleted.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'UserDeletedEvent[createdAt=$createdAt, custom=$custom, deleteConversation=$deleteConversation, deleteConversationChannels=$deleteConversationChannels, deleteMessages=$deleteMessages, deleteUser=$deleteUser, hardDelete=$hardDelete, markMessagesDeleted=$markMessagesDeleted, receivedAt=$receivedAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    json[r'delete_conversation'] = this.deleteConversation;
    json[r'delete_conversation_channels'] = this.deleteConversationChannels;
    json[r'delete_messages'] = this.deleteMessages;
    json[r'delete_user'] = this.deleteUser;
    json[r'hard_delete'] = this.hardDelete;
    json[r'mark_messages_deleted'] = this.markMessagesDeleted;
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
    json[r'type'] = this.type;
    json[r'user'] = this.user;
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
        assert(json.containsKey(r'created_at'),
            'Required key "UserDeletedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "UserDeletedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'custom'),
            'Required key "UserDeletedEvent[custom]" is missing from JSON.');
        assert(json[r'custom'] != null,
            'Required key "UserDeletedEvent[custom]" has a null value in JSON.');
        assert(json.containsKey(r'delete_conversation'),
            'Required key "UserDeletedEvent[delete_conversation]" is missing from JSON.');
        assert(json[r'delete_conversation'] != null,
            'Required key "UserDeletedEvent[delete_conversation]" has a null value in JSON.');
        assert(json.containsKey(r'delete_conversation_channels'),
            'Required key "UserDeletedEvent[delete_conversation_channels]" is missing from JSON.');
        assert(json[r'delete_conversation_channels'] != null,
            'Required key "UserDeletedEvent[delete_conversation_channels]" has a null value in JSON.');
        assert(json.containsKey(r'delete_messages'),
            'Required key "UserDeletedEvent[delete_messages]" is missing from JSON.');
        assert(json[r'delete_messages'] != null,
            'Required key "UserDeletedEvent[delete_messages]" has a null value in JSON.');
        assert(json.containsKey(r'delete_user'),
            'Required key "UserDeletedEvent[delete_user]" is missing from JSON.');
        assert(json[r'delete_user'] != null,
            'Required key "UserDeletedEvent[delete_user]" has a null value in JSON.');
        assert(json.containsKey(r'hard_delete'),
            'Required key "UserDeletedEvent[hard_delete]" is missing from JSON.');
        assert(json[r'hard_delete'] != null,
            'Required key "UserDeletedEvent[hard_delete]" has a null value in JSON.');
        assert(json.containsKey(r'mark_messages_deleted'),
            'Required key "UserDeletedEvent[mark_messages_deleted]" is missing from JSON.');
        assert(json[r'mark_messages_deleted'] != null,
            'Required key "UserDeletedEvent[mark_messages_deleted]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "UserDeletedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "UserDeletedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "UserDeletedEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "UserDeletedEvent[user]" has a null value in JSON.');
        return true;
      }());

      return UserDeletedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deleteConversation:
            mapValueOfType<String>(json, r'delete_conversation')!,
        deleteConversationChannels:
            mapValueOfType<bool>(json, r'delete_conversation_channels')!,
        deleteMessages: mapValueOfType<String>(json, r'delete_messages')!,
        deleteUser: mapValueOfType<String>(json, r'delete_user')!,
        hardDelete: mapValueOfType<bool>(json, r'hard_delete')!,
        markMessagesDeleted:
            mapValueOfType<bool>(json, r'mark_messages_deleted')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponseCommonFields.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<UserDeletedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
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
  static Map<String, List<UserDeletedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UserDeletedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserDeletedEvent.listFromJson(
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
    'delete_conversation',
    'delete_conversation_channels',
    'delete_messages',
    'delete_user',
    'hard_delete',
    'mark_messages_deleted',
    'type',
    'user',
  };
}
