//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallSessionParticipantStatsResponse {
  /// Returns a new [QueryCallSessionParticipantStatsResponse] instance.
  QueryCallSessionParticipantStatsResponse({
    this.callEndedAt,
    this.callEvents = const [],
    required this.callId,
    required this.callSessionId,
    this.callStartedAt,
    required this.callType,
    required this.counts,
    required this.duration,
    this.next,
    this.participants = const [],
    this.prev,
    this.tmpDataSource,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? callEndedAt;

  List<CallLevelEventPayload> callEvents;

  String callId;

  String callSessionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? callStartedAt;

  String callType;

  CallStatsParticipantCounts counts;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? next;

  List<CallStatsParticipant> participants;

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
  String? tmpDataSource;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryCallSessionParticipantStatsResponse &&
          other.callEndedAt == callEndedAt &&
          _deepEquality.equals(other.callEvents, callEvents) &&
          other.callId == callId &&
          other.callSessionId == callSessionId &&
          other.callStartedAt == callStartedAt &&
          other.callType == callType &&
          other.counts == counts &&
          other.duration == duration &&
          other.next == next &&
          _deepEquality.equals(other.participants, participants) &&
          other.prev == prev &&
          other.tmpDataSource == tmpDataSource;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callEndedAt == null ? 0 : callEndedAt!.hashCode) +
      (callEvents.hashCode) +
      (callId.hashCode) +
      (callSessionId.hashCode) +
      (callStartedAt == null ? 0 : callStartedAt!.hashCode) +
      (callType.hashCode) +
      (counts.hashCode) +
      (duration.hashCode) +
      (next == null ? 0 : next!.hashCode) +
      (participants.hashCode) +
      (prev == null ? 0 : prev!.hashCode) +
      (tmpDataSource == null ? 0 : tmpDataSource!.hashCode);

  @override
  String toString() =>
      'QueryCallSessionParticipantStatsResponse[callEndedAt=$callEndedAt, callEvents=$callEvents, callId=$callId, callSessionId=$callSessionId, callStartedAt=$callStartedAt, callType=$callType, counts=$counts, duration=$duration, next=$next, participants=$participants, prev=$prev, tmpDataSource=$tmpDataSource]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callEndedAt != null) {
      json[r'call_ended_at'] = this.callEndedAt!.toUtc().toIso8601String();
    } else {
      json[r'call_ended_at'] = null;
    }
    json[r'call_events'] = this.callEvents;
    json[r'call_id'] = this.callId;
    json[r'call_session_id'] = this.callSessionId;
    if (this.callStartedAt != null) {
      json[r'call_started_at'] = this.callStartedAt!.toUtc().toIso8601String();
    } else {
      json[r'call_started_at'] = null;
    }
    json[r'call_type'] = this.callType;
    json[r'counts'] = this.counts;
    json[r'duration'] = this.duration;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
    json[r'participants'] = this.participants;
    if (this.prev != null) {
      json[r'prev'] = this.prev;
    } else {
      json[r'prev'] = null;
    }
    if (this.tmpDataSource != null) {
      json[r'tmp_data_source'] = this.tmpDataSource;
    } else {
      json[r'tmp_data_source'] = null;
    }
    return json;
  }

  /// Returns a new [QueryCallSessionParticipantStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallSessionParticipantStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "QueryCallSessionParticipantStatsResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_session_id'),
            'Required key "QueryCallSessionParticipantStatsResponse[call_session_id]" is missing from JSON.');
        assert(json[r'call_session_id'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[call_session_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "QueryCallSessionParticipantStatsResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'counts'),
            'Required key "QueryCallSessionParticipantStatsResponse[counts]" is missing from JSON.');
        assert(json[r'counts'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[counts]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "QueryCallSessionParticipantStatsResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[duration]" has a null value in JSON.');
        assert(json.containsKey(r'participants'),
            'Required key "QueryCallSessionParticipantStatsResponse[participants]" is missing from JSON.');
        assert(json[r'participants'] != null,
            'Required key "QueryCallSessionParticipantStatsResponse[participants]" has a null value in JSON.');
        return true;
      }());

      return QueryCallSessionParticipantStatsResponse(
        callEndedAt: mapDateTime(json, r'call_ended_at', r''),
        callEvents: CallLevelEventPayload.listFromJson(json[r'call_events']),
        callId: mapValueOfType<String>(json, r'call_id')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callStartedAt: mapDateTime(json, r'call_started_at', r''),
        callType: mapValueOfType<String>(json, r'call_type')!,
        counts: CallStatsParticipantCounts.fromJson(json[r'counts'])!,
        duration: mapValueOfType<String>(json, r'duration')!,
        next: mapValueOfType<String>(json, r'next'),
        participants: CallStatsParticipant.listFromJson(json[r'participants']),
        prev: mapValueOfType<String>(json, r'prev'),
        tmpDataSource: mapValueOfType<String>(json, r'tmp_data_source'),
      );
    }
    return null;
  }

  static List<QueryCallSessionParticipantStatsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryCallSessionParticipantStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallSessionParticipantStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallSessionParticipantStatsResponse> mapFromJson(
      dynamic json) {
    final map = <String, QueryCallSessionParticipantStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            QueryCallSessionParticipantStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallSessionParticipantStatsResponse-objects as value to a dart map
  static Map<String, List<QueryCallSessionParticipantStatsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<QueryCallSessionParticipantStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallSessionParticipantStatsResponse.listFromJson(
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
    'counts',
    'duration',
    'participants',
  };
}
