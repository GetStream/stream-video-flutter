//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RingSettings {
  /// Returns a new [RingSettings] instance.
  RingSettings({
    required this.autoCancelTimeoutMs,
    required this.incomingCallTimeoutMs,
  });

  int autoCancelTimeoutMs;

  int incomingCallTimeoutMs;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RingSettings &&
     other.autoCancelTimeoutMs == autoCancelTimeoutMs &&
     other.incomingCallTimeoutMs == incomingCallTimeoutMs;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoCancelTimeoutMs.hashCode) +
    (incomingCallTimeoutMs.hashCode);

  @override
  String toString() => 'RingSettings[autoCancelTimeoutMs=$autoCancelTimeoutMs, incomingCallTimeoutMs=$incomingCallTimeoutMs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'auto_cancel_timeout_ms'] = this.autoCancelTimeoutMs;
      json[r'incoming_call_timeout_ms'] = this.incomingCallTimeoutMs;
    return json;
  }

  /// Returns a new [RingSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RingSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RingSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RingSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RingSettings(
        autoCancelTimeoutMs: mapValueOfType<int>(json, r'auto_cancel_timeout_ms')!,
        incomingCallTimeoutMs: mapValueOfType<int>(json, r'incoming_call_timeout_ms')!,
      );
    }
    return null;
  }

  static List<RingSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RingSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RingSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RingSettings> mapFromJson(dynamic json) {
    final map = <String, RingSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RingSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RingSettings-objects as value to a dart map
  static Map<String, List<RingSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RingSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RingSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'auto_cancel_timeout_ms',
    'incoming_call_timeout_ms',
  };
}

