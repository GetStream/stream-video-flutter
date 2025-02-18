//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartClosedCaptionsRequest {
  /// Returns a new [StartClosedCaptionsRequest] instance.
  StartClosedCaptionsRequest({
    this.enableTranscription,
    this.externalStorage,
    this.language,
  });

  /// Enable transcriptions along with closed captions
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enableTranscription;

  /// Which external storage to use for transcriptions (only applicable if enable_transcription is true)
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? externalStorage;

  /// The spoken language in the call, if not provided the language defined in the transcription settings will be used
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? language;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartClosedCaptionsRequest &&
          other.enableTranscription == enableTranscription &&
          other.externalStorage == externalStorage &&
          other.language == language;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (enableTranscription == null ? 0 : enableTranscription!.hashCode) +
      (externalStorage == null ? 0 : externalStorage!.hashCode) +
      (language == null ? 0 : language!.hashCode);

  @override
  String toString() =>
      'StartClosedCaptionsRequest[enableTranscription=$enableTranscription, externalStorage=$externalStorage, language=$language]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.enableTranscription != null) {
      json[r'enable_transcription'] = this.enableTranscription;
    } else {
      json[r'enable_transcription'] = null;
    }
    if (this.externalStorage != null) {
      json[r'external_storage'] = this.externalStorage;
    } else {
      json[r'external_storage'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    return json;
  }

  /// Returns a new [StartClosedCaptionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartClosedCaptionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "StartClosedCaptionsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "StartClosedCaptionsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartClosedCaptionsRequest(
        enableTranscription:
            mapValueOfType<bool>(json, r'enable_transcription'),
        externalStorage: mapValueOfType<String>(json, r'external_storage'),
        language: mapValueOfType<String>(json, r'language'),
      );
    }
    return null;
  }

  static List<StartClosedCaptionsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StartClosedCaptionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartClosedCaptionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartClosedCaptionsRequest> mapFromJson(dynamic json) {
    final map = <String, StartClosedCaptionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartClosedCaptionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartClosedCaptionsRequest-objects as value to a dart map
  static Map<String, List<StartClosedCaptionsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<StartClosedCaptionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartClosedCaptionsRequest.listFromJson(
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
