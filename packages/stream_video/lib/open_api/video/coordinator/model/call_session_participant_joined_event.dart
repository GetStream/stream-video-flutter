//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallSessionParticipantJoinedEvent {
  /// Returns a new [CallSessionParticipantJoinedEvent] instance.
  CallSessionParticipantJoinedEvent({
    required this.callCid,
    required this.createdAt,
    required this.participant,
    required this.sessionId,
    this.type = 'call.session_participant_joined',
  });

  String callCid;

  DateTime createdAt;

  CallParticipantResponse participant;

  /// Call session ID
  String sessionId;

  /// The type of event: \"call.session_participant_joined\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallSessionParticipantJoinedEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.participant == participant &&
          other.sessionId == sessionId &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (participant.hashCode) +
      (sessionId.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallSessionParticipantJoinedEvent[callCid=$callCid, createdAt=$createdAt, participant=$participant, sessionId=$sessionId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'participant'] = this.participant;
    json[r'session_id'] = this.sessionId;
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallSessionParticipantJoinedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSessionParticipantJoinedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallSessionParticipantJoinedEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallSessionParticipantJoinedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallSessionParticipantJoinedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallSessionParticipantJoinedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallSessionParticipantJoinedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSessionParticipantJoinedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSessionParticipantJoinedEvent> mapFromJson(
      dynamic json) {
    final map = <String, CallSessionParticipantJoinedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSessionParticipantJoinedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSessionParticipantJoinedEvent-objects as value to a dart map
  static Map<String, List<CallSessionParticipantJoinedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallSessionParticipantJoinedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSessionParticipantJoinedEvent.listFromJson(
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
    'participant',
    'session_id',
    'type',
  };
}
