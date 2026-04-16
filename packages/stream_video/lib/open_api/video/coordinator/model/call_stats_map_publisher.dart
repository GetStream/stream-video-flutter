//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsMapPublisher {
  /// Returns a new [CallStatsMapPublisher] instance.
  CallStatsMapPublisher({
    required this.isLive,
    this.location,
    this.name,
    required this.publishedTracks,
    this.publisherType,
    required this.userId,
    required this.userSessionId,
  });

  bool isLive;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallStatsLocation? location;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  PublishedTrackFlags publishedTracks;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publisherType;

  String userId;

  String userSessionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsMapPublisher &&
          other.isLive == isLive &&
          other.location == location &&
          other.name == name &&
          other.publishedTracks == publishedTracks &&
          other.publisherType == publisherType &&
          other.userId == userId &&
          other.userSessionId == userSessionId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (isLive.hashCode) +
      (location == null ? 0 : location!.hashCode) +
      (name == null ? 0 : name!.hashCode) +
      (publishedTracks.hashCode) +
      (publisherType == null ? 0 : publisherType!.hashCode) +
      (userId.hashCode) +
      (userSessionId.hashCode);

  @override
  String toString() =>
      'CallStatsMapPublisher[isLive=$isLive, location=$location, name=$name, publishedTracks=$publishedTracks, publisherType=$publisherType, userId=$userId, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'is_live'] = this.isLive;
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    json[r'published_tracks'] = this.publishedTracks;
    if (this.publisherType != null) {
      json[r'publisher_type'] = this.publisherType;
    } else {
      json[r'publisher_type'] = null;
    }
    json[r'user_id'] = this.userId;
    json[r'user_session_id'] = this.userSessionId;
    return json;
  }

  /// Returns a new [CallStatsMapPublisher] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsMapPublisher? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'is_live'),
            'Required key "CallStatsMapPublisher[is_live]" is missing from JSON.');
        assert(json[r'is_live'] != null,
            'Required key "CallStatsMapPublisher[is_live]" has a null value in JSON.');
        assert(json.containsKey(r'published_tracks'),
            'Required key "CallStatsMapPublisher[published_tracks]" is missing from JSON.');
        assert(json[r'published_tracks'] != null,
            'Required key "CallStatsMapPublisher[published_tracks]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "CallStatsMapPublisher[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "CallStatsMapPublisher[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'user_session_id'),
            'Required key "CallStatsMapPublisher[user_session_id]" is missing from JSON.');
        assert(json[r'user_session_id'] != null,
            'Required key "CallStatsMapPublisher[user_session_id]" has a null value in JSON.');
        return true;
      }());

      return CallStatsMapPublisher(
        isLive: mapValueOfType<bool>(json, r'is_live')!,
        location: CallStatsLocation.fromJson(json[r'location']),
        name: mapValueOfType<String>(json, r'name'),
        publishedTracks:
            PublishedTrackFlags.fromJson(json[r'published_tracks'])!,
        publisherType: mapValueOfType<String>(json, r'publisher_type'),
        userId: mapValueOfType<String>(json, r'user_id')!,
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
      );
    }
    return null;
  }

  static List<CallStatsMapPublisher> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsMapPublisher>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsMapPublisher.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsMapPublisher> mapFromJson(dynamic json) {
    final map = <String, CallStatsMapPublisher>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsMapPublisher.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsMapPublisher-objects as value to a dart map
  static Map<String, List<CallStatsMapPublisher>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsMapPublisher>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsMapPublisher.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'is_live',
    'published_tracks',
    'user_id',
    'user_session_id',
  };
}
