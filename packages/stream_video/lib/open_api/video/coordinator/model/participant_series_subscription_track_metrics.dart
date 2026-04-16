//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantSeriesSubscriptionTrackMetrics {
  /// Returns a new [ParticipantSeriesSubscriptionTrackMetrics] instance.
  ParticipantSeriesSubscriptionTrackMetrics({
    this.publisherName,
    required this.publisherUserId,
    this.publisherUserSessionId,
    this.tracks = const {},
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publisherName;

  String publisherUserId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publisherUserSessionId;

  Map<String, List<ParticipantSeriesTrackMetrics>> tracks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSeriesSubscriptionTrackMetrics &&
          other.publisherName == publisherName &&
          other.publisherUserId == publisherUserId &&
          other.publisherUserSessionId == publisherUserSessionId &&
          _deepEquality.equals(other.tracks, tracks);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (publisherName == null ? 0 : publisherName!.hashCode) +
      (publisherUserId.hashCode) +
      (publisherUserSessionId == null ? 0 : publisherUserSessionId!.hashCode) +
      (tracks.hashCode);

  @override
  String toString() =>
      'ParticipantSeriesSubscriptionTrackMetrics[publisherName=$publisherName, publisherUserId=$publisherUserId, publisherUserSessionId=$publisherUserSessionId, tracks=$tracks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.publisherName != null) {
      json[r'publisher_name'] = this.publisherName;
    } else {
      json[r'publisher_name'] = null;
    }
    json[r'publisher_user_id'] = this.publisherUserId;
    if (this.publisherUserSessionId != null) {
      json[r'publisher_user_session_id'] = this.publisherUserSessionId;
    } else {
      json[r'publisher_user_session_id'] = null;
    }
    json[r'tracks'] = this.tracks;
    return json;
  }

  /// Returns a new [ParticipantSeriesSubscriptionTrackMetrics] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantSeriesSubscriptionTrackMetrics? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'publisher_user_id'),
            'Required key "ParticipantSeriesSubscriptionTrackMetrics[publisher_user_id]" is missing from JSON.');
        assert(json[r'publisher_user_id'] != null,
            'Required key "ParticipantSeriesSubscriptionTrackMetrics[publisher_user_id]" has a null value in JSON.');
        return true;
      }());

      return ParticipantSeriesSubscriptionTrackMetrics(
        publisherName: mapValueOfType<String>(json, r'publisher_name'),
        publisherUserId: mapValueOfType<String>(json, r'publisher_user_id')!,
        publisherUserSessionId:
            mapValueOfType<String>(json, r'publisher_user_session_id'),
        tracks: json[r'tracks'] == null
            ? const {}
            : ParticipantSeriesTrackMetrics.mapListFromJson(json[r'tracks']),
      );
    }
    return null;
  }

  static List<ParticipantSeriesSubscriptionTrackMetrics> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantSeriesSubscriptionTrackMetrics>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantSeriesSubscriptionTrackMetrics.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantSeriesSubscriptionTrackMetrics> mapFromJson(
      dynamic json) {
    final map = <String, ParticipantSeriesSubscriptionTrackMetrics>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            ParticipantSeriesSubscriptionTrackMetrics.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantSeriesSubscriptionTrackMetrics-objects as value to a dart map
  static Map<String, List<ParticipantSeriesSubscriptionTrackMetrics>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantSeriesSubscriptionTrackMetrics>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantSeriesSubscriptionTrackMetrics.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'publisher_user_id',
  };
}
