//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ThumbnailResponse {
  /// Returns a new [ThumbnailResponse] instance.
  ThumbnailResponse({
    required this.imageUrl,
  });

  String imageUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThumbnailResponse &&
    other.imageUrl == imageUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (imageUrl.hashCode);

  @override
  String toString() => 'ThumbnailResponse[imageUrl=$imageUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'image_url'] = this.imageUrl;
    return json;
  }

  /// Returns a new [ThumbnailResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ThumbnailResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ThumbnailResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ThumbnailResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ThumbnailResponse(
        imageUrl: mapValueOfType<String>(json, r'image_url')!,
      );
    }
    return null;
  }

  static List<ThumbnailResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ThumbnailResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ThumbnailResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ThumbnailResponse> mapFromJson(dynamic json) {
    final map = <String, ThumbnailResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ThumbnailResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ThumbnailResponse-objects as value to a dart map
  static Map<String, List<ThumbnailResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ThumbnailResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ThumbnailResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'image_url',
  };
}

