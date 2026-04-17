//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallSessionParticipantStatsTimelineResponse {
  /// Returns a new [QueryCallSessionParticipantStatsTimelineResponse] instance.
  QueryCallSessionParticipantStatsTimelineResponse({
    required this.callId,
    required this.callSessionId,
    required this.callType,
    required this.duration,
    this.events = const [],
    required this.userId,
    required this.userSessionId,
  });

  String callId;

  String callSessionId;

  String callType;

  /// Duration of the request in milliseconds
  String duration;

  List<CallParticipantTimeline> events;

  String userId;

  String userSessionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryCallSessionParticipantStatsTimelineResponse &&
          other.callId == callId &&
          other.callSessionId == callSessionId &&
          other.callType == callType &&
          other.duration == duration &&
          _deepEquality.equals(other.events, events) &&
          other.userId == userId &&
          other.userSessionId == userSessionId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callId.hashCode) +
      (callSessionId.hashCode) +
      (callType.hashCode) +
      (duration.hashCode) +
      (events.hashCode) +
      (userId.hashCode) +
      (userSessionId.hashCode);

  @override
  String toString() =>
      'QueryCallSessionParticipantStatsTimelineResponse[callId=$callId, callSessionId=$callSessionId, callType=$callType, duration=$duration, events=$events, userId=$userId, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_id'] = this.callId;
    json[r'call_session_id'] = this.callSessionId;
    json[r'call_type'] = this.callType;
    json[r'duration'] = this.duration;
    json[r'events'] = this.events;
    json[r'user_id'] = this.userId;
    json[r'user_session_id'] = this.userSessionId;
    return json;
  }

  /// Returns a new [QueryCallSessionParticipantStatsTimelineResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallSessionParticipantStatsTimelineResponse? fromJson(
      dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_session_id'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_session_id]" is missing from JSON.');
        assert(json[r'call_session_id'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_session_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[duration]" has a null value in JSON.');
        assert(json.containsKey(r'events'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[events]" is missing from JSON.');
        assert(json[r'events'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[events]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'user_session_id'),
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[user_session_id]" is missing from JSON.');
        assert(json[r'user_session_id'] != null,
            'Required key "QueryCallSessionParticipantStatsTimelineResponse[user_session_id]" has a null value in JSON.');
        return true;
      }());

      return QueryCallSessionParticipantStatsTimelineResponse(
        callId: mapValueOfType<String>(json, r'call_id')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callType: mapValueOfType<String>(json, r'call_type')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        events: CallParticipantTimeline.listFromJson(json[r'events']),
        userId: mapValueOfType<String>(json, r'user_id')!,
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
      );
    }
    return null;
  }

  static List<QueryCallSessionParticipantStatsTimelineResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryCallSessionParticipantStatsTimelineResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            QueryCallSessionParticipantStatsTimelineResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallSessionParticipantStatsTimelineResponse>
      mapFromJson(dynamic json) {
    final map = <String, QueryCallSessionParticipantStatsTimelineResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryCallSessionParticipantStatsTimelineResponse.fromJson(
            entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallSessionParticipantStatsTimelineResponse-objects as value to a dart map
  static Map<String, List<QueryCallSessionParticipantStatsTimelineResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map =
        <String, List<QueryCallSessionParticipantStatsTimelineResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] =
            QueryCallSessionParticipantStatsTimelineResponse.listFromJson(
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
    'events',
    'user_id',
    'user_session_id',
  };
}
