//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantReportResponse {
  /// Returns a new [ParticipantReportResponse] instance.
  ParticipantReportResponse({
    this.byBrowser = const [],
    this.byCountry = const [],
    this.byDevice = const [],
    this.byOperatingSystem = const [],
    this.countOverTime,
    this.maxConcurrent,
    this.publishers,
    this.subscribers,
    required this.sum,
    required this.unique,
  });

  List<GroupedStatsResponse> byBrowser;

  List<GroupedStatsResponse> byCountry;

  List<GroupedStatsResponse> byDevice;

  List<GroupedStatsResponse> byOperatingSystem;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ParticipantCountOverTimeResponse? countOverTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxConcurrent;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PublisherStatsResponse? publishers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SubscriberStatsResponse? subscribers;

  int sum;

  int unique;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantReportResponse &&
          _deepEquality.equals(other.byBrowser, byBrowser) &&
          _deepEquality.equals(other.byCountry, byCountry) &&
          _deepEquality.equals(other.byDevice, byDevice) &&
          _deepEquality.equals(other.byOperatingSystem, byOperatingSystem) &&
          other.countOverTime == countOverTime &&
          other.maxConcurrent == maxConcurrent &&
          other.publishers == publishers &&
          other.subscribers == subscribers &&
          other.sum == sum &&
          other.unique == unique;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (byBrowser.hashCode) +
      (byCountry.hashCode) +
      (byDevice.hashCode) +
      (byOperatingSystem.hashCode) +
      (countOverTime == null ? 0 : countOverTime!.hashCode) +
      (maxConcurrent == null ? 0 : maxConcurrent!.hashCode) +
      (publishers == null ? 0 : publishers!.hashCode) +
      (subscribers == null ? 0 : subscribers!.hashCode) +
      (sum.hashCode) +
      (unique.hashCode);

  @override
  String toString() =>
      'ParticipantReportResponse[byBrowser=$byBrowser, byCountry=$byCountry, byDevice=$byDevice, byOperatingSystem=$byOperatingSystem, countOverTime=$countOverTime, maxConcurrent=$maxConcurrent, publishers=$publishers, subscribers=$subscribers, sum=$sum, unique=$unique]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'by_browser'] = this.byBrowser;
    json[r'by_country'] = this.byCountry;
    json[r'by_device'] = this.byDevice;
    json[r'by_operating_system'] = this.byOperatingSystem;
    if (this.countOverTime != null) {
      json[r'count_over_time'] = this.countOverTime;
    } else {
      json[r'count_over_time'] = null;
    }
    if (this.maxConcurrent != null) {
      json[r'max_concurrent'] = this.maxConcurrent;
    } else {
      json[r'max_concurrent'] = null;
    }
    if (this.publishers != null) {
      json[r'publishers'] = this.publishers;
    } else {
      json[r'publishers'] = null;
    }
    if (this.subscribers != null) {
      json[r'subscribers'] = this.subscribers;
    } else {
      json[r'subscribers'] = null;
    }
    json[r'sum'] = this.sum;
    json[r'unique'] = this.unique;
    return json;
  }

  /// Returns a new [ParticipantReportResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantReportResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ParticipantReportResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ParticipantReportResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ParticipantReportResponse(
        byBrowser: GroupedStatsResponse.listFromJson(json[r'by_browser']),
        byCountry: GroupedStatsResponse.listFromJson(json[r'by_country']),
        byDevice: GroupedStatsResponse.listFromJson(json[r'by_device']),
        byOperatingSystem:
            GroupedStatsResponse.listFromJson(json[r'by_operating_system']),
        countOverTime:
            ParticipantCountOverTimeResponse.fromJson(json[r'count_over_time']),
        maxConcurrent: mapValueOfType<int>(json, r'max_concurrent'),
        publishers: PublisherStatsResponse.fromJson(json[r'publishers']),
        subscribers: SubscriberStatsResponse.fromJson(json[r'subscribers']),
        sum: mapValueOfType<int>(json, r'sum')!,
        unique: mapValueOfType<int>(json, r'unique')!,
      );
    }
    return null;
  }

  static List<ParticipantReportResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantReportResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantReportResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantReportResponse> mapFromJson(dynamic json) {
    final map = <String, ParticipantReportResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantReportResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantReportResponse-objects as value to a dart map
  static Map<String, List<ParticipantReportResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantReportResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantReportResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'sum',
    'unique',
  };
}
