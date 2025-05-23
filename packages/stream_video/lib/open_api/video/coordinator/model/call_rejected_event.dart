//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallRejectedEvent {
  /// Returns a new [CallRejectedEvent] instance.
  CallRejectedEvent({
    required this.call,
    required this.callCid,
    required this.createdAt,
    this.reason,
    this.type = 'call.rejected',
    required this.user,
  });

  CallResponse call;

  String callCid;

  DateTime createdAt;

  /// Provides information about why the call was rejected. You can provide any value, but the Stream API and SDKs use these default values: rejected, cancel, timeout and busy
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  /// The type of event: \"call.rejected\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRejectedEvent &&
          other.call == call &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.reason == reason &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (call.hashCode) +
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (reason == null ? 0 : reason!.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'CallRejectedEvent[call=$call, callCid=$callCid, createdAt=$createdAt, reason=$reason, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call'] = this.call;
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallRejectedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallRejectedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallRejectedEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallRejectedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallRejectedEvent(
        call: CallResponse.fromJson(json[r'call'])!,
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        reason: mapValueOfType<String>(json, r'reason'),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallRejectedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallRejectedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRejectedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallRejectedEvent> mapFromJson(dynamic json) {
    final map = <String, CallRejectedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallRejectedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallRejectedEvent-objects as value to a dart map
  static Map<String, List<CallRejectedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallRejectedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallRejectedEvent.listFromJson(
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
    'type',
    'user',
  };
}
