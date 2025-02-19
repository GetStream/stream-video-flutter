//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryAggregateCallStatsResponse {
  /// Returns a new [QueryAggregateCallStatsResponse] instance.
  QueryAggregateCallStatsResponse({
    this.callDurationReport,
    this.callParticipantCountReport,
    this.callsPerDayReport,
    required this.duration,
    this.networkMetricsReport,
    this.qualityScoreReport,
    this.sdkUsageReport,
    this.userFeedbackReport,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallDurationReportResponse? callDurationReport;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallParticipantCountReportResponse? callParticipantCountReport;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallsPerDayReportResponse? callsPerDayReport;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  NetworkMetricsReportResponse? networkMetricsReport;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  QualityScoreReportResponse? qualityScoreReport;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SDKUsageReportResponse? sdkUsageReport;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserFeedbackReportResponse? userFeedbackReport;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryAggregateCallStatsResponse &&
          other.callDurationReport == callDurationReport &&
          other.callParticipantCountReport == callParticipantCountReport &&
          other.callsPerDayReport == callsPerDayReport &&
          other.duration == duration &&
          other.networkMetricsReport == networkMetricsReport &&
          other.qualityScoreReport == qualityScoreReport &&
          other.sdkUsageReport == sdkUsageReport &&
          other.userFeedbackReport == userFeedbackReport;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callDurationReport == null ? 0 : callDurationReport!.hashCode) +
      (callParticipantCountReport == null
          ? 0
          : callParticipantCountReport!.hashCode) +
      (callsPerDayReport == null ? 0 : callsPerDayReport!.hashCode) +
      (duration.hashCode) +
      (networkMetricsReport == null ? 0 : networkMetricsReport!.hashCode) +
      (qualityScoreReport == null ? 0 : qualityScoreReport!.hashCode) +
      (sdkUsageReport == null ? 0 : sdkUsageReport!.hashCode) +
      (userFeedbackReport == null ? 0 : userFeedbackReport!.hashCode);

  @override
  String toString() =>
      'QueryAggregateCallStatsResponse[callDurationReport=$callDurationReport, callParticipantCountReport=$callParticipantCountReport, callsPerDayReport=$callsPerDayReport, duration=$duration, networkMetricsReport=$networkMetricsReport, qualityScoreReport=$qualityScoreReport, sdkUsageReport=$sdkUsageReport, userFeedbackReport=$userFeedbackReport]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callDurationReport != null) {
      json[r'call_duration_report'] = this.callDurationReport;
    } else {
      json[r'call_duration_report'] = null;
    }
    if (this.callParticipantCountReport != null) {
      json[r'call_participant_count_report'] = this.callParticipantCountReport;
    } else {
      json[r'call_participant_count_report'] = null;
    }
    if (this.callsPerDayReport != null) {
      json[r'calls_per_day_report'] = this.callsPerDayReport;
    } else {
      json[r'calls_per_day_report'] = null;
    }
    json[r'duration'] = this.duration;
    if (this.networkMetricsReport != null) {
      json[r'network_metrics_report'] = this.networkMetricsReport;
    } else {
      json[r'network_metrics_report'] = null;
    }
    if (this.qualityScoreReport != null) {
      json[r'quality_score_report'] = this.qualityScoreReport;
    } else {
      json[r'quality_score_report'] = null;
    }
    if (this.sdkUsageReport != null) {
      json[r'sdk_usage_report'] = this.sdkUsageReport;
    } else {
      json[r'sdk_usage_report'] = null;
    }
    if (this.userFeedbackReport != null) {
      json[r'user_feedback_report'] = this.userFeedbackReport;
    } else {
      json[r'user_feedback_report'] = null;
    }
    return json;
  }

  /// Returns a new [QueryAggregateCallStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryAggregateCallStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "QueryAggregateCallStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "QueryAggregateCallStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryAggregateCallStatsResponse(
        callDurationReport:
            CallDurationReportResponse.fromJson(json[r'call_duration_report']),
        callParticipantCountReport: CallParticipantCountReportResponse.fromJson(
            json[r'call_participant_count_report']),
        callsPerDayReport:
            CallsPerDayReportResponse.fromJson(json[r'calls_per_day_report']),
        duration: mapValueOfType<String>(json, r'duration')!,
        networkMetricsReport: NetworkMetricsReportResponse.fromJson(
            json[r'network_metrics_report']),
        qualityScoreReport:
            QualityScoreReportResponse.fromJson(json[r'quality_score_report']),
        sdkUsageReport:
            SDKUsageReportResponse.fromJson(json[r'sdk_usage_report']),
        userFeedbackReport:
            UserFeedbackReportResponse.fromJson(json[r'user_feedback_report']),
      );
    }
    return null;
  }

  static List<QueryAggregateCallStatsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryAggregateCallStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryAggregateCallStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryAggregateCallStatsResponse> mapFromJson(
      dynamic json) {
    final map = <String, QueryAggregateCallStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryAggregateCallStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryAggregateCallStatsResponse-objects as value to a dart map
  static Map<String, List<QueryAggregateCallStatsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<QueryAggregateCallStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryAggregateCallStatsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
  };
}
