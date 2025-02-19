//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Bound {
  /// Returns a new [Bound] instance.
  Bound({
    required this.inclusive,
    required this.value,
  });

  bool inclusive;

  double value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bound && other.inclusive == inclusive && other.value == value;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (inclusive.hashCode) + (value.hashCode);

  @override
  String toString() => 'Bound[inclusive=$inclusive, value=$value]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'inclusive'] = this.inclusive;
    json[r'value'] = this.value;
    return json;
  }

  /// Returns a new [Bound] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Bound? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "Bound[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "Bound[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Bound(
        inclusive: mapValueOfType<bool>(json, r'inclusive')!,
        value: mapValueOfType<double>(json, r'value')!,
      );
    }
    return null;
  }

  static List<Bound> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <Bound>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Bound.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Bound> mapFromJson(dynamic json) {
    final map = <String, Bound>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Bound.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Bound-objects as value to a dart map
  static Map<String, List<Bound>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<Bound>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Bound.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'inclusive',
    'value',
  };
}
