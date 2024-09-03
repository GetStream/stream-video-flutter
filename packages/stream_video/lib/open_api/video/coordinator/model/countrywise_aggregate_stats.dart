//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CountrywiseAggregateStats {
  /// Returns a new [CountrywiseAggregateStats] instance.
  CountrywiseAggregateStats({
    this.participantCount,
    this.publisherJitter,
    this.publisherLatency,
    this.subscriberJitter,
    this.subscriberLatency,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Count? participantCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? publisherJitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? publisherLatency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? subscriberJitter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TimeStats? subscriberLatency;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CountrywiseAggregateStats &&
    other.participantCount == participantCount &&
    other.publisherJitter == publisherJitter &&
    other.publisherLatency == publisherLatency &&
    other.subscriberJitter == subscriberJitter &&
    other.subscriberLatency == subscriberLatency;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (participantCount == null ? 0 : participantCount!.hashCode) +
    (publisherJitter == null ? 0 : publisherJitter!.hashCode) +
    (publisherLatency == null ? 0 : publisherLatency!.hashCode) +
    (subscriberJitter == null ? 0 : subscriberJitter!.hashCode) +
    (subscriberLatency == null ? 0 : subscriberLatency!.hashCode);

  @override
  String toString() => 'CountrywiseAggregateStats[participantCount=$participantCount, publisherJitter=$publisherJitter, publisherLatency=$publisherLatency, subscriberJitter=$subscriberJitter, subscriberLatency=$subscriberLatency]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.participantCount != null) {
      json[r'participant_count'] = this.participantCount;
    } else {
      json[r'participant_count'] = null;
    }
    if (this.publisherJitter != null) {
      json[r'publisher_jitter'] = this.publisherJitter;
    } else {
      json[r'publisher_jitter'] = null;
    }
    if (this.publisherLatency != null) {
      json[r'publisher_latency'] = this.publisherLatency;
    } else {
      json[r'publisher_latency'] = null;
    }
    if (this.subscriberJitter != null) {
      json[r'subscriber_jitter'] = this.subscriberJitter;
    } else {
      json[r'subscriber_jitter'] = null;
    }
    if (this.subscriberLatency != null) {
      json[r'subscriber_latency'] = this.subscriberLatency;
    } else {
      json[r'subscriber_latency'] = null;
    }
    return json;
  }

  /// Returns a new [CountrywiseAggregateStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CountrywiseAggregateStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CountrywiseAggregateStats[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CountrywiseAggregateStats[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CountrywiseAggregateStats(
        participantCount: Count.fromJson(json[r'participant_count']),
        publisherJitter: TimeStats.fromJson(json[r'publisher_jitter']),
        publisherLatency: TimeStats.fromJson(json[r'publisher_latency']),
        subscriberJitter: TimeStats.fromJson(json[r'subscriber_jitter']),
        subscriberLatency: TimeStats.fromJson(json[r'subscriber_latency']),
      );
    }
    return null;
  }

  static List<CountrywiseAggregateStats> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CountrywiseAggregateStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CountrywiseAggregateStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CountrywiseAggregateStats> mapFromJson(dynamic json) {
    final map = <String, CountrywiseAggregateStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CountrywiseAggregateStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CountrywiseAggregateStats-objects as value to a dart map
  static Map<String, List<CountrywiseAggregateStats>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CountrywiseAggregateStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CountrywiseAggregateStats.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

