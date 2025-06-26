//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoReactionsResponse {
  /// Returns a new [VideoReactionsResponse] instance.
  VideoReactionsResponse({
    this.countOverTime,
    required this.reaction,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VideoReactionOverTimeResponse? countOverTime;

  String reaction;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoReactionsResponse &&
          other.countOverTime == countOverTime &&
          other.reaction == reaction;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (countOverTime == null ? 0 : countOverTime!.hashCode) +
      (reaction.hashCode);

  @override
  String toString() =>
      'VideoReactionsResponse[countOverTime=$countOverTime, reaction=$reaction]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.countOverTime != null) {
      json[r'count_over_time'] = this.countOverTime;
    } else {
      json[r'count_over_time'] = null;
    }
    json[r'reaction'] = this.reaction;
    return json;
  }

  /// Returns a new [VideoReactionsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoReactionsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "VideoReactionsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "VideoReactionsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoReactionsResponse(
        countOverTime:
            VideoReactionOverTimeResponse.fromJson(json[r'count_over_time']),
        reaction: mapValueOfType<String>(json, r'reaction')!,
      );
    }
    return null;
  }

  static List<VideoReactionsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <VideoReactionsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoReactionsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoReactionsResponse> mapFromJson(dynamic json) {
    final map = <String, VideoReactionsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoReactionsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoReactionsResponse-objects as value to a dart map
  static Map<String, List<VideoReactionsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<VideoReactionsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoReactionsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'reaction',
  };
}
