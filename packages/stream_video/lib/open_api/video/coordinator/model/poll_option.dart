//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PollOption {
  /// Returns a new [PollOption] instance.
  PollOption({
    this.custom = const {},
    required this.id,
    required this.text,
  });

  Map<String, Object> custom;

  String id;

  String text;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PollOption &&
    _deepEquality.equals(other.custom, custom) &&
    other.id == id &&
    other.text == text;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (id.hashCode) +
    (text.hashCode);

  @override
  String toString() => 'PollOption[custom=$custom, id=$id, text=$text]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'id'] = this.id;
      json[r'text'] = this.text;
    return json;
  }

  /// Returns a new [PollOption] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PollOption? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PollOption[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PollOption[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PollOption(
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        id: mapValueOfType<String>(json, r'id')!,
        text: mapValueOfType<String>(json, r'text')!,
      );
    }
    return null;
  }

  static List<PollOption> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PollOption>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PollOption.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PollOption> mapFromJson(dynamic json) {
    final map = <String, PollOption>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PollOption.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PollOption-objects as value to a dart map
  static Map<String, List<PollOption>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PollOption>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PollOption.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'custom',
    'id',
    'text',
  };
}

