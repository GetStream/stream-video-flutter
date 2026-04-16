//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSCallEvent {
  /// Returns a new [WSCallEvent] instance.
  WSCallEvent({
    required this.callCid,
    required this.createdAt,
    required this.digit,
    required this.durationMs,
    required this.seqNumber,
    required this.timestamp,
    this.type = 'ingress.stopped',
    required this.user,
    this.code,
    required this.error,
    required this.ingressStreamId,
    required this.userId,
    this.clientIp,
    this.clientName,
    required this.publisherType,
    this.version,
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

  /// The type of event: \"ingress.stopped\" in this case
  String type;

  UserResponse user;

  /// Error code
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? code;

  /// Human-readable error message
  String error;

  /// Unique identifier for the stream
  String ingressStreamId;

  /// User who was streaming
  String userId;

  /// Client IP address
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientIp;

  /// Streaming client software name (e.g., 'OBS Studio')
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientName;

  /// Streaming protocol (e.g., 'rtmps', 'srt', 'rtmp', 'rtsp')
  String publisherType;

  /// Client software version
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? version;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WSCallEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.digit == digit &&
          other.durationMs == durationMs &&
          other.seqNumber == seqNumber &&
          other.timestamp == timestamp &&
          other.type == type &&
          other.user == user &&
          other.code == code &&
          other.error == error &&
          other.ingressStreamId == ingressStreamId &&
          other.userId == userId &&
          other.clientIp == clientIp &&
          other.clientName == clientName &&
          other.publisherType == publisherType &&
          other.version == version;

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
      (user.hashCode) +
      (code == null ? 0 : code!.hashCode) +
      (error.hashCode) +
      (ingressStreamId.hashCode) +
      (userId.hashCode) +
      (clientIp == null ? 0 : clientIp!.hashCode) +
      (clientName == null ? 0 : clientName!.hashCode) +
      (publisherType.hashCode) +
      (version == null ? 0 : version!.hashCode);

  @override
  String toString() =>
      'WSCallEvent[callCid=$callCid, createdAt=$createdAt, digit=$digit, durationMs=$durationMs, seqNumber=$seqNumber, timestamp=$timestamp, type=$type, user=$user, code=$code, error=$error, ingressStreamId=$ingressStreamId, userId=$userId, clientIp=$clientIp, clientName=$clientName, publisherType=$publisherType, version=$version]';

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
    if (this.code != null) {
      json[r'code'] = this.code;
    } else {
      json[r'code'] = null;
    }
    json[r'error'] = this.error;
    json[r'ingress_stream_id'] = this.ingressStreamId;
    json[r'user_id'] = this.userId;
    if (this.clientIp != null) {
      json[r'client_ip'] = this.clientIp;
    } else {
      json[r'client_ip'] = null;
    }
    if (this.clientName != null) {
      json[r'client_name'] = this.clientName;
    } else {
      json[r'client_name'] = null;
    }
    json[r'publisher_type'] = this.publisherType;
    if (this.version != null) {
      json[r'version'] = this.version;
    } else {
      json[r'version'] = null;
    }
    return json;
  }

  /// Returns a new [WSCallEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WSCallEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "WSCallEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "WSCallEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "WSCallEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "WSCallEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'digit'),
            'Required key "WSCallEvent[digit]" is missing from JSON.');
        assert(json[r'digit'] != null,
            'Required key "WSCallEvent[digit]" has a null value in JSON.');
        assert(json.containsKey(r'duration_ms'),
            'Required key "WSCallEvent[duration_ms]" is missing from JSON.');
        assert(json[r'duration_ms'] != null,
            'Required key "WSCallEvent[duration_ms]" has a null value in JSON.');
        assert(json.containsKey(r'seq_number'),
            'Required key "WSCallEvent[seq_number]" is missing from JSON.');
        assert(json[r'seq_number'] != null,
            'Required key "WSCallEvent[seq_number]" has a null value in JSON.');
        assert(json.containsKey(r'timestamp'),
            'Required key "WSCallEvent[timestamp]" is missing from JSON.');
        assert(json[r'timestamp'] != null,
            'Required key "WSCallEvent[timestamp]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "WSCallEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "WSCallEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "WSCallEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "WSCallEvent[user]" has a null value in JSON.');
        assert(json.containsKey(r'error'),
            'Required key "WSCallEvent[error]" is missing from JSON.');
        assert(json[r'error'] != null,
            'Required key "WSCallEvent[error]" has a null value in JSON.');
        assert(json.containsKey(r'ingress_stream_id'),
            'Required key "WSCallEvent[ingress_stream_id]" is missing from JSON.');
        assert(json[r'ingress_stream_id'] != null,
            'Required key "WSCallEvent[ingress_stream_id]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "WSCallEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "WSCallEvent[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'publisher_type'),
            'Required key "WSCallEvent[publisher_type]" is missing from JSON.');
        assert(json[r'publisher_type'] != null,
            'Required key "WSCallEvent[publisher_type]" has a null value in JSON.');
        return true;
      }());

      return WSCallEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        digit: mapValueOfType<String>(json, r'digit')!,
        durationMs: mapValueOfType<int>(json, r'duration_ms')!,
        seqNumber: mapValueOfType<int>(json, r'seq_number')!,
        timestamp: mapDateTime(json, r'timestamp', r'')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
        code: mapValueOfType<String>(json, r'code'),
        error: mapValueOfType<String>(json, r'error')!,
        ingressStreamId: mapValueOfType<String>(json, r'ingress_stream_id')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
        clientIp: mapValueOfType<String>(json, r'client_ip'),
        clientName: mapValueOfType<String>(json, r'client_name'),
        publisherType: mapValueOfType<String>(json, r'publisher_type')!,
        version: mapValueOfType<String>(json, r'version'),
      );
    }
    return null;
  }

  static List<WSCallEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WSCallEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSCallEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WSCallEvent> mapFromJson(dynamic json) {
    final map = <String, WSCallEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSCallEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WSCallEvent-objects as value to a dart map
  static Map<String, List<WSCallEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<WSCallEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WSCallEvent.listFromJson(
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
    'error',
    'ingress_stream_id',
    'user_id',
    'publisher_type',
  };
}
