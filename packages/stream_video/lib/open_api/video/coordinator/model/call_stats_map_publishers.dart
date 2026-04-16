//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsMapPublishers {
  /// Returns a new [CallStatsMapPublishers] instance.
  CallStatsMapPublishers({
    this.publishers = const [],
  });

  List<CallStatsMapPublisher> publishers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsMapPublishers &&
          _deepEquality.equals(other.publishers, publishers);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (publishers.hashCode);

  @override
  String toString() => 'CallStatsMapPublishers[publishers=$publishers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'publishers'] = this.publishers;
    return json;
  }

  /// Returns a new [CallStatsMapPublishers] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsMapPublishers? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'publishers'),
            'Required key "CallStatsMapPublishers[publishers]" is missing from JSON.');
        assert(json[r'publishers'] != null,
            'Required key "CallStatsMapPublishers[publishers]" has a null value in JSON.');
        return true;
      }());

      return CallStatsMapPublishers(
        publishers: CallStatsMapPublisher.listFromJson(json[r'publishers']),
      );
    }
    return null;
  }

  static List<CallStatsMapPublishers> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsMapPublishers>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsMapPublishers.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsMapPublishers> mapFromJson(dynamic json) {
    final map = <String, CallStatsMapPublishers>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsMapPublishers.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsMapPublishers-objects as value to a dart map
  static Map<String, List<CallStatsMapPublishers>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsMapPublishers>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsMapPublishers.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'publishers',
  };
}
