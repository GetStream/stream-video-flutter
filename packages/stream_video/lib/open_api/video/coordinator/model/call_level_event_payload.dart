//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallLevelEventPayload {
  /// Returns a new [CallLevelEventPayload] instance.
  CallLevelEventPayload({
    required this.eventType,
    this.payload = const {},
    required this.timestamp,
    required this.userId,
  });

  String eventType;

  Map<String, Object> payload;

  int timestamp;

  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallLevelEventPayload &&
          other.eventType == eventType &&
          _deepEquality.equals(other.payload, payload) &&
          other.timestamp == timestamp &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (eventType.hashCode) +
      (payload.hashCode) +
      (timestamp.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'CallLevelEventPayload[eventType=$eventType, payload=$payload, timestamp=$timestamp, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'event_type'] = this.eventType;
    json[r'payload'] = this.payload;
    json[r'timestamp'] = this.timestamp;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [CallLevelEventPayload] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallLevelEventPayload? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'event_type'),
            'Required key "CallLevelEventPayload[event_type]" is missing from JSON.');
        assert(json[r'event_type'] != null,
            'Required key "CallLevelEventPayload[event_type]" has a null value in JSON.');
        assert(json.containsKey(r'timestamp'),
            'Required key "CallLevelEventPayload[timestamp]" is missing from JSON.');
        assert(json[r'timestamp'] != null,
            'Required key "CallLevelEventPayload[timestamp]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "CallLevelEventPayload[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "CallLevelEventPayload[user_id]" has a null value in JSON.');
        return true;
      }());

      return CallLevelEventPayload(
        eventType: mapValueOfType<String>(json, r'event_type')!,
        payload: mapCastOfType<String, Object>(json, r'payload') ?? const {},
        timestamp: mapValueOfType<int>(json, r'timestamp')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<CallLevelEventPayload> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallLevelEventPayload>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallLevelEventPayload.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallLevelEventPayload> mapFromJson(dynamic json) {
    final map = <String, CallLevelEventPayload>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallLevelEventPayload.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallLevelEventPayload-objects as value to a dart map
  static Map<String, List<CallLevelEventPayload>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallLevelEventPayload>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallLevelEventPayload.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'event_type',
    'timestamp',
    'user_id',
  };
}
