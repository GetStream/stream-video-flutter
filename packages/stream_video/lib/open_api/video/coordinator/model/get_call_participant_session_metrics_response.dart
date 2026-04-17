//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetCallParticipantSessionMetricsResponse {
  /// Returns a new [GetCallParticipantSessionMetricsResponse] instance.
  GetCallParticipantSessionMetricsResponse({
    this.client,
    required this.duration,
    this.isPublisher,
    this.isSubscriber,
    this.joinedAt,
    this.publishedTracks = const [],
    this.publisherType,
    this.userId,
    this.userSessionId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  SessionClient? client;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isPublisher;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isSubscriber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? joinedAt;

  List<PublishedTrackMetrics> publishedTracks;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? publisherType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? userSessionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetCallParticipantSessionMetricsResponse &&
          other.client == client &&
          other.duration == duration &&
          other.isPublisher == isPublisher &&
          other.isSubscriber == isSubscriber &&
          other.joinedAt == joinedAt &&
          _deepEquality.equals(other.publishedTracks, publishedTracks) &&
          other.publisherType == publisherType &&
          other.userId == userId &&
          other.userSessionId == userSessionId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (client == null ? 0 : client!.hashCode) +
      (duration.hashCode) +
      (isPublisher == null ? 0 : isPublisher!.hashCode) +
      (isSubscriber == null ? 0 : isSubscriber!.hashCode) +
      (joinedAt == null ? 0 : joinedAt!.hashCode) +
      (publishedTracks.hashCode) +
      (publisherType == null ? 0 : publisherType!.hashCode) +
      (userId == null ? 0 : userId!.hashCode) +
      (userSessionId == null ? 0 : userSessionId!.hashCode);

  @override
  String toString() =>
      'GetCallParticipantSessionMetricsResponse[client=$client, duration=$duration, isPublisher=$isPublisher, isSubscriber=$isSubscriber, joinedAt=$joinedAt, publishedTracks=$publishedTracks, publisherType=$publisherType, userId=$userId, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.client != null) {
      json[r'client'] = this.client;
    } else {
      json[r'client'] = null;
    }
    json[r'duration'] = this.duration;
    if (this.isPublisher != null) {
      json[r'is_publisher'] = this.isPublisher;
    } else {
      json[r'is_publisher'] = null;
    }
    if (this.isSubscriber != null) {
      json[r'is_subscriber'] = this.isSubscriber;
    } else {
      json[r'is_subscriber'] = null;
    }
    if (this.joinedAt != null) {
      json[r'joined_at'] = this.joinedAt!.toUtc().toIso8601String();
    } else {
      json[r'joined_at'] = null;
    }
    json[r'published_tracks'] = this.publishedTracks;
    if (this.publisherType != null) {
      json[r'publisher_type'] = this.publisherType;
    } else {
      json[r'publisher_type'] = null;
    }
    if (this.userId != null) {
      json[r'user_id'] = this.userId;
    } else {
      json[r'user_id'] = null;
    }
    if (this.userSessionId != null) {
      json[r'user_session_id'] = this.userSessionId;
    } else {
      json[r'user_session_id'] = null;
    }
    return json;
  }

  /// Returns a new [GetCallParticipantSessionMetricsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCallParticipantSessionMetricsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'duration'),
            'Required key "GetCallParticipantSessionMetricsResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "GetCallParticipantSessionMetricsResponse[duration]" has a null value in JSON.');
        return true;
      }());

      return GetCallParticipantSessionMetricsResponse(
        client: SessionClient.fromJson(json[r'client']),
        duration: mapValueOfType<String>(json, r'duration')!,
        isPublisher: mapValueOfType<bool>(json, r'is_publisher'),
        isSubscriber: mapValueOfType<bool>(json, r'is_subscriber'),
        joinedAt: mapDateTime(json, r'joined_at', r''),
        publishedTracks:
            PublishedTrackMetrics.listFromJson(json[r'published_tracks']),
        publisherType: mapValueOfType<String>(json, r'publisher_type'),
        userId: mapValueOfType<String>(json, r'user_id'),
        userSessionId: mapValueOfType<String>(json, r'user_session_id'),
      );
    }
    return null;
  }

  static List<GetCallParticipantSessionMetricsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GetCallParticipantSessionMetricsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetCallParticipantSessionMetricsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCallParticipantSessionMetricsResponse> mapFromJson(
      dynamic json) {
    final map = <String, GetCallParticipantSessionMetricsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            GetCallParticipantSessionMetricsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCallParticipantSessionMetricsResponse-objects as value to a dart map
  static Map<String, List<GetCallParticipantSessionMetricsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GetCallParticipantSessionMetricsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GetCallParticipantSessionMetricsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
  };
}
