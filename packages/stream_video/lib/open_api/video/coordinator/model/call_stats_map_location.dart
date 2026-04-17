//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsMapLocation {
  /// Returns a new [CallStatsMapLocation] instance.
  CallStatsMapLocation({
    required this.count,
    required this.liveCount,
    this.location,
  });

  int count;

  int liveCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallStatsLocation? location;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsMapLocation &&
          other.count == count &&
          other.liveCount == liveCount &&
          other.location == location;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (count.hashCode) +
      (liveCount.hashCode) +
      (location == null ? 0 : location!.hashCode);

  @override
  String toString() =>
      'CallStatsMapLocation[count=$count, liveCount=$liveCount, location=$location]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'count'] = this.count;
    json[r'live_count'] = this.liveCount;
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    return json;
  }

  /// Returns a new [CallStatsMapLocation] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsMapLocation? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'count'),
            'Required key "CallStatsMapLocation[count]" is missing from JSON.');
        assert(json[r'count'] != null,
            'Required key "CallStatsMapLocation[count]" has a null value in JSON.');
        assert(json.containsKey(r'live_count'),
            'Required key "CallStatsMapLocation[live_count]" is missing from JSON.');
        assert(json[r'live_count'] != null,
            'Required key "CallStatsMapLocation[live_count]" has a null value in JSON.');
        return true;
      }());

      return CallStatsMapLocation(
        count: mapValueOfType<int>(json, r'count')!,
        liveCount: mapValueOfType<int>(json, r'live_count')!,
        location: CallStatsLocation.fromJson(json[r'location']),
      );
    }
    return null;
  }

  static List<CallStatsMapLocation> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsMapLocation>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsMapLocation.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsMapLocation> mapFromJson(dynamic json) {
    final map = <String, CallStatsMapLocation>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsMapLocation.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsMapLocation-objects as value to a dart map
  static Map<String, List<CallStatsMapLocation>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsMapLocation>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsMapLocation.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'live_count',
  };
}
