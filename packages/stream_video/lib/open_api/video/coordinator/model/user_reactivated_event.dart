//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserReactivatedEvent {
  /// Returns a new [UserReactivatedEvent] instance.
  UserReactivatedEvent({
    required this.createdAt,
    this.createdBy,
    this.custom = const {},
    this.receivedAt,
    this.type = 'user.reactivated',
    required this.user,
  });

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

  /// The type of event: \"user.reactivated\" in this case
  String type;

  UserResponseCommonFields user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserReactivatedEvent &&
          other.createdAt == createdAt &&
          other.createdBy == createdBy &&
          _deepEquality.equals(other.custom, custom) &&
          other.receivedAt == receivedAt &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (createdAt.hashCode) +
      (createdBy == null ? 0 : createdBy!.hashCode) +
      (custom.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'UserReactivatedEvent[createdAt=$createdAt, createdBy=$createdBy, custom=$custom, receivedAt=$receivedAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [UserReactivatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserReactivatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'created_at'),
            'Required key "UserReactivatedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "UserReactivatedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'custom'),
            'Required key "UserReactivatedEvent[custom]" is missing from JSON.');
        assert(json[r'custom'] != null,
            'Required key "UserReactivatedEvent[custom]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "UserReactivatedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "UserReactivatedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "UserReactivatedEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "UserReactivatedEvent[user]" has a null value in JSON.');
        return true;
      }());

      return UserReactivatedEvent(
        createdAt: mapDateTime(json, r'created_at', r'')!,
        createdBy: UserResponseCommonFields.fromJson(json[r'created_by']),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponseCommonFields.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<UserReactivatedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <UserReactivatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserReactivatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserReactivatedEvent> mapFromJson(dynamic json) {
    final map = <String, UserReactivatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserReactivatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserReactivatedEvent-objects as value to a dart map
  static Map<String, List<UserReactivatedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<UserReactivatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserReactivatedEvent.listFromJson(
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
