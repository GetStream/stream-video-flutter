//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyAggregateCallsPerDayReportResponse {
  /// Returns a new [DailyAggregateCallsPerDayReportResponse] instance.
  DailyAggregateCallsPerDayReportResponse({
    required this.date,
    required this.report,
  });

  String date;

  CallsPerDayReport report;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyAggregateCallsPerDayReportResponse &&
          other.date == date &&
          other.report == report;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (date.hashCode) + (report.hashCode);

  @override
  String toString() =>
      'DailyAggregateCallsPerDayReportResponse[date=$date, report=$report]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'date'] = this.date;
    json[r'report'] = this.report;
    return json;
  }

  /// Returns a new [DailyAggregateCallsPerDayReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyAggregateCallsPerDayReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "DailyAggregateCallsPerDayReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "DailyAggregateCallsPerDayReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DailyAggregateCallsPerDayReportResponse(
        date: mapValueOfType<String>(json, r'date')!,
        report: CallsPerDayReport.fromJson(json[r'report'])!,
      );
    }
    return null;
  }

  static List<DailyAggregateCallsPerDayReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <DailyAggregateCallsPerDayReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyAggregateCallsPerDayReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyAggregateCallsPerDayReportResponse> mapFromJson(
      dynamic json) {
    final map = <String, DailyAggregateCallsPerDayReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            DailyAggregateCallsPerDayReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyAggregateCallsPerDayReportResponse-objects as value to a dart map
  static Map<String, List<DailyAggregateCallsPerDayReportResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<DailyAggregateCallsPerDayReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyAggregateCallsPerDayReportResponse.listFromJson(
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
