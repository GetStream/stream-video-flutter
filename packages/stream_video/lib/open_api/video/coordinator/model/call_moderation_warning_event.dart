//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallModerationWarningEvent {
  /// Returns a new [CallModerationWarningEvent] instance.
  CallModerationWarningEvent({
    required this.callCid,
    required this.createdAt,
    this.custom = const {},
    required this.message,
    this.type = 'call.moderation_warning',
    required this.userId,
  });

  String callCid;

  DateTime createdAt;

  /// Custom data associated with the moderation action
  Map<String, Object> custom;

  /// The warning message
  String message;

  /// The type of event: \"call.moderation_warning\" in this case
  String type;

  /// The user ID who is receiving the warning
  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallModerationWarningEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.message == message &&
          other.type == type &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (message.hashCode) +
      (type.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'CallModerationWarningEvent[callCid=$callCid, createdAt=$createdAt, custom=$custom, message=$message, type=$type, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    json[r'message'] = this.message;
    json[r'type'] = this.type;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [CallModerationWarningEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallModerationWarningEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "CallModerationWarningEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "CallModerationWarningEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "CallModerationWarningEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "CallModerationWarningEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'custom'),
            'Required key "CallModerationWarningEvent[custom]" is missing from JSON.');
        assert(json[r'custom'] != null,
            'Required key "CallModerationWarningEvent[custom]" has a null value in JSON.');
        assert(json.containsKey(r'message'),
            'Required key "CallModerationWarningEvent[message]" is missing from JSON.');
        assert(json[r'message'] != null,
            'Required key "CallModerationWarningEvent[message]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "CallModerationWarningEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "CallModerationWarningEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "CallModerationWarningEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "CallModerationWarningEvent[user_id]" has a null value in JSON.');
        return true;
      }());

      return CallModerationWarningEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        message: mapValueOfType<String>(json, r'message')!,
        type: mapValueOfType<String>(json, r'type')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<CallModerationWarningEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallModerationWarningEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallModerationWarningEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallModerationWarningEvent> mapFromJson(dynamic json) {
    final map = <String, CallModerationWarningEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallModerationWarningEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallModerationWarningEvent-objects as value to a dart map
  static Map<String, List<CallModerationWarningEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallModerationWarningEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallModerationWarningEvent.listFromJson(
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
    'custom',
    'message',
    'type',
    'user_id',
  };
}
