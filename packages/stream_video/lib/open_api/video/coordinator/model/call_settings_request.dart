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
    this.geofencing,
    this.recording,
    this.screensharing,
    this.video,
  });

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
  ScreensharingSettingsRequest? screensharing;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  VideoSettingsRequest? video;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallSettingsRequest &&
     other.geofencing == geofencing &&
     other.recording == recording &&
     other.screensharing == screensharing &&
     other.video == video;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (geofencing == null ? 0 : geofencing!.hashCode) +
    (recording == null ? 0 : recording!.hashCode) +
    (screensharing == null ? 0 : screensharing!.hashCode) +
    (video == null ? 0 : video!.hashCode);

  @override
  String toString() => 'CallSettingsRequest[geofencing=$geofencing, recording=$recording, screensharing=$screensharing, video=$video]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
    if (this.screensharing != null) {
      json[r'screensharing'] = this.screensharing;
    } else {
      json[r'screensharing'] = null;
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
        geofencing: GeofenceSettingsRequest.fromJson(json[r'geofencing']),
        recording: RecordSettingsRequest.fromJson(json[r'recording']),
        screensharing: ScreensharingSettingsRequest.fromJson(json[r'screensharing']),
        video: VideoSettingsRequest.fromJson(json[r'video']),
      );
    }
    return null;
  }

  static List<CallSettingsRequest>? listFromJson(dynamic json, {bool growable = false,}) {
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
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallSettingsRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

