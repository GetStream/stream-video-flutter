//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallTranscriptionFailedEvent {
  /// Returns a new [CallTranscriptionFailedEvent] instance.
  CallTranscriptionFailedEvent({
    required this.callCid,
    required this.createdAt,
    required this.egressId,
    this.error,
    this.type = 'call.transcription_failed',
  });

  String callCid;

  DateTime createdAt;

  String egressId;

  /// The error message detailing why transcription failed.
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? error;

  /// The type of event: \"call.transcription_failed\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallTranscriptionFailedEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.egressId == egressId &&
          other.error == error &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (egressId.hashCode) +
      (error == null ? 0 : error!.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallTranscriptionFailedEvent[callCid=$callCid, createdAt=$createdAt, egressId=$egressId, error=$error, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'egress_id'] = this.egressId;
    if (this.error != null) {
      json[r'error'] = this.error;
    } else {
      json[r'error'] = null;
    }
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallTranscriptionFailedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallTranscriptionFailedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallTranscriptionFailedEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallTranscriptionFailedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallTranscriptionFailedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        error: mapValueOfType<String>(json, r'error'),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallTranscriptionFailedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallTranscriptionFailedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallTranscriptionFailedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallTranscriptionFailedEvent> mapFromJson(dynamic json) {
    final map = <String, CallTranscriptionFailedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallTranscriptionFailedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallTranscriptionFailedEvent-objects as value to a dart map
  static Map<String, List<CallTranscriptionFailedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallTranscriptionFailedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallTranscriptionFailedEvent.listFromJson(
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
    'created_at',
    'egress_id',
    'type',
  };
}
