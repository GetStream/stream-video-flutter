//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserUpdatedEvent {
  /// Returns a new [UserUpdatedEvent] instance.
  UserUpdatedEvent({
    required this.createdAt,
    this.receivedAt,
    this.type = 'user.updated',
    required this.user,
  });

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  String type;

  UserEventPayload user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserUpdatedEvent &&
    other.createdAt == createdAt &&
    other.receivedAt == receivedAt &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (receivedAt == null ? 0 : receivedAt!.hashCode) +
    (type.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'UserUpdatedEvent[createdAt=$createdAt, receivedAt=$receivedAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
      json[r'type'] = this.type;
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [UserUpdatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserUpdatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserUpdatedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserUpdatedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserUpdatedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserEventPayload.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<UserUpdatedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserUpdatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserUpdatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserUpdatedEvent> mapFromJson(dynamic json) {
    final map = <String, UserUpdatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserUpdatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserUpdatedEvent-objects as value to a dart map
  static Map<String, List<UserUpdatedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserUpdatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserUpdatedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'type',
    'user',
  };
}

