//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NullTime {
  /// Returns a new [NullTime] instance.
  NullTime({
    this.hasValue,
    this.value,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? hasValue;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NullTime &&
    other.hasValue == hasValue &&
    other.value == value;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (hasValue == null ? 0 : hasValue!.hashCode) +
    (value == null ? 0 : value!.hashCode);

  @override
  String toString() => 'NullTime[hasValue=$hasValue, value=$value]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.hasValue != null) {
      json[r'HasValue'] = this.hasValue;
    } else {
      json[r'HasValue'] = null;
    }
    if (this.value != null) {
      json[r'Value'] = this.value!.toUtc().toIso8601String();
    } else {
      json[r'Value'] = null;
    }
    return json;
  }

  /// Returns a new [NullTime] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NullTime? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "NullTime[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "NullTime[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NullTime(
        hasValue: mapValueOfType<bool>(json, r'HasValue'),
        value: mapDateTime(json, r'Value', r''),
      );
    }
    return null;
  }

  static List<NullTime> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NullTime>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NullTime.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NullTime> mapFromJson(dynamic json) {
    final map = <String, NullTime>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NullTime.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NullTime-objects as value to a dart map
  static Map<String, List<NullTime>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NullTime>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NullTime.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

