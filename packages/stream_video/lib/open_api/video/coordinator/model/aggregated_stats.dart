//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AggregatedStats {
  /// Returns a new [AggregatedStats] instance.
  AggregatedStats({
    this.countrywiseAggregateStats = const {},
    this.publisherAggregateStats,
    this.turn,
  });

  Map<String, CountrywiseAggregateStats> countrywiseAggregateStats;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PublisherAggregateStats? publisherAggregateStats;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TURNAggregatedStats? turn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AggregatedStats &&
    _deepEquality.equals(other.countrywiseAggregateStats, countrywiseAggregateStats) &&
    other.publisherAggregateStats == publisherAggregateStats &&
    other.turn == turn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (countrywiseAggregateStats.hashCode) +
    (publisherAggregateStats == null ? 0 : publisherAggregateStats!.hashCode) +
    (turn == null ? 0 : turn!.hashCode);

  @override
  String toString() => 'AggregatedStats[countrywiseAggregateStats=$countrywiseAggregateStats, publisherAggregateStats=$publisherAggregateStats, turn=$turn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'countrywise_aggregate_stats'] = this.countrywiseAggregateStats;
    if (this.publisherAggregateStats != null) {
      json[r'publisher_aggregate_stats'] = this.publisherAggregateStats;
    } else {
      json[r'publisher_aggregate_stats'] = null;
    }
    if (this.turn != null) {
      json[r'turn'] = this.turn;
    } else {
      json[r'turn'] = null;
    }
    return json;
  }

  /// Returns a new [AggregatedStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AggregatedStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AggregatedStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AggregatedStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AggregatedStats(
        countrywiseAggregateStats: CountrywiseAggregateStats.mapFromJson(json[r'countrywise_aggregate_stats']),
        publisherAggregateStats: PublisherAggregateStats.fromJson(json[r'publisher_aggregate_stats']),
        turn: TURNAggregatedStats.fromJson(json[r'turn']),
      );
    }
    return null;
  }

  static List<AggregatedStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AggregatedStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AggregatedStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AggregatedStats> mapFromJson(dynamic json) {
    final map = <String, AggregatedStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AggregatedStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AggregatedStats-objects as value to a dart map
  static Map<String, List<AggregatedStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AggregatedStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AggregatedStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

