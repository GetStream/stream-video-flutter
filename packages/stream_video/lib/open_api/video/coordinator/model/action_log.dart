//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ActionLog {
  /// Returns a new [ActionLog] instance.
  ActionLog({
    required this.createdAt,
    this.custom = const {},
    required this.id,
    required this.reason,
    this.reviewQueueItem,
    required this.reviewQueueItemId,
    this.targetUser,
    required this.targetUserId,
    required this.type,
    this.user,
  });

  DateTime createdAt;

  Map<String, Object> custom;

  String id;

  String reason;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ReviewQueueItem? reviewQueueItem;

  String reviewQueueItemId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? targetUser;

  String targetUserId;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ActionLog &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.custom, custom) &&
    other.id == id &&
    other.reason == reason &&
    other.reviewQueueItem == reviewQueueItem &&
    other.reviewQueueItemId == reviewQueueItemId &&
    other.targetUser == targetUser &&
    other.targetUserId == targetUserId &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (custom.hashCode) +
    (id.hashCode) +
    (reason.hashCode) +
    (reviewQueueItem == null ? 0 : reviewQueueItem!.hashCode) +
    (reviewQueueItemId.hashCode) +
    (targetUser == null ? 0 : targetUser!.hashCode) +
    (targetUserId.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'ActionLog[createdAt=$createdAt, custom=$custom, id=$id, reason=$reason, reviewQueueItem=$reviewQueueItem, reviewQueueItemId=$reviewQueueItemId, targetUser=$targetUser, targetUserId=$targetUserId, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
      json[r'id'] = this.id;
      json[r'reason'] = this.reason;
    if (this.reviewQueueItem != null) {
      json[r'review_queue_item'] = this.reviewQueueItem;
    } else {
      json[r'review_queue_item'] = null;
    }
      json[r'review_queue_item_id'] = this.reviewQueueItemId;
    if (this.targetUser != null) {
      json[r'target_user'] = this.targetUser;
    } else {
      json[r'target_user'] = null;
    }
      json[r'target_user_id'] = this.targetUserId;
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [ActionLog] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ActionLog? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ActionLog[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ActionLog[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ActionLog(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        id: mapValueOfType<String>(json, r'id')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        reviewQueueItem: ReviewQueueItem.fromJson(json[r'review_queue_item']),
        reviewQueueItemId: mapValueOfType<String>(json, r'review_queue_item_id')!,
        targetUser: UserObject.fromJson(json[r'target_user']),
        targetUserId: mapValueOfType<String>(json, r'target_user_id')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<ActionLog> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ActionLog>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ActionLog.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ActionLog> mapFromJson(dynamic json) {
    final map = <String, ActionLog>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ActionLog.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ActionLog-objects as value to a dart map
  static Map<String, List<ActionLog>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ActionLog>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ActionLog.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'custom',
    'id',
    'reason',
    'review_queue_item_id',
    'target_user_id',
    'type',
  };
}

