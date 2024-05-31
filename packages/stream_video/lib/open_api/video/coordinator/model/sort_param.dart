//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SortParam {
  /// Returns a new [SortParam] instance.
  SortParam({
    this.direction,
    this.field,
  });

  /// Direction of sorting, -1 for descending, 1 for ascending
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? direction;

  /// Name of field to sort by
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? field;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SortParam &&
    other.direction == direction &&
    other.field == field;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (direction == null ? 0 : direction!.hashCode) +
    (field == null ? 0 : field!.hashCode);

  @override
  String toString() => 'SortParam[direction=$direction, field=$field]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.direction != null) {
      json[r'direction'] = this.direction;
    } else {
      json[r'direction'] = null;
    }
    if (this.field != null) {
      json[r'field'] = this.field;
    } else {
      json[r'field'] = null;
    }
    return json;
  }

  /// Returns a new [SortParam] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SortParam? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SortParam[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SortParam[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SortParam(
        direction: mapValueOfType<int>(json, r'direction'),
        field: mapValueOfType<String>(json, r'field'),
      );
    }
    return null;
  }

  static List<SortParam> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SortParam>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SortParam.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SortParam> mapFromJson(dynamic json) {
    final map = <String, SortParam>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SortParam.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SortParam-objects as value to a dart map
  static Map<String, List<SortParam>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SortParam>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SortParam.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

