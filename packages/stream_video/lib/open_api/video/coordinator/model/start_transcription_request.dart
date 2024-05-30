//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartTranscriptionRequest {
  /// Returns a new [StartTranscriptionRequest] instance.
  StartTranscriptionRequest({
    this.transcriptionExternalStorage,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? transcriptionExternalStorage;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StartTranscriptionRequest &&
    other.transcriptionExternalStorage == transcriptionExternalStorage;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (transcriptionExternalStorage == null ? 0 : transcriptionExternalStorage!.hashCode);

  @override
  String toString() => 'StartTranscriptionRequest[transcriptionExternalStorage=$transcriptionExternalStorage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.transcriptionExternalStorage != null) {
      json[r'transcription_external_storage'] = this.transcriptionExternalStorage;
    } else {
      json[r'transcription_external_storage'] = null;
    }
    return json;
  }

  /// Returns a new [StartTranscriptionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartTranscriptionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StartTranscriptionRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StartTranscriptionRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartTranscriptionRequest(
        transcriptionExternalStorage: mapValueOfType<String>(json, r'transcription_external_storage'),
      );
    }
    return null;
  }

  static List<StartTranscriptionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartTranscriptionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartTranscriptionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartTranscriptionRequest> mapFromJson(dynamic json) {
    final map = <String, StartTranscriptionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartTranscriptionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartTranscriptionRequest-objects as value to a dart map
  static Map<String, List<StartTranscriptionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StartTranscriptionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartTranscriptionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

