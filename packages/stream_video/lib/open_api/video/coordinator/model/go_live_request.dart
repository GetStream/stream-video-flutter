//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GoLiveRequest {
  /// Returns a new [GoLiveRequest] instance.
  GoLiveRequest({
    this.recordingStorageName,
    this.startHls,
    this.startRecording,
    this.startRtmpBroadcasts,
    this.startTranscription,
    this.transcriptionStorageName,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? recordingStorageName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? startHls;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? startRecording;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? startRtmpBroadcasts;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? startTranscription;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? transcriptionStorageName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GoLiveRequest &&
    other.recordingStorageName == recordingStorageName &&
    other.startHls == startHls &&
    other.startRecording == startRecording &&
    other.startRtmpBroadcasts == startRtmpBroadcasts &&
    other.startTranscription == startTranscription &&
    other.transcriptionStorageName == transcriptionStorageName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (recordingStorageName == null ? 0 : recordingStorageName!.hashCode) +
    (startHls == null ? 0 : startHls!.hashCode) +
    (startRecording == null ? 0 : startRecording!.hashCode) +
    (startRtmpBroadcasts == null ? 0 : startRtmpBroadcasts!.hashCode) +
    (startTranscription == null ? 0 : startTranscription!.hashCode) +
    (transcriptionStorageName == null ? 0 : transcriptionStorageName!.hashCode);

  @override
  String toString() => 'GoLiveRequest[recordingStorageName=$recordingStorageName, startHls=$startHls, startRecording=$startRecording, startRtmpBroadcasts=$startRtmpBroadcasts, startTranscription=$startTranscription, transcriptionStorageName=$transcriptionStorageName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.recordingStorageName != null) {
      json[r'recording_storage_name'] = this.recordingStorageName;
    } else {
      json[r'recording_storage_name'] = null;
    }
    if (this.startHls != null) {
      json[r'start_hls'] = this.startHls;
    } else {
      json[r'start_hls'] = null;
    }
    if (this.startRecording != null) {
      json[r'start_recording'] = this.startRecording;
    } else {
      json[r'start_recording'] = null;
    }
    if (this.startRtmpBroadcasts != null) {
      json[r'start_rtmp_broadcasts'] = this.startRtmpBroadcasts;
    } else {
      json[r'start_rtmp_broadcasts'] = null;
    }
    if (this.startTranscription != null) {
      json[r'start_transcription'] = this.startTranscription;
    } else {
      json[r'start_transcription'] = null;
    }
    if (this.transcriptionStorageName != null) {
      json[r'transcription_storage_name'] = this.transcriptionStorageName;
    } else {
      json[r'transcription_storage_name'] = null;
    }
    return json;
  }

  /// Returns a new [GoLiveRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GoLiveRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GoLiveRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GoLiveRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GoLiveRequest(
        recordingStorageName: mapValueOfType<String>(json, r'recording_storage_name'),
        startHls: mapValueOfType<bool>(json, r'start_hls'),
        startRecording: mapValueOfType<bool>(json, r'start_recording'),
        startRtmpBroadcasts: mapValueOfType<bool>(json, r'start_rtmp_broadcasts'),
        startTranscription: mapValueOfType<bool>(json, r'start_transcription'),
        transcriptionStorageName: mapValueOfType<String>(json, r'transcription_storage_name'),
      );
    }
    return null;
  }

  static List<GoLiveRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GoLiveRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GoLiveRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GoLiveRequest> mapFromJson(dynamic json) {
    final map = <String, GoLiveRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GoLiveRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GoLiveRequest-objects as value to a dart map
  static Map<String, List<GoLiveRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GoLiveRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GoLiveRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

