//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoDimension {
  /// Returns a new [VideoDimension] instance.
  VideoDimension({
    required this.height,
    required this.width,
  });

  int height;

  int width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoDimension && other.height == height && other.width == width;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (height.hashCode) + (width.hashCode);

  @override
  String toString() => 'VideoDimension[height=$height, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'height'] = this.height;
    json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [VideoDimension] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoDimension? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "VideoDimension[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "VideoDimension[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoDimension(
        height: mapValueOfType<int>(json, r'height')!,
        width: mapValueOfType<int>(json, r'width')!,
      );
    }
    return null;
  }

  static List<VideoDimension> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <VideoDimension>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoDimension.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoDimension> mapFromJson(dynamic json) {
    final map = <String, VideoDimension>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoDimension.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoDimension-objects as value to a dart map
  static Map<String, List<VideoDimension>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<VideoDimension>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoDimension.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'height',
    'width',
  };
}
