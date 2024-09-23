//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LabelThresholds {
  /// Returns a new [LabelThresholds] instance.
  LabelThresholds({
    this.block,
    this.flag,
  });

  /// Minimum value: 0
  /// Maximum value: 1
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? block;

  /// Minimum value: 0
  /// Maximum value: 1
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? flag;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LabelThresholds &&
    other.block == block &&
    other.flag == flag;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (block == null ? 0 : block!.hashCode) +
    (flag == null ? 0 : flag!.hashCode);

  @override
  String toString() => 'LabelThresholds[block=$block, flag=$flag]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.block != null) {
      json[r'block'] = this.block;
    } else {
      json[r'block'] = null;
    }
    if (this.flag != null) {
      json[r'flag'] = this.flag;
    } else {
      json[r'flag'] = null;
    }
    return json;
  }

  /// Returns a new [LabelThresholds] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LabelThresholds? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LabelThresholds[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LabelThresholds[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LabelThresholds(
        block: mapValueOfType<double>(json, r'block'),
        flag: mapValueOfType<double>(json, r'flag'),
      );
    }
    return null;
  }

  static List<LabelThresholds> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LabelThresholds>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LabelThresholds.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LabelThresholds> mapFromJson(dynamic json) {
    final map = <String, LabelThresholds>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LabelThresholds.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LabelThresholds-objects as value to a dart map
  static Map<String, List<LabelThresholds>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LabelThresholds>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LabelThresholds.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

