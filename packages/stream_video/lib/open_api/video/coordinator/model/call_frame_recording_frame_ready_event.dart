//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallFrameRecordingFrameReadyEvent {
  /// Returns a new [CallFrameRecordingFrameReadyEvent] instance.
  CallFrameRecordingFrameReadyEvent({
    required this.callCid,
    required this.capturedAt,
    required this.createdAt,
    required this.egressId,
    required this.sessionId,
    required this.trackType,
    this.type = 'call.frame_recording_ready',
    required this.url,
    this.users = const {},
  });

  String callCid;

  /// The time the frame was captured
  DateTime capturedAt;

  DateTime createdAt;

  String egressId;

  /// Call session ID
  String sessionId;

  /// The type of the track frame was captured from (TRACK_TYPE_VIDEO|TRACK_TYPE_SCREEN_SHARE)
  String trackType;

  /// The type of event: \"call.frame_recording_ready\" in this case
  String type;

  /// The URL of the frame
  String url;

  /// The users in the frame
  Map<String, UserResponse> users;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallFrameRecordingFrameReadyEvent &&
          other.callCid == callCid &&
          other.capturedAt == capturedAt &&
          other.createdAt == createdAt &&
          other.egressId == egressId &&
          other.sessionId == sessionId &&
          other.trackType == trackType &&
          other.type == type &&
          other.url == url &&
          _deepEquality.equals(other.users, users);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (capturedAt.hashCode) +
      (createdAt.hashCode) +
      (egressId.hashCode) +
      (sessionId.hashCode) +
      (trackType.hashCode) +
      (type.hashCode) +
      (url.hashCode) +
      (users.hashCode);

  @override
  String toString() =>
      'CallFrameRecordingFrameReadyEvent[callCid=$callCid, capturedAt=$capturedAt, createdAt=$createdAt, egressId=$egressId, sessionId=$sessionId, trackType=$trackType, type=$type, url=$url, users=$users]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'captured_at'] = this.capturedAt.toUtc().toIso8601String();
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'egress_id'] = this.egressId;
    json[r'session_id'] = this.sessionId;
    json[r'track_type'] = this.trackType;
    json[r'type'] = this.type;
    json[r'url'] = this.url;
    json[r'users'] = this.users;
    return json;
  }

  /// Returns a new [CallFrameRecordingFrameReadyEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallFrameRecordingFrameReadyEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallFrameRecordingFrameReadyEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallFrameRecordingFrameReadyEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallFrameRecordingFrameReadyEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        capturedAt: mapDateTime(json, r'captured_at', r'')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        trackType: mapValueOfType<String>(json, r'track_type')!,
        type: mapValueOfType<String>(json, r'type')!,
        url: mapValueOfType<String>(json, r'url')!,
        users: UserResponse.mapFromJson(json[r'users']),
      );
    }
    return null;
  }

  static List<CallFrameRecordingFrameReadyEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallFrameRecordingFrameReadyEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallFrameRecordingFrameReadyEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallFrameRecordingFrameReadyEvent> mapFromJson(
      dynamic json) {
    final map = <String, CallFrameRecordingFrameReadyEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallFrameRecordingFrameReadyEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallFrameRecordingFrameReadyEvent-objects as value to a dart map
  static Map<String, List<CallFrameRecordingFrameReadyEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallFrameRecordingFrameReadyEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallFrameRecordingFrameReadyEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'captured_at',
    'created_at',
    'egress_id',
    'session_id',
    'track_type',
    'type',
    'url',
    'users',
  };
}
