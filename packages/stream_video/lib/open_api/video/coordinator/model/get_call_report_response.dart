//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetCallReportResponse {
  /// Returns a new [GetCallReportResponse] instance.
  GetCallReportResponse({
    this.chatActivity,
    required this.duration,
    required this.report,
    required this.sessionId,
    this.videoReactions = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ChatActivityStatsResponse? chatActivity;

  /// Duration of the request in milliseconds
  String duration;

  ReportResponse report;

  String sessionId;

  List<VideoReactionsResponse> videoReactions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetCallReportResponse &&
          other.chatActivity == chatActivity &&
          other.duration == duration &&
          other.report == report &&
          other.sessionId == sessionId &&
          _deepEquality.equals(other.videoReactions, videoReactions);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (chatActivity == null ? 0 : chatActivity!.hashCode) +
      (duration.hashCode) +
      (report.hashCode) +
      (sessionId.hashCode) +
      (videoReactions.hashCode);

  @override
  String toString() =>
      'GetCallReportResponse[chatActivity=$chatActivity, duration=$duration, report=$report, sessionId=$sessionId, videoReactions=$videoReactions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.chatActivity != null) {
      json[r'chat_activity'] = this.chatActivity;
    } else {
      json[r'chat_activity'] = null;
    }
    json[r'duration'] = this.duration;
    json[r'report'] = this.report;
    json[r'session_id'] = this.sessionId;
    json[r'video_reactions'] = this.videoReactions;
    return json;
  }

  /// Returns a new [GetCallReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCallReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "GetCallReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "GetCallReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetCallReportResponse(
        chatActivity:
            ChatActivityStatsResponse.fromJson(json[r'chat_activity']),
        duration: mapValueOfType<String>(json, r'duration')!,
        report: ReportResponse.fromJson(json[r'report'])!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        videoReactions:
            VideoReactionsResponse.listFromJson(json[r'video_reactions']),
      );
    }
    return null;
  }

  static List<GetCallReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GetCallReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCallReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCallReportResponse> mapFromJson(dynamic json) {
    final map = <String, GetCallReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetCallReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCallReportResponse-objects as value to a dart map
  static Map<String, List<GetCallReportResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GetCallReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCallReportResponse.listFromJson(
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
    'report',
    'session_id',
  };
}
