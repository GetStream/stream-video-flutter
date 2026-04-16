//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SpeechSegmentConfig {
  /// Returns a new [SpeechSegmentConfig] instance.
  SpeechSegmentConfig({
    this.maxSpeechCaptionMs,
    this.silenceDurationMs,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxSpeechCaptionMs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? silenceDurationMs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeechSegmentConfig &&
          other.maxSpeechCaptionMs == maxSpeechCaptionMs &&
          other.silenceDurationMs == silenceDurationMs;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (maxSpeechCaptionMs == null ? 0 : maxSpeechCaptionMs!.hashCode) +
      (silenceDurationMs == null ? 0 : silenceDurationMs!.hashCode);

  @override
  String toString() =>
      'SpeechSegmentConfig[maxSpeechCaptionMs=$maxSpeechCaptionMs, silenceDurationMs=$silenceDurationMs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.maxSpeechCaptionMs != null) {
      json[r'max_speech_caption_ms'] = this.maxSpeechCaptionMs;
    } else {
      json[r'max_speech_caption_ms'] = null;
    }
    if (this.silenceDurationMs != null) {
      json[r'silence_duration_ms'] = this.silenceDurationMs;
    } else {
      json[r'silence_duration_ms'] = null;
    }
    return json;
  }

  /// Returns a new [SpeechSegmentConfig] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SpeechSegmentConfig? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return SpeechSegmentConfig(
        maxSpeechCaptionMs: mapValueOfType<int>(json, r'max_speech_caption_ms'),
        silenceDurationMs: mapValueOfType<int>(json, r'silence_duration_ms'),
      );
    }
    return null;
  }

  static List<SpeechSegmentConfig> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SpeechSegmentConfig>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SpeechSegmentConfig.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SpeechSegmentConfig> mapFromJson(dynamic json) {
    final map = <String, SpeechSegmentConfig>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SpeechSegmentConfig.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SpeechSegmentConfig-objects as value to a dart map
  static Map<String, List<SpeechSegmentConfig>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SpeechSegmentConfig>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SpeechSegmentConfig.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
