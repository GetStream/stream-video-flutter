//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallRecordingReadyEvent {
  /// Returns a new [CallRecordingReadyEvent] instance.
  CallRecordingReadyEvent({
    required this.callCid,
    required this.callRecording,
    required this.createdAt,
    this.type = 'call.recording_ready',
  });

  String callCid;

  CallRecording callRecording;

  DateTime createdAt;

  /// The type of event: \"call.recording_ready\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallRecordingReadyEvent &&
     other.callCid == callCid &&
     other.callRecording == callRecording &&
     other.createdAt == createdAt &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callCid.hashCode) +
    (callRecording.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallRecordingReadyEvent[callCid=$callCid, callRecording=$callRecording, createdAt=$createdAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_cid'] = this.callCid;
      json[r'call_recording'] = this.callRecording;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallRecordingReadyEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallRecordingReadyEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallRecordingReadyEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallRecordingReadyEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallRecordingReadyEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallRecordingReadyEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallRecordingReadyEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRecordingReadyEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallRecordingReadyEvent> mapFromJson(dynamic json) {
    final map = <String, CallRecordingReadyEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallRecordingReadyEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallRecordingReadyEvent-objects as value to a dart map
  static Map<String, List<CallRecordingReadyEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallRecordingReadyEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallRecordingReadyEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'call_recording',
    'created_at',
    'type',
  };
}

