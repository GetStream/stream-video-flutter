//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallReportResponse {
  /// Returns a new [CallReportResponse] instance.
  CallReportResponse({
    this.endedAt,
    required this.score,
    this.startedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? endedAt;

  double score;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallReportResponse &&
          other.endedAt == endedAt &&
          other.score == score &&
          other.startedAt == startedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (endedAt == null ? 0 : endedAt!.hashCode) +
      (score.hashCode) +
      (startedAt == null ? 0 : startedAt!.hashCode);

  @override
  String toString() =>
      'CallReportResponse[endedAt=$endedAt, score=$score, startedAt=$startedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.endedAt != null) {
      json[r'ended_at'] = this.endedAt!.toUtc().toIso8601String();
    } else {
      json[r'ended_at'] = null;
    }
    json[r'score'] = this.score;
    if (this.startedAt != null) {
      json[r'started_at'] = this.startedAt!.toUtc().toIso8601String();
    } else {
      json[r'started_at'] = null;
    }
    return json;
  }

  /// Returns a new [CallReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallReportResponse(
        endedAt: mapDateTime(json, r'ended_at', r''),
        score: mapValueOfType<double>(json, r'score')!,
        startedAt: mapDateTime(json, r'started_at', r''),
      );
    }
    return null;
  }

  static List<CallReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallReportResponse> mapFromJson(dynamic json) {
    final map = <String, CallReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallReportResponse-objects as value to a dart map
  static Map<String, List<CallReportResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallReportResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'score',
  };
}
