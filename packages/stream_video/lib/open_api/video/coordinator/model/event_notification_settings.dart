//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EventNotificationSettings {
  /// Returns a new [EventNotificationSettings] instance.
  EventNotificationSettings({
    required this.apns,
    required this.enabled,
  });

  APNS apns;

  bool enabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EventNotificationSettings &&
     other.apns == apns &&
     other.enabled == enabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (apns.hashCode) +
    (enabled.hashCode);

  @override
  String toString() => 'EventNotificationSettings[apns=$apns, enabled=$enabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'apns'] = this.apns;
      json[r'enabled'] = this.enabled;
    return json;
  }

  /// Returns a new [EventNotificationSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EventNotificationSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EventNotificationSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EventNotificationSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EventNotificationSettings(
        apns: APNS.fromJson(json[r'apns'])!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
      );
    }
    return null;
  }

  static List<EventNotificationSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EventNotificationSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EventNotificationSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EventNotificationSettings> mapFromJson(dynamic json) {
    final map = <String, EventNotificationSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EventNotificationSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EventNotificationSettings-objects as value to a dart map
  static Map<String, List<EventNotificationSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EventNotificationSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EventNotificationSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'apns',
    'enabled',
  };
}

