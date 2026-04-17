//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressStartedEvent {
  /// Returns a new [IngressStartedEvent] instance.
  IngressStartedEvent({
    required this.callCid,
    this.clientIp,
    this.clientName,
    required this.createdAt,
    required this.ingressStreamId,
    required this.publisherType,
    this.type = 'ingress.started',
    required this.userId,
    this.version,
  });

  String callCid;

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

  DateTime createdAt;

  /// Unique identifier for this stream
  String ingressStreamId;

  /// Streaming protocol (e.g., 'rtmps', 'srt', 'rtmp', 'rtsp')
  String publisherType;

  /// The type of event: \"ingress.started\" in this case
  String type;

  /// User who started the stream
  String userId;

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
      other is IngressStartedEvent &&
          other.callCid == callCid &&
          other.clientIp == clientIp &&
          other.clientName == clientName &&
          other.createdAt == createdAt &&
          other.ingressStreamId == ingressStreamId &&
          other.publisherType == publisherType &&
          other.type == type &&
          other.userId == userId &&
          other.version == version;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (clientIp == null ? 0 : clientIp!.hashCode) +
      (clientName == null ? 0 : clientName!.hashCode) +
      (createdAt.hashCode) +
      (ingressStreamId.hashCode) +
      (publisherType.hashCode) +
      (type.hashCode) +
      (userId.hashCode) +
      (version == null ? 0 : version!.hashCode);

  @override
  String toString() =>
      'IngressStartedEvent[callCid=$callCid, clientIp=$clientIp, clientName=$clientName, createdAt=$createdAt, ingressStreamId=$ingressStreamId, publisherType=$publisherType, type=$type, userId=$userId, version=$version]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
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
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'ingress_stream_id'] = this.ingressStreamId;
    json[r'publisher_type'] = this.publisherType;
    json[r'type'] = this.type;
    json[r'user_id'] = this.userId;
    if (this.version != null) {
      json[r'version'] = this.version;
    } else {
      json[r'version'] = null;
    }
    return json;
  }

  /// Returns a new [IngressStartedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressStartedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "IngressStartedEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "IngressStartedEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "IngressStartedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "IngressStartedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'ingress_stream_id'),
            'Required key "IngressStartedEvent[ingress_stream_id]" is missing from JSON.');
        assert(json[r'ingress_stream_id'] != null,
            'Required key "IngressStartedEvent[ingress_stream_id]" has a null value in JSON.');
        assert(json.containsKey(r'publisher_type'),
            'Required key "IngressStartedEvent[publisher_type]" is missing from JSON.');
        assert(json[r'publisher_type'] != null,
            'Required key "IngressStartedEvent[publisher_type]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "IngressStartedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "IngressStartedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "IngressStartedEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "IngressStartedEvent[user_id]" has a null value in JSON.');
        return true;
      }());

      return IngressStartedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        clientIp: mapValueOfType<String>(json, r'client_ip'),
        clientName: mapValueOfType<String>(json, r'client_name'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        ingressStreamId: mapValueOfType<String>(json, r'ingress_stream_id')!,
        publisherType: mapValueOfType<String>(json, r'publisher_type')!,
        type: mapValueOfType<String>(json, r'type')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
        version: mapValueOfType<String>(json, r'version'),
      );
    }
    return null;
  }

  static List<IngressStartedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressStartedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressStartedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressStartedEvent> mapFromJson(dynamic json) {
    final map = <String, IngressStartedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressStartedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressStartedEvent-objects as value to a dart map
  static Map<String, List<IngressStartedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressStartedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressStartedEvent.listFromJson(
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
    'ingress_stream_id',
    'publisher_type',
    'type',
    'user_id',
  };
}
