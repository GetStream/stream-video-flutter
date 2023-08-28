//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallEndedEvent {
  /// Returns a new [CallEndedEvent] instance.
  CallEndedEvent({
    required this.call,
    required this.callCid,
    required this.createdAt,
    this.type = 'call.ended',
    this.user,
  });

  CallResponse call;

  String callCid;

  DateTime createdAt;

  /// The type of event: \"call.ended\" in this case
  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponse? user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallEndedEvent &&
     other.call == call &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.type == type &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (user == null ? 0 : user!.hashCode);

  @override
  String toString() => 'CallEndedEvent[call=$call, callCid=$callCid, createdAt=$createdAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    return json;
  }

  /// Returns a new [CallEndedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallEndedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallEndedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallEndedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallEndedEvent(
        call: CallResponse.fromJson(json[r'call'])!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user']),
      );
    }
    return null;
  }

  static List<CallEndedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallEndedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallEndedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallEndedEvent> mapFromJson(dynamic json) {
    final map = <String, CallEndedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallEndedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallEndedEvent-objects as value to a dart map
  static Map<String, List<CallEndedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallEndedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallEndedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'call_cid',
    'created_at',
    'type',
  };
}

