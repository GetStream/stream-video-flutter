//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsParticipantCounts {
  /// Returns a new [CallStatsParticipantCounts] instance.
  CallStatsParticipantCounts({
    this.callEventCount,
    this.cqScore,
    required this.liveSessions,
    required this.participants,
    required this.peakConcurrentSessions,
    required this.peakConcurrentUsers,
    required this.publishers,
    required this.sessions,
    this.totalParticipantDuration,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? callEventCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? cqScore;

  int liveSessions;

  int participants;

  int peakConcurrentSessions;

  int peakConcurrentUsers;

  int publishers;

  int sessions;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalParticipantDuration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsParticipantCounts &&
          other.callEventCount == callEventCount &&
          other.cqScore == cqScore &&
          other.liveSessions == liveSessions &&
          other.participants == participants &&
          other.peakConcurrentSessions == peakConcurrentSessions &&
          other.peakConcurrentUsers == peakConcurrentUsers &&
          other.publishers == publishers &&
          other.sessions == sessions &&
          other.totalParticipantDuration == totalParticipantDuration;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callEventCount == null ? 0 : callEventCount!.hashCode) +
      (cqScore == null ? 0 : cqScore!.hashCode) +
      (liveSessions.hashCode) +
      (participants.hashCode) +
      (peakConcurrentSessions.hashCode) +
      (peakConcurrentUsers.hashCode) +
      (publishers.hashCode) +
      (sessions.hashCode) +
      (totalParticipantDuration == null
          ? 0
          : totalParticipantDuration!.hashCode);

  @override
  String toString() =>
      'CallStatsParticipantCounts[callEventCount=$callEventCount, cqScore=$cqScore, liveSessions=$liveSessions, participants=$participants, peakConcurrentSessions=$peakConcurrentSessions, peakConcurrentUsers=$peakConcurrentUsers, publishers=$publishers, sessions=$sessions, totalParticipantDuration=$totalParticipantDuration]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callEventCount != null) {
      json[r'call_event_count'] = this.callEventCount;
    } else {
      json[r'call_event_count'] = null;
    }
    if (this.cqScore != null) {
      json[r'cq_score'] = this.cqScore;
    } else {
      json[r'cq_score'] = null;
    }
    json[r'live_sessions'] = this.liveSessions;
    json[r'participants'] = this.participants;
    json[r'peak_concurrent_sessions'] = this.peakConcurrentSessions;
    json[r'peak_concurrent_users'] = this.peakConcurrentUsers;
    json[r'publishers'] = this.publishers;
    json[r'sessions'] = this.sessions;
    if (this.totalParticipantDuration != null) {
      json[r'total_participant_duration'] = this.totalParticipantDuration;
    } else {
      json[r'total_participant_duration'] = null;
    }
    return json;
  }

  /// Returns a new [CallStatsParticipantCounts] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsParticipantCounts? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'live_sessions'),
            'Required key "CallStatsParticipantCounts[live_sessions]" is missing from JSON.');
        assert(json[r'live_sessions'] != null,
            'Required key "CallStatsParticipantCounts[live_sessions]" has a null value in JSON.');
        assert(json.containsKey(r'participants'),
            'Required key "CallStatsParticipantCounts[participants]" is missing from JSON.');
        assert(json[r'participants'] != null,
            'Required key "CallStatsParticipantCounts[participants]" has a null value in JSON.');
        assert(json.containsKey(r'peak_concurrent_sessions'),
            'Required key "CallStatsParticipantCounts[peak_concurrent_sessions]" is missing from JSON.');
        assert(json[r'peak_concurrent_sessions'] != null,
            'Required key "CallStatsParticipantCounts[peak_concurrent_sessions]" has a null value in JSON.');
        assert(json.containsKey(r'peak_concurrent_users'),
            'Required key "CallStatsParticipantCounts[peak_concurrent_users]" is missing from JSON.');
        assert(json[r'peak_concurrent_users'] != null,
            'Required key "CallStatsParticipantCounts[peak_concurrent_users]" has a null value in JSON.');
        assert(json.containsKey(r'publishers'),
            'Required key "CallStatsParticipantCounts[publishers]" is missing from JSON.');
        assert(json[r'publishers'] != null,
            'Required key "CallStatsParticipantCounts[publishers]" has a null value in JSON.');
        assert(json.containsKey(r'sessions'),
            'Required key "CallStatsParticipantCounts[sessions]" is missing from JSON.');
        assert(json[r'sessions'] != null,
            'Required key "CallStatsParticipantCounts[sessions]" has a null value in JSON.');
        return true;
      }());

      return CallStatsParticipantCounts(
        callEventCount: mapValueOfType<int>(json, r'call_event_count'),
        cqScore: mapValueOfType<int>(json, r'cq_score'),
        liveSessions: mapValueOfType<int>(json, r'live_sessions')!,
        participants: mapValueOfType<int>(json, r'participants')!,
        peakConcurrentSessions:
            mapValueOfType<int>(json, r'peak_concurrent_sessions')!,
        peakConcurrentUsers:
            mapValueOfType<int>(json, r'peak_concurrent_users')!,
        publishers: mapValueOfType<int>(json, r'publishers')!,
        sessions: mapValueOfType<int>(json, r'sessions')!,
        totalParticipantDuration:
            mapValueOfType<int>(json, r'total_participant_duration'),
      );
    }
    return null;
  }

  static List<CallStatsParticipantCounts> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsParticipantCounts>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsParticipantCounts.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsParticipantCounts> mapFromJson(dynamic json) {
    final map = <String, CallStatsParticipantCounts>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsParticipantCounts.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsParticipantCounts-objects as value to a dart map
  static Map<String, List<CallStatsParticipantCounts>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsParticipantCounts>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsParticipantCounts.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'live_sessions',
    'participants',
    'peak_concurrent_sessions',
    'peak_concurrent_users',
    'publishers',
    'sessions',
  };
}
