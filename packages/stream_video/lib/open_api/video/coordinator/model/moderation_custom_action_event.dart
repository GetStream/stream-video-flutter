//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ModerationCustomActionEvent {
  /// Returns a new [ModerationCustomActionEvent] instance.
  ModerationCustomActionEvent({
    required this.createdAt,
    this.item,
    this.message,
    this.type = 'moderation.custom_action',
    this.user,
  });

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ReviewQueueItem? item;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Message? message;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModerationCustomActionEvent &&
    other.createdAt == createdAt &&
    other.item == item &&
    other.message == message &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (item == null ? 0 : item!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'ModerationCustomActionEvent[createdAt=$createdAt, item=$item, message=$message, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.item != null) {
      json[r'item'] = this.item;
    } else {
      json[r'item'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [ModerationCustomActionEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ModerationCustomActionEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ModerationCustomActionEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ModerationCustomActionEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ModerationCustomActionEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        item: ReviewQueueItem.fromJson(json[r'item']),
        message: Message.fromJson(json[r'message']),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<ModerationCustomActionEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ModerationCustomActionEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ModerationCustomActionEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ModerationCustomActionEvent> mapFromJson(dynamic json) {
    final map = <String, ModerationCustomActionEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ModerationCustomActionEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ModerationCustomActionEvent-objects as value to a dart map
  static Map<String, List<ModerationCustomActionEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ModerationCustomActionEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ModerationCustomActionEvent.listFromJson(entry.value, growable: growable,);
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

