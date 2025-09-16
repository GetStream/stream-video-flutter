//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressSettingsResponse {
  /// Returns a new [IngressSettingsResponse] instance.
  IngressSettingsResponse({
    this.audioEncodingOptions,
    required this.enabled,
    this.videoEncodingOptions = const {},
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  IngressAudioEncodingResponse? audioEncodingOptions;

  bool enabled;

  Map<String, IngressVideoEncodingResponse> videoEncodingOptions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressSettingsResponse &&
          other.audioEncodingOptions == audioEncodingOptions &&
          other.enabled == enabled &&
          _deepEquality.equals(
              other.videoEncodingOptions, videoEncodingOptions);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (audioEncodingOptions == null ? 0 : audioEncodingOptions!.hashCode) +
      (enabled.hashCode) +
      (videoEncodingOptions.hashCode);

  @override
  String toString() =>
      'IngressSettingsResponse[audioEncodingOptions=$audioEncodingOptions, enabled=$enabled, videoEncodingOptions=$videoEncodingOptions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audioEncodingOptions != null) {
      json[r'audio_encoding_options'] = this.audioEncodingOptions;
    } else {
      json[r'audio_encoding_options'] = null;
    }
    json[r'enabled'] = this.enabled;
    json[r'video_encoding_options'] = this.videoEncodingOptions;
    return json;
  }

  /// Returns a new [IngressSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IngressSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IngressSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngressSettingsResponse(
        audioEncodingOptions: IngressAudioEncodingResponse.fromJson(
            json[r'audio_encoding_options']),
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        videoEncodingOptions: IngressVideoEncodingResponse.mapFromJson(
            json[r'video_encoding_options']),
      );
    }
    return null;
  }

  static List<IngressSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, IngressSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressSettingsResponse-objects as value to a dart map
  static Map<String, List<IngressSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressSettingsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
  };
}
