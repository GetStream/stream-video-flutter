//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class NotificationSettings {
  /// Returns a new [NotificationSettings] instance.
  NotificationSettings({
    required this.callLiveStarted,
    required this.callNotification,
    required this.callRing,
    required this.enabled,
    required this.sessionStarted,
  });

  EventNotificationSettings callLiveStarted;

  EventNotificationSettings callNotification;

  EventNotificationSettings callRing;

  bool enabled;

  EventNotificationSettings sessionStarted;

  @override
  bool operator ==(Object other) => identical(this, other) || other is NotificationSettings &&
     other.callLiveStarted == callLiveStarted &&
     other.callNotification == callNotification &&
     other.callRing == callRing &&
     other.enabled == enabled &&
     other.sessionStarted == sessionStarted;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callLiveStarted.hashCode) +
    (callNotification.hashCode) +
    (callRing.hashCode) +
    (enabled.hashCode) +
    (sessionStarted.hashCode);

  @override
  String toString() => 'NotificationSettings[callLiveStarted=$callLiveStarted, callNotification=$callNotification, callRing=$callRing, enabled=$enabled, sessionStarted=$sessionStarted]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_live_started'] = this.callLiveStarted;
      json[r'call_notification'] = this.callNotification;
      json[r'call_ring'] = this.callRing;
      json[r'enabled'] = this.enabled;
      json[r'session_started'] = this.sessionStarted;
    return json;
  }

  /// Returns a new [NotificationSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static NotificationSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "NotificationSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "NotificationSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return NotificationSettings(
        callLiveStarted: EventNotificationSettings.fromJson(json[r'call_live_started'])!,
        callNotification: EventNotificationSettings.fromJson(json[r'call_notification'])!,
        callRing: EventNotificationSettings.fromJson(json[r'call_ring'])!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        sessionStarted: EventNotificationSettings.fromJson(json[r'session_started'])!,
      );
    }
    return null;
  }

  static List<NotificationSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <NotificationSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = NotificationSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, NotificationSettings> mapFromJson(dynamic json) {
    final map = <String, NotificationSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = NotificationSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of NotificationSettings-objects as value to a dart map
  static Map<String, List<NotificationSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<NotificationSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = NotificationSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_live_started',
    'call_notification',
    'call_ring',
    'enabled',
    'session_started',
  };
}

