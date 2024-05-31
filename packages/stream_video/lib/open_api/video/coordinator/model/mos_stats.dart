//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MOSStats {
  /// Returns a new [MOSStats] instance.
  MOSStats({
    required this.averageScore,
    this.histogramDurationSeconds = const [],
    required this.maxScore,
    required this.minScore,
  });

  double averageScore;

  List<double> histogramDurationSeconds;

  double maxScore;

  double minScore;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MOSStats &&
    other.averageScore == averageScore &&
    _deepEquality.equals(other.histogramDurationSeconds, histogramDurationSeconds) &&
    other.maxScore == maxScore &&
    other.minScore == minScore;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (averageScore.hashCode) +
    (histogramDurationSeconds.hashCode) +
    (maxScore.hashCode) +
    (minScore.hashCode);

  @override
  String toString() => 'MOSStats[averageScore=$averageScore, histogramDurationSeconds=$histogramDurationSeconds, maxScore=$maxScore, minScore=$minScore]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'average_score'] = this.averageScore;
      json[r'histogram_duration_seconds'] = this.histogramDurationSeconds;
      json[r'max_score'] = this.maxScore;
      json[r'min_score'] = this.minScore;
    return json;
  }

  /// Returns a new [MOSStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MOSStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MOSStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MOSStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MOSStats(
        averageScore: mapValueOfType<double>(json, r'average_score')!,
        histogramDurationSeconds: json[r'histogram_duration_seconds'] is Iterable
            ? (json[r'histogram_duration_seconds'] as Iterable).cast<double>().toList(growable: false)
            : const [],
        maxScore: mapValueOfType<double>(json, r'max_score')!,
        minScore: mapValueOfType<double>(json, r'min_score')!,
      );
    }
    return null;
  }

  static List<MOSStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MOSStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MOSStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MOSStats> mapFromJson(dynamic json) {
    final map = <String, MOSStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MOSStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MOSStats-objects as value to a dart map
  static Map<String, List<MOSStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MOSStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MOSStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'average_score',
    'histogram_duration_seconds',
    'max_score',
    'min_score',
  };
}

