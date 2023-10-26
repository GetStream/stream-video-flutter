//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallUpdatedEvent {
  /// Returns a new [CallUpdatedEvent] instance.
  CallUpdatedEvent({
    required this.call,
    required this.callCid,
    this.capabilitiesByRole = const {},
    required this.createdAt,
    this.type = 'call.updated',
  });

  CallResponse call;

  String callCid;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  DateTime createdAt;

  /// The type of event: \"call.ended\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallUpdatedEvent &&
     other.call == call &&
     other.callCid == callCid &&
     other.capabilitiesByRole == capabilitiesByRole &&
     other.createdAt == createdAt &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (call.hashCode) +
    (callCid.hashCode) +
    (capabilitiesByRole.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallUpdatedEvent[call=$call, callCid=$callCid, capabilitiesByRole=$capabilitiesByRole, createdAt=$createdAt, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call'] = this.call;
      json[r'call_cid'] = this.callCid;
      json[r'capabilities_by_role'] = this.capabilitiesByRole;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallUpdatedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallUpdatedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallUpdatedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallUpdatedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallUpdatedEvent(
        call: CallResponse.fromJson(json[r'call'])!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        capabilitiesByRole: json[r'capabilities_by_role'] == null
            ? const {}
            : capabilitiesFromJson(json['capabilities_by_role']) ??
                const {},
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static Map<String, List<String>> capabilitiesFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<String>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = entry.value.cast<String>();
      }
    }
    return growable ? map : Map.unmodifiable(map);
  }

  static List<CallUpdatedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallUpdatedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallUpdatedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallUpdatedEvent> mapFromJson(dynamic json) {
    final map = <String, CallUpdatedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallUpdatedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallUpdatedEvent-objects as value to a dart map
  static Map<String, List<CallUpdatedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallUpdatedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallUpdatedEvent.listFromJson(
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
    'capabilities_by_role',
    'created_at',
    'type',
  };
}
