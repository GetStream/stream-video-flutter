//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallParticipantTimeline {
  /// Returns a new [CallParticipantTimeline] instance.
  CallParticipantTimeline({
    this.data = const {},
    required this.severity,
    required this.timestamp,
    required this.type,
  });

  Map<String, Object> data;

  String severity;

  DateTime timestamp;

  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallParticipantTimeline &&
          _deepEquality.equals(other.data, data) &&
          other.severity == severity &&
          other.timestamp == timestamp &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (data.hashCode) +
      (severity.hashCode) +
      (timestamp.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallParticipantTimeline[data=$data, severity=$severity, timestamp=$timestamp, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'data'] = this.data;
    json[r'severity'] = this.severity;
    json[r'timestamp'] = this.timestamp.toUtc().toIso8601String();
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallParticipantTimeline] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallParticipantTimeline? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'data'),
            'Required key "CallParticipantTimeline[data]" is missing from JSON.');
        assert(json[r'data'] != null,
            'Required key "CallParticipantTimeline[data]" has a null value in JSON.');
        assert(json.containsKey(r'severity'),
            'Required key "CallParticipantTimeline[severity]" is missing from JSON.');
        assert(json[r'severity'] != null,
            'Required key "CallParticipantTimeline[severity]" has a null value in JSON.');
        assert(json.containsKey(r'timestamp'),
            'Required key "CallParticipantTimeline[timestamp]" is missing from JSON.');
        assert(json[r'timestamp'] != null,
            'Required key "CallParticipantTimeline[timestamp]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "CallParticipantTimeline[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "CallParticipantTimeline[type]" has a null value in JSON.');
        return true;
      }());

      return CallParticipantTimeline(
        data: mapCastOfType<String, Object>(json, r'data')!,
        severity: mapValueOfType<String>(json, r'severity')!,
        timestamp: mapDateTime(json, r'timestamp', r'')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallParticipantTimeline> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallParticipantTimeline>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallParticipantTimeline.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallParticipantTimeline> mapFromJson(dynamic json) {
    final map = <String, CallParticipantTimeline>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallParticipantTimeline.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallParticipantTimeline-objects as value to a dart map
  static Map<String, List<CallParticipantTimeline>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallParticipantTimeline>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallParticipantTimeline.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'data',
    'severity',
    'timestamp',
    'type',
  };
}
