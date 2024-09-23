//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ModerationPayload {
  /// Returns a new [ModerationPayload] instance.
  ModerationPayload({
    this.custom = const {},
    this.images = const [],
    this.texts = const [],
    this.videos = const [],
  });

  Map<String, Object> custom;

  List<String> images;

  List<String> texts;

  List<String> videos;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ModerationPayload &&
    _deepEquality.equals(other.custom, custom) &&
    _deepEquality.equals(other.images, images) &&
    _deepEquality.equals(other.texts, texts) &&
    _deepEquality.equals(other.videos, videos);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (images.hashCode) +
    (texts.hashCode) +
    (videos.hashCode);

  @override
  String toString() => 'ModerationPayload[custom=$custom, images=$images, texts=$texts, videos=$videos]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'images'] = this.images;
      json[r'texts'] = this.texts;
      json[r'videos'] = this.videos;
    return json;
  }

  /// Returns a new [ModerationPayload] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ModerationPayload? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ModerationPayload[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ModerationPayload[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ModerationPayload(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        images: json[r'images'] is Iterable
            ? (json[r'images'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        texts: json[r'texts'] is Iterable
            ? (json[r'texts'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        videos: json[r'videos'] is Iterable
            ? (json[r'videos'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ModerationPayload> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ModerationPayload>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ModerationPayload.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ModerationPayload> mapFromJson(dynamic json) {
    final map = <String, ModerationPayload>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ModerationPayload.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ModerationPayload-objects as value to a dart map
  static Map<String, List<ModerationPayload>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ModerationPayload>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ModerationPayload.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

