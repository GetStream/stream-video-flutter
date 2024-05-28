//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallTimeline {
  /// Returns a new [CallTimeline] instance.
  CallTimeline({
    this.events = const [],
  });

  List<CallEvent> events;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallTimeline &&
    _deepEquality.equals(other.events, events);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (events.hashCode);

  @override
  String toString() => 'CallTimeline[events=$events]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'events'] = this.events;
    return json;
  }

  /// Returns a new [CallTimeline] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallTimeline? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallTimeline[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallTimeline[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallTimeline(
        events: CallEvent.listFromJson(json[r'events']),
      );
    }
    return null;
  }

  static List<CallTimeline> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallTimeline>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallTimeline.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallTimeline> mapFromJson(dynamic json) {
    final map = <String, CallTimeline>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallTimeline.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallTimeline-objects as value to a dart map
  static Map<String, List<CallTimeline>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallTimeline>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallTimeline.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'events',
  };
}

