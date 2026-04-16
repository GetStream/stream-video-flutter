//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressStoppedEvent {
  /// Returns a new [IngressStoppedEvent] instance.
  IngressStoppedEvent({
    required this.callCid,
    required this.createdAt,
    required this.ingressStreamId,
    this.type = 'ingress.stopped',
    required this.userId,
  });

  String callCid;

  DateTime createdAt;

  /// Unique identifier for the stream
  String ingressStreamId;

  /// The type of event: \"ingress.stopped\" in this case
  String type;

  /// User who was streaming
  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressStoppedEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.ingressStreamId == ingressStreamId &&
          other.type == type &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (ingressStreamId.hashCode) +
      (type.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'IngressStoppedEvent[callCid=$callCid, createdAt=$createdAt, ingressStreamId=$ingressStreamId, type=$type, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'ingress_stream_id'] = this.ingressStreamId;
    json[r'type'] = this.type;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [IngressStoppedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressStoppedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "IngressStoppedEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "IngressStoppedEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "IngressStoppedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "IngressStoppedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'ingress_stream_id'),
            'Required key "IngressStoppedEvent[ingress_stream_id]" is missing from JSON.');
        assert(json[r'ingress_stream_id'] != null,
            'Required key "IngressStoppedEvent[ingress_stream_id]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "IngressStoppedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "IngressStoppedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "IngressStoppedEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "IngressStoppedEvent[user_id]" has a null value in JSON.');
        return true;
      }());

      return IngressStoppedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        ingressStreamId: mapValueOfType<String>(json, r'ingress_stream_id')!,
        type: mapValueOfType<String>(json, r'type')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<IngressStoppedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressStoppedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressStoppedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressStoppedEvent> mapFromJson(dynamic json) {
    final map = <String, IngressStoppedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressStoppedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressStoppedEvent-objects as value to a dart map
  static Map<String, List<IngressStoppedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressStoppedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressStoppedEvent.listFromJson(
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
    'type',
    'user_id',
  };
}
