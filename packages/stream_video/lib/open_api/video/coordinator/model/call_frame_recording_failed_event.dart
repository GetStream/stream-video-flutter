//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallFrameRecordingFailedEvent {
  /// Returns a new [CallFrameRecordingFailedEvent] instance.
  CallFrameRecordingFailedEvent({
    required this.call,
    required this.callCid,
    required this.createdAt,
    required this.egressId,
    this.type = 'call.frame_recording_failed',
  });

  CallResponse call;

  String callCid;

  DateTime createdAt;

  String egressId;

  /// The type of event: \"call.frame_recording_failed\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallFrameRecordingFailedEvent &&
          other.call == call &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.egressId == egressId &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (call.hashCode) +
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (egressId.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallFrameRecordingFailedEvent[call=$call, callCid=$callCid, createdAt=$createdAt, egressId=$egressId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call'] = this.call;
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'egress_id'] = this.egressId;
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallFrameRecordingFailedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallFrameRecordingFailedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallFrameRecordingFailedEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallFrameRecordingFailedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallFrameRecordingFailedEvent(
        call: CallResponse.fromJson(json[r'call'])!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallFrameRecordingFailedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallFrameRecordingFailedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallFrameRecordingFailedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallFrameRecordingFailedEvent> mapFromJson(dynamic json) {
    final map = <String, CallFrameRecordingFailedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallFrameRecordingFailedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallFrameRecordingFailedEvent-objects as value to a dart map
  static Map<String, List<CallFrameRecordingFailedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallFrameRecordingFailedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallFrameRecordingFailedEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call',
    'call_cid',
    'created_at',
    'egress_id',
    'type',
  };
}
