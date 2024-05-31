//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserDeactivatedEvent {
  /// Returns a new [UserDeactivatedEvent] instance.
  UserDeactivatedEvent({
    required this.createdAt,
    required this.createdBy,
    this.type = 'user.deactivated',
    this.user,
  });

  DateTime createdAt;

  UserObject createdBy;

  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserObject? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserDeactivatedEvent &&
    other.createdAt == createdAt &&
    other.createdBy == createdBy &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (createdBy.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'UserDeactivatedEvent[createdAt=$createdAt, createdBy=$createdBy, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'created_by'] = this.createdBy;
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [UserDeactivatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserDeactivatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserDeactivatedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserDeactivatedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserDeactivatedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserObject.fromJson(json[r'created_by'])!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<UserDeactivatedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserDeactivatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserDeactivatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserDeactivatedEvent> mapFromJson(dynamic json) {
    final map = <String, UserDeactivatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserDeactivatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserDeactivatedEvent-objects as value to a dart map
  static Map<String, List<UserDeactivatedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserDeactivatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserDeactivatedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'created_by',
    'type',
  };
}

