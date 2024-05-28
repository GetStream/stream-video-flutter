//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MediaPubSubHint {
  /// Returns a new [MediaPubSubHint] instance.
  MediaPubSubHint({
    required this.audioPublished,
    required this.audioSubscribed,
    required this.videoPublished,
    required this.videoSubscribed,
  });

  bool audioPublished;

  bool audioSubscribed;

  bool videoPublished;

  bool videoSubscribed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MediaPubSubHint &&
    other.audioPublished == audioPublished &&
    other.audioSubscribed == audioSubscribed &&
    other.videoPublished == videoPublished &&
    other.videoSubscribed == videoSubscribed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioPublished.hashCode) +
    (audioSubscribed.hashCode) +
    (videoPublished.hashCode) +
    (videoSubscribed.hashCode);

  @override
  String toString() => 'MediaPubSubHint[audioPublished=$audioPublished, audioSubscribed=$audioSubscribed, videoPublished=$videoPublished, videoSubscribed=$videoSubscribed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audio_published'] = this.audioPublished;
      json[r'audio_subscribed'] = this.audioSubscribed;
      json[r'video_published'] = this.videoPublished;
      json[r'video_subscribed'] = this.videoSubscribed;
    return json;
  }

  /// Returns a new [MediaPubSubHint] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MediaPubSubHint? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MediaPubSubHint[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MediaPubSubHint[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MediaPubSubHint(
        audioPublished: mapValueOfType<bool>(json, r'audio_published')!,
        audioSubscribed: mapValueOfType<bool>(json, r'audio_subscribed')!,
        videoPublished: mapValueOfType<bool>(json, r'video_published')!,
        videoSubscribed: mapValueOfType<bool>(json, r'video_subscribed')!,
      );
    }
    return null;
  }

  static List<MediaPubSubHint> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MediaPubSubHint>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MediaPubSubHint.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MediaPubSubHint> mapFromJson(dynamic json) {
    final map = <String, MediaPubSubHint>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MediaPubSubHint.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MediaPubSubHint-objects as value to a dart map
  static Map<String, List<MediaPubSubHint>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MediaPubSubHint>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MediaPubSubHint.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio_published',
    'audio_subscribed',
    'video_published',
    'video_subscribed',
  };
}

