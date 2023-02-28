//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallCancelledEvent {
  /// Returns a new [CallCancelledEvent] instance.
  CallCancelledEvent({
    required this.callCid,
    required this.createdAt,
    required this.type,
    required this.user,
  });

  String callCid;

  DateTime createdAt;

  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallCancelledEvent &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.type == type &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'CallCancelledEvent[callCid=$callCid, createdAt=$createdAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallCancelledEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallCancelledEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallCancelledEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallCancelledEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallCancelledEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallCancelledEvent>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallCancelledEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallCancelledEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallCancelledEvent> mapFromJson(dynamic json) {
    final map = <String, CallCancelledEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallCancelledEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallCancelledEvent-objects as value to a dart map
  static Map<String, List<CallCancelledEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallCancelledEvent>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallCancelledEvent.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
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

