//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallStatsMapResponse {
  /// Returns a new [QueryCallStatsMapResponse] instance.
  QueryCallStatsMapResponse({
    this.callEndedAt,
    required this.callId,
    required this.callSessionId,
    this.callStartedAt,
    required this.callType,
    required this.counts,
    this.dataSource,
    required this.duration,
    this.endTime,
    this.generatedAt,
    this.publishers,
    this.sfus,
    this.startTime,
    this.subscribers,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? callEndedAt;

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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? dataSource;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? endTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? generatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallStatsMapPublishers? publishers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallStatsMapSFUs? sfus;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallStatsMapSubscribers? subscribers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryCallStatsMapResponse &&
          other.callEndedAt == callEndedAt &&
          other.callId == callId &&
          other.callSessionId == callSessionId &&
          other.callStartedAt == callStartedAt &&
          other.callType == callType &&
          other.counts == counts &&
          other.dataSource == dataSource &&
          other.duration == duration &&
          other.endTime == endTime &&
          other.generatedAt == generatedAt &&
          other.publishers == publishers &&
          other.sfus == sfus &&
          other.startTime == startTime &&
          other.subscribers == subscribers;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callEndedAt == null ? 0 : callEndedAt!.hashCode) +
      (callId.hashCode) +
      (callSessionId.hashCode) +
      (callStartedAt == null ? 0 : callStartedAt!.hashCode) +
      (callType.hashCode) +
      (counts.hashCode) +
      (dataSource == null ? 0 : dataSource!.hashCode) +
      (duration.hashCode) +
      (endTime == null ? 0 : endTime!.hashCode) +
      (generatedAt == null ? 0 : generatedAt!.hashCode) +
      (publishers == null ? 0 : publishers!.hashCode) +
      (sfus == null ? 0 : sfus!.hashCode) +
      (startTime == null ? 0 : startTime!.hashCode) +
      (subscribers == null ? 0 : subscribers!.hashCode);

  @override
  String toString() =>
      'QueryCallStatsMapResponse[callEndedAt=$callEndedAt, callId=$callId, callSessionId=$callSessionId, callStartedAt=$callStartedAt, callType=$callType, counts=$counts, dataSource=$dataSource, duration=$duration, endTime=$endTime, generatedAt=$generatedAt, publishers=$publishers, sfus=$sfus, startTime=$startTime, subscribers=$subscribers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callEndedAt != null) {
      json[r'call_ended_at'] = this.callEndedAt!.toUtc().toIso8601String();
    } else {
      json[r'call_ended_at'] = null;
    }
    json[r'call_id'] = this.callId;
    json[r'call_session_id'] = this.callSessionId;
    if (this.callStartedAt != null) {
      json[r'call_started_at'] = this.callStartedAt!.toUtc().toIso8601String();
    } else {
      json[r'call_started_at'] = null;
    }
    json[r'call_type'] = this.callType;
    json[r'counts'] = this.counts;
    if (this.dataSource != null) {
      json[r'data_source'] = this.dataSource;
    } else {
      json[r'data_source'] = null;
    }
    json[r'duration'] = this.duration;
    if (this.endTime != null) {
      json[r'end_time'] = this.endTime!.toUtc().toIso8601String();
    } else {
      json[r'end_time'] = null;
    }
    if (this.generatedAt != null) {
      json[r'generated_at'] = this.generatedAt!.toUtc().toIso8601String();
    } else {
      json[r'generated_at'] = null;
    }
    if (this.publishers != null) {
      json[r'publishers'] = this.publishers;
    } else {
      json[r'publishers'] = null;
    }
    if (this.sfus != null) {
      json[r'sfus'] = this.sfus;
    } else {
      json[r'sfus'] = null;
    }
    if (this.startTime != null) {
      json[r'start_time'] = this.startTime!.toUtc().toIso8601String();
    } else {
      json[r'start_time'] = null;
    }
    if (this.subscribers != null) {
      json[r'subscribers'] = this.subscribers;
    } else {
      json[r'subscribers'] = null;
    }
    return json;
  }

  /// Returns a new [QueryCallStatsMapResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallStatsMapResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "QueryCallStatsMapResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "QueryCallStatsMapResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_session_id'),
            'Required key "QueryCallStatsMapResponse[call_session_id]" is missing from JSON.');
        assert(json[r'call_session_id'] != null,
            'Required key "QueryCallStatsMapResponse[call_session_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "QueryCallStatsMapResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "QueryCallStatsMapResponse[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'counts'),
            'Required key "QueryCallStatsMapResponse[counts]" is missing from JSON.');
        assert(json[r'counts'] != null,
            'Required key "QueryCallStatsMapResponse[counts]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "QueryCallStatsMapResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "QueryCallStatsMapResponse[duration]" has a null value in JSON.');
        return true;
      }());

      return QueryCallStatsMapResponse(
        callEndedAt: mapDateTime(json, r'call_ended_at', r''),
        callId: mapValueOfType<String>(json, r'call_id')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callStartedAt: mapDateTime(json, r'call_started_at', r''),
        callType: mapValueOfType<String>(json, r'call_type')!,
        counts: CallStatsParticipantCounts.fromJson(json[r'counts'])!,
        dataSource: mapValueOfType<String>(json, r'data_source'),
        duration: mapValueOfType<String>(json, r'duration')!,
        endTime: mapDateTime(json, r'end_time', r''),
        generatedAt: mapDateTime(json, r'generated_at', r''),
        publishers: CallStatsMapPublishers.fromJson(json[r'publishers']),
        sfus: CallStatsMapSFUs.fromJson(json[r'sfus']),
        startTime: mapDateTime(json, r'start_time', r''),
        subscribers: CallStatsMapSubscribers.fromJson(json[r'subscribers']),
      );
    }
    return null;
  }

  static List<QueryCallStatsMapResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryCallStatsMapResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallStatsMapResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallStatsMapResponse> mapFromJson(dynamic json) {
    final map = <String, QueryCallStatsMapResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryCallStatsMapResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallStatsMapResponse-objects as value to a dart map
  static Map<String, List<QueryCallStatsMapResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<QueryCallStatsMapResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallStatsMapResponse.listFromJson(
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
  };
}
