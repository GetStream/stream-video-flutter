//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallSettingsResponse {
  /// Returns a new [CallSettingsResponse] instance.
  CallSettingsResponse({
    required this.audio,
    required this.backstage,
    required this.broadcasting,
    required this.geofencing,
    required this.limits,
    required this.recording,
    required this.ring,
    required this.screensharing,
    required this.thumbnails,
    required this.transcription,
    required this.video,
  });

  AudioSettingsResponse audio;

  BackstageSettingsResponse backstage;

  BroadcastSettingsResponse broadcasting;

  GeofenceSettingsResponse geofencing;

  LimitsSettingsResponse limits;

  RecordSettingsResponse recording;

  RingSettingsResponse ring;

  ScreensharingSettingsResponse screensharing;

  ThumbnailsSettingsResponse thumbnails;

  TranscriptionSettingsResponse transcription;

  VideoSettingsResponse video;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallSettingsResponse &&
    other.audio == audio &&
    other.backstage == backstage &&
    other.broadcasting == broadcasting &&
    other.geofencing == geofencing &&
    other.limits == limits &&
    other.recording == recording &&
    other.ring == ring &&
    other.screensharing == screensharing &&
    other.thumbnails == thumbnails &&
    other.transcription == transcription &&
    other.video == video;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audio.hashCode) +
    (backstage.hashCode) +
    (broadcasting.hashCode) +
    (geofencing.hashCode) +
    (limits.hashCode) +
    (recording.hashCode) +
    (ring.hashCode) +
    (screensharing.hashCode) +
    (thumbnails.hashCode) +
    (transcription.hashCode) +
    (video.hashCode);

  @override
  String toString() => 'CallSettingsResponse[audio=$audio, backstage=$backstage, broadcasting=$broadcasting, geofencing=$geofencing, limits=$limits, recording=$recording, ring=$ring, screensharing=$screensharing, thumbnails=$thumbnails, transcription=$transcription, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audio'] = this.audio;
      json[r'backstage'] = this.backstage;
      json[r'broadcasting'] = this.broadcasting;
      json[r'geofencing'] = this.geofencing;
      json[r'limits'] = this.limits;
      json[r'recording'] = this.recording;
      json[r'ring'] = this.ring;
      json[r'screensharing'] = this.screensharing;
      json[r'thumbnails'] = this.thumbnails;
      json[r'transcription'] = this.transcription;
      json[r'video'] = this.video;
    return json;
  }

  /// Returns a new [CallSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallSettingsResponse(
        audio: AudioSettingsResponse.fromJson(json[r'audio'])!,
        backstage: BackstageSettingsResponse.fromJson(json[r'backstage'])!,
        broadcasting: BroadcastSettingsResponse.fromJson(json[r'broadcasting'])!,
        geofencing: GeofenceSettingsResponse.fromJson(json[r'geofencing'])!,
        limits: LimitsSettingsResponse.fromJson(json[r'limits'])!,
        recording: RecordSettingsResponse.fromJson(json[r'recording'])!,
        ring: RingSettingsResponse.fromJson(json[r'ring'])!,
        screensharing: ScreensharingSettingsResponse.fromJson(json[r'screensharing'])!,
        thumbnails: ThumbnailsSettingsResponse.fromJson(json[r'thumbnails'])!,
        transcription: TranscriptionSettingsResponse.fromJson(json[r'transcription'])!,
        video: VideoSettingsResponse.fromJson(json[r'video'])!,
      );
    }
    return null;
  }

  static List<CallSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, CallSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallSettingsResponse-objects as value to a dart map
  static Map<String, List<CallSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio',
    'backstage',
    'broadcasting',
    'geofencing',
    'limits',
    'recording',
    'ring',
    'screensharing',
    'thumbnails',
    'transcription',
    'video',
  };
}

