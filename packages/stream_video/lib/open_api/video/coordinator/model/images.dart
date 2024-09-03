//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Images {
  /// Returns a new [Images] instance.
  Images({
    required this.fixedHeight,
    required this.fixedHeightDownsampled,
    required this.fixedHeightStill,
    required this.fixedWidth,
    required this.fixedWidthDownsampled,
    required this.fixedWidthStill,
    required this.original,
  });

  ImageData fixedHeight;

  ImageData fixedHeightDownsampled;

  ImageData fixedHeightStill;

  ImageData fixedWidth;

  ImageData fixedWidthDownsampled;

  ImageData fixedWidthStill;

  ImageData original;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Images &&
    other.fixedHeight == fixedHeight &&
    other.fixedHeightDownsampled == fixedHeightDownsampled &&
    other.fixedHeightStill == fixedHeightStill &&
    other.fixedWidth == fixedWidth &&
    other.fixedWidthDownsampled == fixedWidthDownsampled &&
    other.fixedWidthStill == fixedWidthStill &&
    other.original == original;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fixedHeight.hashCode) +
    (fixedHeightDownsampled.hashCode) +
    (fixedHeightStill.hashCode) +
    (fixedWidth.hashCode) +
    (fixedWidthDownsampled.hashCode) +
    (fixedWidthStill.hashCode) +
    (original.hashCode);

  @override
  String toString() => 'Images[fixedHeight=$fixedHeight, fixedHeightDownsampled=$fixedHeightDownsampled, fixedHeightStill=$fixedHeightStill, fixedWidth=$fixedWidth, fixedWidthDownsampled=$fixedWidthDownsampled, fixedWidthStill=$fixedWidthStill, original=$original]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fixed_height'] = this.fixedHeight;
      json[r'fixed_height_downsampled'] = this.fixedHeightDownsampled;
      json[r'fixed_height_still'] = this.fixedHeightStill;
      json[r'fixed_width'] = this.fixedWidth;
      json[r'fixed_width_downsampled'] = this.fixedWidthDownsampled;
      json[r'fixed_width_still'] = this.fixedWidthStill;
      json[r'original'] = this.original;
    return json;
  }

  /// Returns a new [Images] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Images? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Images[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Images[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Images(
        fixedHeight: ImageData.fromJson(json[r'fixed_height'])!,
        fixedHeightDownsampled: ImageData.fromJson(json[r'fixed_height_downsampled'])!,
        fixedHeightStill: ImageData.fromJson(json[r'fixed_height_still'])!,
        fixedWidth: ImageData.fromJson(json[r'fixed_width'])!,
        fixedWidthDownsampled: ImageData.fromJson(json[r'fixed_width_downsampled'])!,
        fixedWidthStill: ImageData.fromJson(json[r'fixed_width_still'])!,
        original: ImageData.fromJson(json[r'original'])!,
      );
    }
    return null;
  }

  static List<Images> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Images>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Images.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Images> mapFromJson(dynamic json) {
    final map = <String, Images>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Images.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Images-objects as value to a dart map
  static Map<String, List<Images>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Images>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Images.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fixed_height',
    'fixed_height_downsampled',
    'fixed_height_still',
    'fixed_width',
    'fixed_width_downsampled',
    'fixed_width_still',
    'original',
  };
}

