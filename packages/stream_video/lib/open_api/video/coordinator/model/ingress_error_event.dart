//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressErrorEvent {
  /// Returns a new [IngressErrorEvent] instance.
  IngressErrorEvent({
    required this.callCid,
    this.code,
    required this.createdAt,
    required this.error,
    required this.ingressStreamId,
    this.type = 'ingress.error',
    required this.userId,
  });

  String callCid;

  /// Error code
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? code;

  DateTime createdAt;

  /// Human-readable error message
  String error;

  /// Unique identifier for the stream
  String ingressStreamId;

  /// The type of event: \"ingress.error\" in this case
  String type;

  /// User who was streaming
  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressErrorEvent &&
          other.callCid == callCid &&
          other.code == code &&
          other.createdAt == createdAt &&
          other.error == error &&
          other.ingressStreamId == ingressStreamId &&
          other.type == type &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (code == null ? 0 : code!.hashCode) +
      (createdAt.hashCode) +
      (error.hashCode) +
      (ingressStreamId.hashCode) +
      (type.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'IngressErrorEvent[callCid=$callCid, code=$code, createdAt=$createdAt, error=$error, ingressStreamId=$ingressStreamId, type=$type, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    if (this.code != null) {
      json[r'code'] = this.code;
    } else {
      json[r'code'] = null;
    }
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'error'] = this.error;
    json[r'ingress_stream_id'] = this.ingressStreamId;
    json[r'type'] = this.type;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [IngressErrorEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressErrorEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "IngressErrorEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "IngressErrorEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "IngressErrorEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "IngressErrorEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'error'),
            'Required key "IngressErrorEvent[error]" is missing from JSON.');
        assert(json[r'error'] != null,
            'Required key "IngressErrorEvent[error]" has a null value in JSON.');
        assert(json.containsKey(r'ingress_stream_id'),
            'Required key "IngressErrorEvent[ingress_stream_id]" is missing from JSON.');
        assert(json[r'ingress_stream_id'] != null,
            'Required key "IngressErrorEvent[ingress_stream_id]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "IngressErrorEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "IngressErrorEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "IngressErrorEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "IngressErrorEvent[user_id]" has a null value in JSON.');
        return true;
      }());

      return IngressErrorEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        code: mapValueOfType<String>(json, r'code'),
        createdAt: mapDateTime(json, r'created_at', r'')!,
        error: mapValueOfType<String>(json, r'error')!,
        ingressStreamId: mapValueOfType<String>(json, r'ingress_stream_id')!,
        type: mapValueOfType<String>(json, r'type')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<IngressErrorEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressErrorEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressErrorEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressErrorEvent> mapFromJson(dynamic json) {
    final map = <String, IngressErrorEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressErrorEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressErrorEvent-objects as value to a dart map
  static Map<String, List<IngressErrorEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressErrorEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressErrorEvent.listFromJson(
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
    'error',
    'ingress_stream_id',
    'type',
    'user_id',
  };
}
