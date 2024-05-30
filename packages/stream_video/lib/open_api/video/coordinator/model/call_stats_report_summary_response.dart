//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsReportSummaryResponse {
  /// Returns a new [CallStatsReportSummaryResponse] instance.
  CallStatsReportSummaryResponse({
    required this.callCid,
    required this.callDurationSeconds,
    required this.callSessionId,
    required this.callStatus,
    this.createdAt,
    required this.firstStatsTime,
    this.qualityScore,
  });

  String callCid;

  int callDurationSeconds;

  String callSessionId;

  String callStatus;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  DateTime firstStatsTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? qualityScore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallStatsReportSummaryResponse &&
    other.callCid == callCid &&
    other.callDurationSeconds == callDurationSeconds &&
    other.callSessionId == callSessionId &&
    other.callStatus == callStatus &&
    other.createdAt == createdAt &&
    other.firstStatsTime == firstStatsTime &&
    other.qualityScore == qualityScore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callCid.hashCode) +
    (callDurationSeconds.hashCode) +
    (callSessionId.hashCode) +
    (callStatus.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (firstStatsTime.hashCode) +
    (qualityScore == null ? 0 : qualityScore!.hashCode);

  @override
  String toString() => 'CallStatsReportSummaryResponse[callCid=$callCid, callDurationSeconds=$callDurationSeconds, callSessionId=$callSessionId, callStatus=$callStatus, createdAt=$createdAt, firstStatsTime=$firstStatsTime, qualityScore=$qualityScore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_cid'] = this.callCid;
      json[r'call_duration_seconds'] = this.callDurationSeconds;
      json[r'call_session_id'] = this.callSessionId;
      json[r'call_status'] = this.callStatus;
    if (this.createdAt != null) {
      json[r'created_at'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'created_at'] = null;
    }
      json[r'first_stats_time'] = this.firstStatsTime.toUtc().toIso8601String();
    if (this.qualityScore != null) {
      json[r'quality_score'] = this.qualityScore;
    } else {
      json[r'quality_score'] = null;
    }
    return json;
  }

  /// Returns a new [CallStatsReportSummaryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsReportSummaryResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallStatsReportSummaryResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallStatsReportSummaryResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallStatsReportSummaryResponse(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        callDurationSeconds: mapValueOfType<int>(json, r'call_duration_seconds')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callStatus: mapValueOfType<String>(json, r'call_status')!,
        createdAt: mapDateTime(json, r'created_at', r''),
        firstStatsTime: mapDateTime(json, r'first_stats_time', r'')!,
        qualityScore: mapValueOfType<int>(json, r'quality_score'),
      );
    }
    return null;
  }

  static List<CallStatsReportSummaryResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallStatsReportSummaryResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsReportSummaryResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsReportSummaryResponse> mapFromJson(dynamic json) {
    final map = <String, CallStatsReportSummaryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsReportSummaryResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsReportSummaryResponse-objects as value to a dart map
  static Map<String, List<CallStatsReportSummaryResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallStatsReportSummaryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsReportSummaryResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'call_duration_seconds',
    'call_session_id',
    'call_status',
    'first_stats_time',
  };
}

