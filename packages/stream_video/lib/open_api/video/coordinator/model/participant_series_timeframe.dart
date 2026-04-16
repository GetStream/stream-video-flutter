//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantSeriesTimeframe {
  /// Returns a new [ParticipantSeriesTimeframe] instance.
  ParticipantSeriesTimeframe({
    required this.maxPoints,
    required this.since,
    required this.stepSeconds,
    required this.until,
  });

  int maxPoints;

  DateTime since;

  int stepSeconds;

  DateTime until;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSeriesTimeframe &&
          other.maxPoints == maxPoints &&
          other.since == since &&
          other.stepSeconds == stepSeconds &&
          other.until == until;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (maxPoints.hashCode) +
      (since.hashCode) +
      (stepSeconds.hashCode) +
      (until.hashCode);

  @override
  String toString() =>
      'ParticipantSeriesTimeframe[maxPoints=$maxPoints, since=$since, stepSeconds=$stepSeconds, until=$until]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'max_points'] = this.maxPoints;
    json[r'since'] = this.since.toUtc().toIso8601String();
    json[r'step_seconds'] = this.stepSeconds;
    json[r'until'] = this.until.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ParticipantSeriesTimeframe] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantSeriesTimeframe? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'max_points'),
            'Required key "ParticipantSeriesTimeframe[max_points]" is missing from JSON.');
        assert(json[r'max_points'] != null,
            'Required key "ParticipantSeriesTimeframe[max_points]" has a null value in JSON.');
        assert(json.containsKey(r'since'),
            'Required key "ParticipantSeriesTimeframe[since]" is missing from JSON.');
        assert(json[r'since'] != null,
            'Required key "ParticipantSeriesTimeframe[since]" has a null value in JSON.');
        assert(json.containsKey(r'step_seconds'),
            'Required key "ParticipantSeriesTimeframe[step_seconds]" is missing from JSON.');
        assert(json[r'step_seconds'] != null,
            'Required key "ParticipantSeriesTimeframe[step_seconds]" has a null value in JSON.');
        assert(json.containsKey(r'until'),
            'Required key "ParticipantSeriesTimeframe[until]" is missing from JSON.');
        assert(json[r'until'] != null,
            'Required key "ParticipantSeriesTimeframe[until]" has a null value in JSON.');
        return true;
      }());

      return ParticipantSeriesTimeframe(
        maxPoints: mapValueOfType<int>(json, r'max_points')!,
        since: mapDateTime(json, r'since', r'')!,
        stepSeconds: mapValueOfType<int>(json, r'step_seconds')!,
        until: mapDateTime(json, r'until', r'')!,
      );
    }
    return null;
  }

  static List<ParticipantSeriesTimeframe> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantSeriesTimeframe>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantSeriesTimeframe.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantSeriesTimeframe> mapFromJson(dynamic json) {
    final map = <String, ParticipantSeriesTimeframe>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantSeriesTimeframe.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantSeriesTimeframe-objects as value to a dart map
  static Map<String, List<ParticipantSeriesTimeframe>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantSeriesTimeframe>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantSeriesTimeframe.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'max_points',
    'since',
    'step_seconds',
    'until',
  };
}
