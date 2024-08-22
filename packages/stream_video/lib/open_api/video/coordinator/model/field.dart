//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Field {
  /// Returns a new [Field] instance.
  Field({
    required this.short,
    required this.title,
    required this.value,
  });

  bool short;

  String title;

  String value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Field &&
    other.short == short &&
    other.title == title &&
    other.value == value;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (short.hashCode) +
    (title.hashCode) +
    (value.hashCode);

  @override
  String toString() => 'Field[short=$short, title=$title, value=$value]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'short'] = this.short;
      json[r'title'] = this.title;
      json[r'value'] = this.value;
    return json;
  }

  /// Returns a new [Field] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Field? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Field[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Field[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Field(
        short: mapValueOfType<bool>(json, r'short')!,
        title: mapValueOfType<String>(json, r'title')!,
        value: mapValueOfType<String>(json, r'value')!,
      );
    }
    return null;
  }

  static List<Field> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Field>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Field.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Field> mapFromJson(dynamic json) {
    final map = <String, Field>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Field.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Field-objects as value to a dart map
  static Map<String, List<Field>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Field>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Field.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'short',
    'title',
    'value',
  };
}

