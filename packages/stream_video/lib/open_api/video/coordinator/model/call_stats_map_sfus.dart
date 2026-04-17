//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsMapSFUs {
  /// Returns a new [CallStatsMapSFUs] instance.
  CallStatsMapSFUs({
    this.locations = const [],
  });

  List<SFULocationResponse> locations;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsMapSFUs &&
          _deepEquality.equals(other.locations, locations);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (locations.hashCode);

  @override
  String toString() => 'CallStatsMapSFUs[locations=$locations]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'locations'] = this.locations;
    return json;
  }

  /// Returns a new [CallStatsMapSFUs] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsMapSFUs? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'locations'),
            'Required key "CallStatsMapSFUs[locations]" is missing from JSON.');
        assert(json[r'locations'] != null,
            'Required key "CallStatsMapSFUs[locations]" has a null value in JSON.');
        return true;
      }());

      return CallStatsMapSFUs(
        locations: SFULocationResponse.listFromJson(json[r'locations']),
      );
    }
    return null;
  }

  static List<CallStatsMapSFUs> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsMapSFUs>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsMapSFUs.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsMapSFUs> mapFromJson(dynamic json) {
    final map = <String, CallStatsMapSFUs>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsMapSFUs.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsMapSFUs-objects as value to a dart map
  static Map<String, List<CallStatsMapSFUs>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsMapSFUs>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsMapSFUs.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'locations',
  };
}
