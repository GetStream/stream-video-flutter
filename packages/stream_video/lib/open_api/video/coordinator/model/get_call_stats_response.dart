//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetCallStatsResponse {
  /// Returns a new [GetCallStatsResponse] instance.
  GetCallStatsResponse({
    this.aggregated,
    required this.callDurationSeconds,
    required this.callStatus,
    this.callTimeline,
    required this.duration,
    this.jitter,
    this.latency,
    required this.maxFreezesDurationSeconds,
    required this.maxParticipants,
    required this.maxTotalQualityLimitationDurationSeconds,
    this.participantReport = const [],
    required this.publishingParticipants,
    required this.qualityScore,
    required this.sfuCount,
    this.sfus = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AggregatedStats? aggregated;

  int callDurationSeconds;

  String callStatus;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallTimeline? callTimeline;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? jitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? latency;

  int maxFreezesDurationSeconds;

  int maxParticipants;

  int maxTotalQualityLimitationDurationSeconds;

  List<UserStats> participantReport;

  int publishingParticipants;

  int qualityScore;

  int sfuCount;

  List<SFULocationResponse> sfus;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetCallStatsResponse &&
    other.aggregated == aggregated &&
    other.callDurationSeconds == callDurationSeconds &&
    other.callStatus == callStatus &&
    other.callTimeline == callTimeline &&
    other.duration == duration &&
    other.jitter == jitter &&
    other.latency == latency &&
    other.maxFreezesDurationSeconds == maxFreezesDurationSeconds &&
    other.maxParticipants == maxParticipants &&
    other.maxTotalQualityLimitationDurationSeconds == maxTotalQualityLimitationDurationSeconds &&
    _deepEquality.equals(other.participantReport, participantReport) &&
    other.publishingParticipants == publishingParticipants &&
    other.qualityScore == qualityScore &&
    other.sfuCount == sfuCount &&
    _deepEquality.equals(other.sfus, sfus);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (aggregated == null ? 0 : aggregated!.hashCode) +
    (callDurationSeconds.hashCode) +
    (callStatus.hashCode) +
    (callTimeline == null ? 0 : callTimeline!.hashCode) +
    (duration.hashCode) +
    (jitter == null ? 0 : jitter!.hashCode) +
    (latency == null ? 0 : latency!.hashCode) +
    (maxFreezesDurationSeconds.hashCode) +
    (maxParticipants.hashCode) +
    (maxTotalQualityLimitationDurationSeconds.hashCode) +
    (participantReport.hashCode) +
    (publishingParticipants.hashCode) +
    (qualityScore.hashCode) +
    (sfuCount.hashCode) +
    (sfus.hashCode);

  @override
  String toString() => 'GetCallStatsResponse[aggregated=$aggregated, callDurationSeconds=$callDurationSeconds, callStatus=$callStatus, callTimeline=$callTimeline, duration=$duration, jitter=$jitter, latency=$latency, maxFreezesDurationSeconds=$maxFreezesDurationSeconds, maxParticipants=$maxParticipants, maxTotalQualityLimitationDurationSeconds=$maxTotalQualityLimitationDurationSeconds, participantReport=$participantReport, publishingParticipants=$publishingParticipants, qualityScore=$qualityScore, sfuCount=$sfuCount, sfus=$sfus]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.aggregated != null) {
      json[r'aggregated'] = this.aggregated;
    } else {
      json[r'aggregated'] = null;
    }
      json[r'call_duration_seconds'] = this.callDurationSeconds;
      json[r'call_status'] = this.callStatus;
    if (this.callTimeline != null) {
      json[r'call_timeline'] = this.callTimeline;
    } else {
      json[r'call_timeline'] = null;
    }
      json[r'duration'] = this.duration;
    if (this.jitter != null) {
      json[r'jitter'] = this.jitter;
    } else {
      json[r'jitter'] = null;
    }
    if (this.latency != null) {
      json[r'latency'] = this.latency;
    } else {
      json[r'latency'] = null;
    }
      json[r'max_freezes_duration_seconds'] = this.maxFreezesDurationSeconds;
      json[r'max_participants'] = this.maxParticipants;
      json[r'max_total_quality_limitation_duration_seconds'] = this.maxTotalQualityLimitationDurationSeconds;
      json[r'participant_report'] = this.participantReport;
      json[r'publishing_participants'] = this.publishingParticipants;
      json[r'quality_score'] = this.qualityScore;
      json[r'sfu_count'] = this.sfuCount;
      json[r'sfus'] = this.sfus;
    return json;
  }

  /// Returns a new [GetCallStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCallStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetCallStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetCallStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetCallStatsResponse(
        aggregated: AggregatedStats.fromJson(json[r'aggregated']),
        callDurationSeconds: mapValueOfType<int>(json, r'call_duration_seconds')!,
        callStatus: mapValueOfType<String>(json, r'call_status')!,
        callTimeline: CallTimeline.fromJson(json[r'call_timeline']),
        duration: mapValueOfType<String>(json, r'duration')!,
        jitter: TimeStats.fromJson(json[r'jitter']),
        latency: TimeStats.fromJson(json[r'latency']),
        maxFreezesDurationSeconds: mapValueOfType<int>(json, r'max_freezes_duration_seconds')!,
        maxParticipants: mapValueOfType<int>(json, r'max_participants')!,
        maxTotalQualityLimitationDurationSeconds: mapValueOfType<int>(json, r'max_total_quality_limitation_duration_seconds')!,
        participantReport: UserStats.listFromJson(json[r'participant_report']),
        publishingParticipants: mapValueOfType<int>(json, r'publishing_participants')!,
        qualityScore: mapValueOfType<int>(json, r'quality_score')!,
        sfuCount: mapValueOfType<int>(json, r'sfu_count')!,
        sfus: SFULocationResponse.listFromJson(json[r'sfus']),
      );
    }
    return null;
  }

  static List<GetCallStatsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetCallStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCallStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCallStatsResponse> mapFromJson(dynamic json) {
    final map = <String, GetCallStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCallStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCallStatsResponse-objects as value to a dart map
  static Map<String, List<GetCallStatsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetCallStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCallStatsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_duration_seconds',
    'call_status',
    'duration',
    'max_freezes_duration_seconds',
    'max_participants',
    'max_total_quality_limitation_duration_seconds',
    'participant_report',
    'publishing_participants',
    'quality_score',
    'sfu_count',
    'sfus',
  };
}

