//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallSettingsRequest {
  /// Returns a new [CallSettingsRequest] instance.
  CallSettingsRequest({
    this.audio,
    this.backstage,
    this.broadcasting,
    this.geofencing,
    this.recording,
    this.ring,
    this.screensharing,
    this.transcription,
    this.video,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AudioSettingsRequest? audio;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  BackstageSettingsRequest? backstage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  BroadcastSettingsRequest? broadcasting;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  GeofenceSettingsRequest? geofencing;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  RecordSettingsRequest? recording;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  RingSettingsRequest? ring;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ScreensharingSettingsRequest? screensharing;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TranscriptionSettingsRequest? transcription;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VideoSettingsRequest? video;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallSettingsRequest &&
     other.audio == audio &&
     other.backstage == backstage &&
     other.broadcasting == broadcasting &&
     other.geofencing == geofencing &&
     other.recording == recording &&
     other.ring == ring &&
     other.screensharing == screensharing &&
     other.transcription == transcription &&
     other.video == video;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audio == null ? 0 : audio!.hashCode) +
    (backstage == null ? 0 : backstage!.hashCode) +
    (broadcasting == null ? 0 : broadcasting!.hashCode) +
    (geofencing == null ? 0 : geofencing!.hashCode) +
    (recording == null ? 0 : recording!.hashCode) +
    (ring == null ? 0 : ring!.hashCode) +
    (screensharing == null ? 0 : screensharing!.hashCode) +
    (transcription == null ? 0 : transcription!.hashCode) +
    (video == null ? 0 : video!.hashCode);

  @override
  String toString() => 'CallSettingsRequest[audio=$audio, backstage=$backstage, broadcasting=$broadcasting, geofencing=$geofencing, recording=$recording, ring=$ring, screensharing=$screensharing, transcription=$transcription, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audio != null) {
      json[r'audio'] = this.audio;
    } else {
      json[r'audio'] = null;
    }
    if (this.backstage != null) {
      json[r'backstage'] = this.backstage;
    } else {
      json[r'backstage'] = null;
    }
    if (this.broadcasting != null) {
      json[r'broadcasting'] = this.broadcasting;
    } else {
      json[r'broadcasting'] = null;
    }
    if (this.geofencing != null) {
      json[r'geofencing'] = this.geofencing;
    } else {
      json[r'geofencing'] = null;
    }
    if (this.recording != null) {
      json[r'recording'] = this.recording;
    } else {
      json[r'recording'] = null;
    }
    if (this.ring != null) {
      json[r'ring'] = this.ring;
    } else {
      json[r'ring'] = null;
    }
    if (this.screensharing != null) {
      json[r'screensharing'] = this.screensharing;
    } else {
      json[r'screensharing'] = null;
    }
    if (this.transcription != null) {
      json[r'transcription'] = this.transcription;
    } else {
      json[r'transcription'] = null;
    }
    if (this.video != null) {
      json[r'video'] = this.video;
    } else {
      json[r'video'] = null;
    }
    return json;
  }

  /// Returns a new [CallSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallSettingsRequest(
        audio: AudioSettingsRequest.fromJson(json[r'audio']),
        backstage: BackstageSettingsRequest.fromJson(json[r'backstage']),
        broadcasting: BroadcastSettingsRequest.fromJson(json[r'broadcasting']),
        geofencing: GeofenceSettingsRequest.fromJson(json[r'geofencing']),
        recording: RecordSettingsRequest.fromJson(json[r'recording']),
        ring: RingSettingsRequest.fromJson(json[r'ring']),
        screensharing: ScreensharingSettingsRequest.fromJson(json[r'screensharing']),
        transcription: TranscriptionSettingsRequest.fromJson(json[r'transcription']),
        video: VideoSettingsRequest.fromJson(json[r'video']),
      );
    }
    return null;
  }

  static List<CallSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, CallSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSettingsRequest-objects as value to a dart map
  static Map<String, List<CallSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

