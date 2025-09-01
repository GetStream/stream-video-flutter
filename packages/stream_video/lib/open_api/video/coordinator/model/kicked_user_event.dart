//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class KickedUserEvent {
  /// Returns a new [KickedUserEvent] instance.
  KickedUserEvent({
    required this.callCid,
    required this.createdAt,
    this.kickedByUser,
    this.type = 'call.kicked_user',
    required this.user,
  });

  String callCid;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponse? kickedByUser;

  /// The type of event: \"call.kicked_user\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KickedUserEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.kickedByUser == kickedByUser &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (kickedByUser == null ? 0 : kickedByUser!.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'KickedUserEvent[callCid=$callCid, createdAt=$createdAt, kickedByUser=$kickedByUser, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.kickedByUser != null) {
      json[r'kicked_by_user'] = this.kickedByUser;
    } else {
      json[r'kicked_by_user'] = null;
    }
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [KickedUserEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static KickedUserEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "KickedUserEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "KickedUserEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return KickedUserEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        kickedByUser: UserResponse.fromJson(json[r'kicked_by_user']),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<KickedUserEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <KickedUserEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = KickedUserEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, KickedUserEvent> mapFromJson(dynamic json) {
    final map = <String, KickedUserEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = KickedUserEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of KickedUserEvent-objects as value to a dart map
  static Map<String, List<KickedUserEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<KickedUserEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = KickedUserEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'type',
    'user',
  };
}
