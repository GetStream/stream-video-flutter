//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TimeStats {
  /// Returns a new [TimeStats] instance.
  TimeStats({
    required this.averageSeconds,
    required this.maxSeconds,
  });

  double averageSeconds;

  double maxSeconds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeStats &&
    other.averageSeconds == averageSeconds &&
    other.maxSeconds == maxSeconds;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (averageSeconds.hashCode) +
    (maxSeconds.hashCode);

  @override
  String toString() => 'TimeStats[averageSeconds=$averageSeconds, maxSeconds=$maxSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'average_seconds'] = this.averageSeconds;
      json[r'max_seconds'] = this.maxSeconds;
    return json;
  }

  /// Returns a new [TimeStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TimeStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TimeStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TimeStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TimeStats(
        averageSeconds: mapValueOfType<double>(json, r'average_seconds')!,
        maxSeconds: mapValueOfType<double>(json, r'max_seconds')!,
      );
    }
    return null;
  }

  static List<TimeStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TimeStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TimeStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TimeStats> mapFromJson(dynamic json) {
    final map = <String, TimeStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TimeStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TimeStats-objects as value to a dart map
  static Map<String, List<TimeStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TimeStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TimeStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'average_seconds',
    'max_seconds',
  };
}

