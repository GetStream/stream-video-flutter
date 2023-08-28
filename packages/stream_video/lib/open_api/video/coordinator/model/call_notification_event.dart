//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallNotificationEvent {
  /// Returns a new [CallNotificationEvent] instance.
  CallNotificationEvent({
    required this.call,
    required this.callCid,
    required this.createdAt,
    this.members = const [],
    required this.sessionId,
    this.type = 'call.notification',
    required this.user,
  });

  CallResponse call;

  String callCid;

  DateTime createdAt;

  /// Call members
  List<MemberResponse> members;

  /// Call session ID
  String sessionId;

  /// The type of event: \"call.notification\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallNotificationEvent &&
     other.call == call &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.members == members &&
     other.sessionId == sessionId &&
     other.type == type &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (members.hashCode) +
    (sessionId.hashCode) +
    (type.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'CallNotificationEvent[call=$call, callCid=$callCid, createdAt=$createdAt, members=$members, sessionId=$sessionId, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'members'] = this.members;
      json[r'session_id'] = this.sessionId;
      json[r'type'] = this.type;
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallNotificationEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallNotificationEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallNotificationEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallNotificationEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallNotificationEvent(
        call: CallResponse.fromJson(json[r'call'])!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        members: MemberResponse.listFromJson(json[r'members']),
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallNotificationEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallNotificationEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallNotificationEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallNotificationEvent> mapFromJson(dynamic json) {
    final map = <String, CallNotificationEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallNotificationEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallNotificationEvent-objects as value to a dart map
  static Map<String, List<CallNotificationEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallNotificationEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallNotificationEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'call_cid',
    'created_at',
    'members',
    'session_id',
    'type',
    'user',
  };
}

