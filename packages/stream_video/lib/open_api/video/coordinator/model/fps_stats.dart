//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FPSStats {
  /// Returns a new [FPSStats] instance.
  FPSStats({
    required this.averageFps,
    required this.tracked,
  });

  double averageFps;

  int tracked;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FPSStats &&
          other.averageFps == averageFps &&
          other.tracked == tracked;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (averageFps.hashCode) + (tracked.hashCode);

  @override
  String toString() => 'FPSStats[averageFps=$averageFps, tracked=$tracked]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'average_fps'] = this.averageFps;
    json[r'tracked'] = this.tracked;
    return json;
  }

  /// Returns a new [FPSStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FPSStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FPSStats[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FPSStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FPSStats(
        averageFps: mapValueOfType<double>(json, r'average_fps')!,
        tracked: mapValueOfType<int>(json, r'tracked')!,
      );
    }
    return null;
  }

  static List<FPSStats> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FPSStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FPSStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FPSStats> mapFromJson(dynamic json) {
    final map = <String, FPSStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FPSStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FPSStats-objects as value to a dart map
  static Map<String, List<FPSStats>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FPSStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FPSStats.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'average_fps',
    'tracked',
  };
}
