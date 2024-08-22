//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ImageData {
  /// Returns a new [ImageData] instance.
  ImageData({
    required this.frames,
    required this.height,
    required this.size,
    required this.url,
    required this.width,
  });

  String frames;

  String height;

  String size;

  String url;

  String width;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ImageData &&
    other.frames == frames &&
    other.height == height &&
    other.size == size &&
    other.url == url &&
    other.width == width;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (frames.hashCode) +
    (height.hashCode) +
    (size.hashCode) +
    (url.hashCode) +
    (width.hashCode);

  @override
  String toString() => 'ImageData[frames=$frames, height=$height, size=$size, url=$url, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'frames'] = this.frames;
      json[r'height'] = this.height;
      json[r'size'] = this.size;
      json[r'url'] = this.url;
      json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [ImageData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ImageData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ImageData[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ImageData[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ImageData(
        frames: mapValueOfType<String>(json, r'frames')!,
        height: mapValueOfType<String>(json, r'height')!,
        size: mapValueOfType<String>(json, r'size')!,
        url: mapValueOfType<String>(json, r'url')!,
        width: mapValueOfType<String>(json, r'width')!,
      );
    }
    return null;
  }

  static List<ImageData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ImageData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ImageData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ImageData> mapFromJson(dynamic json) {
    final map = <String, ImageData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ImageData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ImageData-objects as value to a dart map
  static Map<String, List<ImageData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ImageData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ImageData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'frames',
    'height',
    'size',
    'url',
    'width',
  };
}

