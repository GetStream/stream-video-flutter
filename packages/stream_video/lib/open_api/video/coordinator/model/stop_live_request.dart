//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StopLiveRequest {
  /// Returns a new [StopLiveRequest] instance.
  StopLiveRequest({
    this.continueClosedCaption,
    this.continueHls,
    this.continueRecording,
    this.continueRtmpBroadcasts,
    this.continueTranscription,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? continueClosedCaption;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? continueHls;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? continueRecording;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? continueRtmpBroadcasts;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? continueTranscription;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopLiveRequest &&
          other.continueClosedCaption == continueClosedCaption &&
          other.continueHls == continueHls &&
          other.continueRecording == continueRecording &&
          other.continueRtmpBroadcasts == continueRtmpBroadcasts &&
          other.continueTranscription == continueTranscription;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (continueClosedCaption == null ? 0 : continueClosedCaption!.hashCode) +
      (continueHls == null ? 0 : continueHls!.hashCode) +
      (continueRecording == null ? 0 : continueRecording!.hashCode) +
      (continueRtmpBroadcasts == null ? 0 : continueRtmpBroadcasts!.hashCode) +
      (continueTranscription == null ? 0 : continueTranscription!.hashCode);

  @override
  String toString() =>
      'StopLiveRequest[continueClosedCaption=$continueClosedCaption, continueHls=$continueHls, continueRecording=$continueRecording, continueRtmpBroadcasts=$continueRtmpBroadcasts, continueTranscription=$continueTranscription]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.continueClosedCaption != null) {
      json[r'continue_closed_caption'] = this.continueClosedCaption;
    } else {
      json[r'continue_closed_caption'] = null;
    }
    if (this.continueHls != null) {
      json[r'continue_hls'] = this.continueHls;
    } else {
      json[r'continue_hls'] = null;
    }
    if (this.continueRecording != null) {
      json[r'continue_recording'] = this.continueRecording;
    } else {
      json[r'continue_recording'] = null;
    }
    if (this.continueRtmpBroadcasts != null) {
      json[r'continue_rtmp_broadcasts'] = this.continueRtmpBroadcasts;
    } else {
      json[r'continue_rtmp_broadcasts'] = null;
    }
    if (this.continueTranscription != null) {
      json[r'continue_transcription'] = this.continueTranscription;
    } else {
      json[r'continue_transcription'] = null;
    }
    return json;
  }

  /// Returns a new [StopLiveRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StopLiveRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "StopLiveRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "StopLiveRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StopLiveRequest(
        continueClosedCaption:
            mapValueOfType<bool>(json, r'continue_closed_caption'),
        continueHls: mapValueOfType<bool>(json, r'continue_hls'),
        continueRecording: mapValueOfType<bool>(json, r'continue_recording'),
        continueRtmpBroadcasts:
            mapValueOfType<bool>(json, r'continue_rtmp_broadcasts'),
        continueTranscription:
            mapValueOfType<bool>(json, r'continue_transcription'),
      );
    }
    return null;
  }

  static List<StopLiveRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StopLiveRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StopLiveRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StopLiveRequest> mapFromJson(dynamic json) {
    final map = <String, StopLiveRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StopLiveRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StopLiveRequest-objects as value to a dart map
  static Map<String, List<StopLiveRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<StopLiveRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StopLiveRequest.listFromJson(
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
