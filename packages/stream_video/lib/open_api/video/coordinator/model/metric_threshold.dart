//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MetricThreshold {
  /// Returns a new [MetricThreshold] instance.
  MetricThreshold({
    required this.level,
    required this.operator_,
    required this.value,
    this.valueUnit,
    this.windowSeconds,
  });

  String level;

  String operator_;

  double value;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? valueUnit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? windowSeconds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetricThreshold &&
          other.level == level &&
          other.operator_ == operator_ &&
          other.value == value &&
          other.valueUnit == valueUnit &&
          other.windowSeconds == windowSeconds;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (level.hashCode) +
      (operator_.hashCode) +
      (value.hashCode) +
      (valueUnit == null ? 0 : valueUnit!.hashCode) +
      (windowSeconds == null ? 0 : windowSeconds!.hashCode);

  @override
  String toString() =>
      'MetricThreshold[level=$level, operator_=$operator_, value=$value, valueUnit=$valueUnit, windowSeconds=$windowSeconds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'level'] = this.level;
    json[r'operator'] = this.operator_;
    json[r'value'] = this.value;
    if (this.valueUnit != null) {
      json[r'value_unit'] = this.valueUnit;
    } else {
      json[r'value_unit'] = null;
    }
    if (this.windowSeconds != null) {
      json[r'window_seconds'] = this.windowSeconds;
    } else {
      json[r'window_seconds'] = null;
    }
    return json;
  }

  /// Returns a new [MetricThreshold] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MetricThreshold? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'level'),
            'Required key "MetricThreshold[level]" is missing from JSON.');
        assert(json[r'level'] != null,
            'Required key "MetricThreshold[level]" has a null value in JSON.');
        assert(json.containsKey(r'operator'),
            'Required key "MetricThreshold[operator]" is missing from JSON.');
        assert(json[r'operator'] != null,
            'Required key "MetricThreshold[operator]" has a null value in JSON.');
        assert(json.containsKey(r'value'),
            'Required key "MetricThreshold[value]" is missing from JSON.');
        assert(json[r'value'] != null,
            'Required key "MetricThreshold[value]" has a null value in JSON.');
        return true;
      }());

      return MetricThreshold(
        level: mapValueOfType<String>(json, r'level')!,
        operator_: mapValueOfType<String>(json, r'operator')!,
        value: mapValueOfType<double>(json, r'value')!,
        valueUnit: mapValueOfType<String>(json, r'value_unit'),
        windowSeconds: mapValueOfType<int>(json, r'window_seconds'),
      );
    }
    return null;
  }

  static List<MetricThreshold> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <MetricThreshold>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MetricThreshold.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MetricThreshold> mapFromJson(dynamic json) {
    final map = <String, MetricThreshold>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MetricThreshold.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MetricThreshold-objects as value to a dart map
  static Map<String, List<MetricThreshold>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<MetricThreshold>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MetricThreshold.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'level',
    'operator',
    'value',
  };
}
