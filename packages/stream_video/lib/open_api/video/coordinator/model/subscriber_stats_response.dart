//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SubscriberStatsResponse {
  /// Returns a new [SubscriberStatsResponse] instance.
  SubscriberStatsResponse({
    required this.total,
    required this.totalSubscribedDurationSeconds,
    required this.unique,
  });

  int total;

  int totalSubscribedDurationSeconds;

  int unique;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriberStatsResponse &&
          other.total == total &&
          other.totalSubscribedDurationSeconds ==
              totalSubscribedDurationSeconds &&
          other.unique == unique;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (total.hashCode) +
      (totalSubscribedDurationSeconds.hashCode) +
      (unique.hashCode);

  @override
  String toString() =>
      'SubscriberStatsResponse[total=$total, totalSubscribedDurationSeconds=$totalSubscribedDurationSeconds, unique=$unique]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'total'] = this.total;
    json[r'total_subscribed_duration_seconds'] =
        this.totalSubscribedDurationSeconds;
    json[r'unique'] = this.unique;
    return json;
  }

  /// Returns a new [SubscriberStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SubscriberStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "SubscriberStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "SubscriberStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SubscriberStatsResponse(
        total: mapValueOfType<int>(json, r'total')!,
        totalSubscribedDurationSeconds:
            mapValueOfType<int>(json, r'total_subscribed_duration_seconds')!,
        unique: mapValueOfType<int>(json, r'unique')!,
      );
    }
    return null;
  }

  static List<SubscriberStatsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SubscriberStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SubscriberStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SubscriberStatsResponse> mapFromJson(dynamic json) {
    final map = <String, SubscriberStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SubscriberStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SubscriberStatsResponse-objects as value to a dart map
  static Map<String, List<SubscriberStatsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SubscriberStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SubscriberStatsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'total',
    'total_subscribed_duration_seconds',
    'unique',
  };
}
