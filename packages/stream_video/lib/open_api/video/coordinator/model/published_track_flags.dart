//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublishedTrackFlags {
  /// Returns a new [PublishedTrackFlags] instance.
  PublishedTrackFlags({
    required this.audio,
    required this.screenshare,
    required this.screenshareAudio,
    required this.video,
  });

  bool audio;

  bool screenshare;

  bool screenshareAudio;

  bool video;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublishedTrackFlags &&
          other.audio == audio &&
          other.screenshare == screenshare &&
          other.screenshareAudio == screenshareAudio &&
          other.video == video;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (audio.hashCode) +
      (screenshare.hashCode) +
      (screenshareAudio.hashCode) +
      (video.hashCode);

  @override
  String toString() =>
      'PublishedTrackFlags[audio=$audio, screenshare=$screenshare, screenshareAudio=$screenshareAudio, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'audio'] = this.audio;
    json[r'screenshare'] = this.screenshare;
    json[r'screenshare_audio'] = this.screenshareAudio;
    json[r'video'] = this.video;
    return json;
  }

  /// Returns a new [PublishedTrackFlags] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublishedTrackFlags? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "PublishedTrackFlags[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "PublishedTrackFlags[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublishedTrackFlags(
        audio: mapValueOfType<bool>(json, r'audio')!,
        screenshare: mapValueOfType<bool>(json, r'screenshare')!,
        screenshareAudio: mapValueOfType<bool>(json, r'screenshare_audio')!,
        video: mapValueOfType<bool>(json, r'video')!,
      );
    }
    return null;
  }

  static List<PublishedTrackFlags> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PublishedTrackFlags>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublishedTrackFlags.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublishedTrackFlags> mapFromJson(dynamic json) {
    final map = <String, PublishedTrackFlags>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublishedTrackFlags.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublishedTrackFlags-objects as value to a dart map
  static Map<String, List<PublishedTrackFlags>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PublishedTrackFlags>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublishedTrackFlags.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio',
    'screenshare',
    'screenshare_audio',
    'video',
  };
}
