//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyAggregateCallDurationReportResponse {
  /// Returns a new [DailyAggregateCallDurationReportResponse] instance.
  DailyAggregateCallDurationReportResponse({
    required this.date,
    required this.report,
  });

  String date;

  CallDurationReport report;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyAggregateCallDurationReportResponse &&
          other.date == date &&
          other.report == report;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (date.hashCode) + (report.hashCode);

  @override
  String toString() =>
      'DailyAggregateCallDurationReportResponse[date=$date, report=$report]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'date'] = this.date;
    json[r'report'] = this.report;
    return json;
  }

  /// Returns a new [DailyAggregateCallDurationReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyAggregateCallDurationReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "DailyAggregateCallDurationReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "DailyAggregateCallDurationReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DailyAggregateCallDurationReportResponse(
        date: mapValueOfType<String>(json, r'date')!,
        report: CallDurationReport.fromJson(json[r'report'])!,
      );
    }
    return null;
  }

  static List<DailyAggregateCallDurationReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <DailyAggregateCallDurationReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyAggregateCallDurationReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyAggregateCallDurationReportResponse> mapFromJson(
      dynamic json) {
    final map = <String, DailyAggregateCallDurationReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            DailyAggregateCallDurationReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyAggregateCallDurationReportResponse-objects as value to a dart map
  static Map<String, List<DailyAggregateCallDurationReportResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<DailyAggregateCallDurationReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyAggregateCallDurationReportResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'date',
    'report',
  };
}
