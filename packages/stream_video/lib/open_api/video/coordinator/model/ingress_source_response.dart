//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressSourceResponse {
  /// Returns a new [IngressSourceResponse] instance.
  IngressSourceResponse({
    required this.fps,
    required this.height,
    required this.width,
  });

  int fps;

  int height;

  int width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressSourceResponse &&
          other.fps == fps &&
          other.height == height &&
          other.width == width;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (fps.hashCode) + (height.hashCode) + (width.hashCode);

  @override
  String toString() =>
      'IngressSourceResponse[fps=$fps, height=$height, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'fps'] = this.fps;
    json[r'height'] = this.height;
    json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [IngressSourceResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressSourceResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fps'),
            'Required key "IngressSourceResponse[fps]" is missing from JSON.');
        assert(json[r'fps'] != null,
            'Required key "IngressSourceResponse[fps]" has a null value in JSON.');
        assert(json.containsKey(r'height'),
            'Required key "IngressSourceResponse[height]" is missing from JSON.');
        assert(json[r'height'] != null,
            'Required key "IngressSourceResponse[height]" has a null value in JSON.');
        assert(json.containsKey(r'width'),
            'Required key "IngressSourceResponse[width]" is missing from JSON.');
        assert(json[r'width'] != null,
            'Required key "IngressSourceResponse[width]" has a null value in JSON.');
        return true;
      }());

      return IngressSourceResponse(
        fps: mapValueOfType<int>(json, r'fps')!,
        height: mapValueOfType<int>(json, r'height')!,
        width: mapValueOfType<int>(json, r'width')!,
      );
    }
    return null;
  }

  static List<IngressSourceResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressSourceResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressSourceResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressSourceResponse> mapFromJson(dynamic json) {
    final map = <String, IngressSourceResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressSourceResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressSourceResponse-objects as value to a dart map
  static Map<String, List<IngressSourceResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressSourceResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressSourceResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fps',
    'height',
    'width',
  };
}
