//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallDTMFEvent {
  /// Returns a new [CallDTMFEvent] instance.
  CallDTMFEvent({
    required this.callCid,
    required this.createdAt,
    required this.digit,
    required this.durationMs,
    required this.seqNumber,
    required this.timestamp,
    this.type = 'call.dtmf',
    required this.user,
  });

  String callCid;

  DateTime createdAt;

  /// The DTMF digit (0-9, *, #, A-D)
  String digit;

  /// Duration of the digit press in milliseconds
  int durationMs;

  /// Monotonically increasing sequence number for ordering DTMF events within a session
  int seqNumber;

  /// When the digit press ended and was detected
  DateTime timestamp;

  /// The type of event: \"call.dtmf\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallDTMFEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.digit == digit &&
          other.durationMs == durationMs &&
          other.seqNumber == seqNumber &&
          other.timestamp == timestamp &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (digit.hashCode) +
      (durationMs.hashCode) +
      (seqNumber.hashCode) +
      (timestamp.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'CallDTMFEvent[callCid=$callCid, createdAt=$createdAt, digit=$digit, durationMs=$durationMs, seqNumber=$seqNumber, timestamp=$timestamp, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'digit'] = this.digit;
    json[r'duration_ms'] = this.durationMs;
    json[r'seq_number'] = this.seqNumber;
    json[r'timestamp'] = this.timestamp.toUtc().toIso8601String();
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallDTMFEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallDTMFEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "CallDTMFEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "CallDTMFEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "CallDTMFEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "CallDTMFEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'digit'),
            'Required key "CallDTMFEvent[digit]" is missing from JSON.');
        assert(json[r'digit'] != null,
            'Required key "CallDTMFEvent[digit]" has a null value in JSON.');
        assert(json.containsKey(r'duration_ms'),
            'Required key "CallDTMFEvent[duration_ms]" is missing from JSON.');
        assert(json[r'duration_ms'] != null,
            'Required key "CallDTMFEvent[duration_ms]" has a null value in JSON.');
        assert(json.containsKey(r'seq_number'),
            'Required key "CallDTMFEvent[seq_number]" is missing from JSON.');
        assert(json[r'seq_number'] != null,
            'Required key "CallDTMFEvent[seq_number]" has a null value in JSON.');
        assert(json.containsKey(r'timestamp'),
            'Required key "CallDTMFEvent[timestamp]" is missing from JSON.');
        assert(json[r'timestamp'] != null,
            'Required key "CallDTMFEvent[timestamp]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "CallDTMFEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "CallDTMFEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "CallDTMFEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "CallDTMFEvent[user]" has a null value in JSON.');
        return true;
      }());

      return CallDTMFEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        digit: mapValueOfType<String>(json, r'digit')!,
        durationMs: mapValueOfType<int>(json, r'duration_ms')!,
        seqNumber: mapValueOfType<int>(json, r'seq_number')!,
        timestamp: mapDateTime(json, r'timestamp', r'')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallDTMFEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallDTMFEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallDTMFEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallDTMFEvent> mapFromJson(dynamic json) {
    final map = <String, CallDTMFEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallDTMFEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallDTMFEvent-objects as value to a dart map
  static Map<String, List<CallDTMFEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallDTMFEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallDTMFEvent.listFromJson(
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
    'digit',
    'duration_ms',
    'seq_number',
    'timestamp',
    'type',
    'user',
  };
}
