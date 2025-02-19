//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyAggregateSDKUsageReportResponse {
  /// Returns a new [DailyAggregateSDKUsageReportResponse] instance.
  DailyAggregateSDKUsageReportResponse({
    required this.date,
    required this.report,
  });

  String date;

  SDKUsageReport report;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyAggregateSDKUsageReportResponse &&
          other.date == date &&
          other.report == report;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (date.hashCode) + (report.hashCode);

  @override
  String toString() =>
      'DailyAggregateSDKUsageReportResponse[date=$date, report=$report]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'date'] = this.date;
    json[r'report'] = this.report;
    return json;
  }

  /// Returns a new [DailyAggregateSDKUsageReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyAggregateSDKUsageReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "DailyAggregateSDKUsageReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "DailyAggregateSDKUsageReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DailyAggregateSDKUsageReportResponse(
        date: mapValueOfType<String>(json, r'date')!,
        report: SDKUsageReport.fromJson(json[r'report'])!,
      );
    }
    return null;
  }

  static List<DailyAggregateSDKUsageReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <DailyAggregateSDKUsageReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyAggregateSDKUsageReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyAggregateSDKUsageReportResponse> mapFromJson(
      dynamic json) {
    final map = <String, DailyAggregateSDKUsageReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            DailyAggregateSDKUsageReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyAggregateSDKUsageReportResponse-objects as value to a dart map
  static Map<String, List<DailyAggregateSDKUsageReportResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<DailyAggregateSDKUsageReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyAggregateSDKUsageReportResponse.listFromJson(
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
