//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TargetResolution {
  /// Returns a new [TargetResolution] instance.
  TargetResolution({
    required this.bitrate,
    required this.height,
    required this.width,
  });

  /// Maximum value: 6000000
  int bitrate;

  /// Minimum value: 240
  /// Maximum value: 2560
  int height;

  /// Minimum value: 240
  /// Maximum value: 2560
  int width;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TargetResolution &&
     other.bitrate == bitrate &&
     other.height == height &&
     other.width == width;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (bitrate.hashCode) +
    (height.hashCode) +
    (width.hashCode);

  @override
  String toString() => 'TargetResolution[bitrate=$bitrate, height=$height, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'bitrate'] = this.bitrate;
      json[r'height'] = this.height;
      json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [TargetResolution] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TargetResolution? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TargetResolution[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TargetResolution[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TargetResolution(
        bitrate: mapValueOfType<int>(json, r'bitrate')!,
        height: mapValueOfType<int>(json, r'height')!,
        width: mapValueOfType<int>(json, r'width')!,
      );
    }
    return null;
  }

  static List<TargetResolution> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TargetResolution>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TargetResolution.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TargetResolution> mapFromJson(dynamic json) {
    final map = <String, TargetResolution>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TargetResolution.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TargetResolution-objects as value to a dart map
  static Map<String, List<TargetResolution>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TargetResolution>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TargetResolution.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'bitrate',
    'height',
    'width',
  };
}

