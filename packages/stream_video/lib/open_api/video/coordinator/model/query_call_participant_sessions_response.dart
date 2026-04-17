//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallParticipantSessionsResponse {
  /// Returns a new [QueryCallParticipantSessionsResponse] instance.
  QueryCallParticipantSessionsResponse({
    required this.callId,
    required this.callSessionId,
    required this.callType,
    required this.duration,
    this.next,
    this.participantsSessions = const [],
    this.prev,
    this.session,
    required this.totalParticipantDuration,
    required this.totalParticipantSessions,
  });

  String callId;

  String callSessionId;

  String callType;

  /// Duration of the request in milliseconds
  int duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? next;

  List<ParticipantSessionDetails> participantsSessions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? prev;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallSessionResponse? session;

  int totalParticipantDuration;

  int totalParticipantSessions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryCallParticipantSessionsResponse &&
          other.callId == callId &&
          other.callSessionId == callSessionId &&
          other.callType == callType &&
          other.duration == duration &&
          other.next == next &&
          _deepEquality.equals(
              other.participantsSessions, participantsSessions) &&
          other.prev == prev &&
          other.session == session &&
          other.totalParticipantDuration == totalParticipantDuration &&
          other.totalParticipantSessions == totalParticipantSessions;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callId.hashCode) +
      (callSessionId.hashCode) +
      (callType.hashCode) +
      (duration.hashCode) +
      (next == null ? 0 : next!.hashCode) +
      (participantsSessions.hashCode) +
      (prev == null ? 0 : prev!.hashCode) +
      (session == null ? 0 : session!.hashCode) +
      (totalParticipantDuration.hashCode) +
      (totalParticipantSessions.hashCode);

  @override
  String toString() =>
      'QueryCallParticipantSessionsResponse[callId=$callId, callSessionId=$callSessionId, callType=$callType, duration=$duration, next=$next, participantsSessions=$participantsSessions, prev=$prev, session=$session, totalParticipantDuration=$totalParticipantDuration, totalParticipantSessions=$totalParticipantSessions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_id'] = this.callId;
    json[r'call_session_id'] = this.callSessionId;
    json[r'call_type'] = this.callType;
    json[r'duration'] = this.duration;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
    json[r'participants_sessions'] = this.participantsSessions;
    if (this.prev != null) {
      json[r'prev'] = this.prev;
    } else {
      json[r'prev'] = null;
    }
    if (this.session != null) {
      json[r'session'] = this.session;
    } else {
      json[r'session'] = null;
    }
    json[r'total_participant_duration'] = this.totalParticipantDuration;
    json[r'total_participant_sessions'] = this.totalParticipantSessions;
    return json;
  }

  /// Returns a new [QueryCallParticipantSessionsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallParticipantSessionsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "QueryCallParticipantSessionsResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "QueryCallParticipantSessionsResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_session_id'),
            'Required key "QueryCallParticipantSessionsResponse[call_session_id]" is missing from JSON.');
        assert(json[r'call_session_id'] != null,
            'Required key "QueryCallParticipantSessionsResponse[call_session_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "QueryCallParticipantSessionsResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "QueryCallParticipantSessionsResponse[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "QueryCallParticipantSessionsResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "QueryCallParticipantSessionsResponse[duration]" has a null value in JSON.');
        assert(json.containsKey(r'participants_sessions'),
            'Required key "QueryCallParticipantSessionsResponse[participants_sessions]" is missing from JSON.');
        assert(json[r'participants_sessions'] != null,
            'Required key "QueryCallParticipantSessionsResponse[participants_sessions]" has a null value in JSON.');
        assert(json.containsKey(r'total_participant_duration'),
            'Required key "QueryCallParticipantSessionsResponse[total_participant_duration]" is missing from JSON.');
        assert(json[r'total_participant_duration'] != null,
            'Required key "QueryCallParticipantSessionsResponse[total_participant_duration]" has a null value in JSON.');
        assert(json.containsKey(r'total_participant_sessions'),
            'Required key "QueryCallParticipantSessionsResponse[total_participant_sessions]" is missing from JSON.');
        assert(json[r'total_participant_sessions'] != null,
            'Required key "QueryCallParticipantSessionsResponse[total_participant_sessions]" has a null value in JSON.');
        return true;
      }());

      return QueryCallParticipantSessionsResponse(
        callId: mapValueOfType<String>(json, r'call_id')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callType: mapValueOfType<String>(json, r'call_type')!,
        duration: mapValueOfType<int>(json, r'duration')!,
        next: mapValueOfType<String>(json, r'next'),
        participantsSessions: ParticipantSessionDetails.listFromJson(
            json[r'participants_sessions']),
        prev: mapValueOfType<String>(json, r'prev'),
        session: CallSessionResponse.fromJson(json[r'session']),
        totalParticipantDuration:
            mapValueOfType<int>(json, r'total_participant_duration')!,
        totalParticipantSessions:
            mapValueOfType<int>(json, r'total_participant_sessions')!,
      );
    }
    return null;
  }

  static List<QueryCallParticipantSessionsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryCallParticipantSessionsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallParticipantSessionsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallParticipantSessionsResponse> mapFromJson(
      dynamic json) {
    final map = <String, QueryCallParticipantSessionsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            QueryCallParticipantSessionsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallParticipantSessionsResponse-objects as value to a dart map
  static Map<String, List<QueryCallParticipantSessionsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<QueryCallParticipantSessionsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallParticipantSessionsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_id',
    'call_session_id',
    'call_type',
    'duration',
    'participants_sessions',
    'total_participant_duration',
    'total_participant_sessions',
  };
}
