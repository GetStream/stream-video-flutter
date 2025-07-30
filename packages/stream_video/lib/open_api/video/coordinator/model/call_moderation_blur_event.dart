//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallModerationBlurEvent {
  /// Returns a new [CallModerationBlurEvent] instance.
  CallModerationBlurEvent({
    required this.callCid,
    required this.createdAt,
    this.custom = const {},
    this.type = 'call.moderation_blur',
    required this.userId,
  });

  String callCid;

  DateTime createdAt;

  Map<String, Object> custom;

  String type;

  String userId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallModerationBlurEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.type == type &&
          other.userId == userId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (type.hashCode) +
      (userId.hashCode);

  @override
  String toString() =>
      'CallModerationBlurEvent[callCid=$callCid, createdAt=$createdAt, custom=$custom, type=$type, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    json[r'type'] = this.type;
    json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [CallModerationBlurEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallModerationBlurEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CallModerationBlurEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CallModerationBlurEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallModerationBlurEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        type: mapValueOfType<String>(json, r'type')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<CallModerationBlurEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallModerationBlurEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallModerationBlurEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallModerationBlurEvent> mapFromJson(dynamic json) {
    final map = <String, CallModerationBlurEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallModerationBlurEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallModerationBlurEvent-objects as value to a dart map
  static Map<String, List<CallModerationBlurEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallModerationBlurEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallModerationBlurEvent.listFromJson(
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
    'type',
    'user_id',
  };
}
