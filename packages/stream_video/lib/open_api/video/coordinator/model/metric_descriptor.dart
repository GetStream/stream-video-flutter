//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MetricDescriptor {
  /// Returns a new [MetricDescriptor] instance.
  MetricDescriptor({
    this.description,
    required this.label,
    this.unit,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  String label;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unit;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetricDescriptor &&
          other.description == description &&
          other.label == label &&
          other.unit == unit;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (description == null ? 0 : description!.hashCode) +
      (label.hashCode) +
      (unit == null ? 0 : unit!.hashCode);

  @override
  String toString() =>
      'MetricDescriptor[description=$description, label=$label, unit=$unit]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    json[r'label'] = this.label;
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    return json;
  }

  /// Returns a new [MetricDescriptor] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MetricDescriptor? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'label'),
            'Required key "MetricDescriptor[label]" is missing from JSON.');
        assert(json[r'label'] != null,
            'Required key "MetricDescriptor[label]" has a null value in JSON.');
        return true;
      }());

      return MetricDescriptor(
        description: mapValueOfType<String>(json, r'description'),
        label: mapValueOfType<String>(json, r'label')!,
        unit: mapValueOfType<String>(json, r'unit'),
      );
    }
    return null;
  }

  static List<MetricDescriptor> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <MetricDescriptor>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MetricDescriptor.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MetricDescriptor> mapFromJson(dynamic json) {
    final map = <String, MetricDescriptor>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MetricDescriptor.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MetricDescriptor-objects as value to a dart map
  static Map<String, List<MetricDescriptor>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<MetricDescriptor>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MetricDescriptor.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'label',
  };
}
