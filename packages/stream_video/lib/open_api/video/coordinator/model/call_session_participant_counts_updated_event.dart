//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallSessionParticipantCountsUpdatedEvent {
  /// Returns a new [CallSessionParticipantCountsUpdatedEvent] instance.
  CallSessionParticipantCountsUpdatedEvent({
    required this.anonymousParticipantCount,
    required this.callCid,
    required this.createdAt,
    this.participantsCountByRole = const {},
    required this.sessionId,
    this.type = 'call.session_participant_count_updated',
  });

  int anonymousParticipantCount;

  String callCid;

  DateTime createdAt;

  Map<String, int> participantsCountByRole;

  /// Call session ID
  String sessionId;

  /// The type of event: \"call.session_participant_count_updated\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallSessionParticipantCountsUpdatedEvent &&
    other.anonymousParticipantCount == anonymousParticipantCount &&
    other.callCid == callCid &&
    other.createdAt == createdAt &&
    _deepEquality.equals(other.participantsCountByRole, participantsCountByRole) &&
    other.sessionId == sessionId &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (anonymousParticipantCount.hashCode) +
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (participantsCountByRole.hashCode) +
    (sessionId.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallSessionParticipantCountsUpdatedEvent[anonymousParticipantCount=$anonymousParticipantCount, callCid=$callCid, createdAt=$createdAt, participantsCountByRole=$participantsCountByRole, sessionId=$sessionId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'anonymous_participant_count'] = this.anonymousParticipantCount;
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'participants_count_by_role'] = this.participantsCountByRole;
      json[r'session_id'] = this.sessionId;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallSessionParticipantCountsUpdatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSessionParticipantCountsUpdatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallSessionParticipantCountsUpdatedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallSessionParticipantCountsUpdatedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallSessionParticipantCountsUpdatedEvent(
        anonymousParticipantCount: mapValueOfType<int>(json, r'anonymous_participant_count')!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        participantsCountByRole: mapCastOfType<String, int>(json, r'participants_count_by_role')!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallSessionParticipantCountsUpdatedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSessionParticipantCountsUpdatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSessionParticipantCountsUpdatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSessionParticipantCountsUpdatedEvent> mapFromJson(dynamic json) {
    final map = <String, CallSessionParticipantCountsUpdatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSessionParticipantCountsUpdatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSessionParticipantCountsUpdatedEvent-objects as value to a dart map
  static Map<String, List<CallSessionParticipantCountsUpdatedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallSessionParticipantCountsUpdatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSessionParticipantCountsUpdatedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'anonymous_participant_count',
    'call_cid',
    'created_at',
    'participants_count_by_role',
    'session_id',
    'type',
  };
}

