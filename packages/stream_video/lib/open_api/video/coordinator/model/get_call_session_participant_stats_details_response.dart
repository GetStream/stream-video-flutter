//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetCallSessionParticipantStatsDetailsResponse {
  /// Returns a new [GetCallSessionParticipantStatsDetailsResponse] instance.
  GetCallSessionParticipantStatsDetailsResponse({
    required this.callId,
    required this.callSessionId,
    required this.callType,
    required this.duration,
    this.publisher,
    this.subscriber,
    this.timeframe,
    this.user,
    required this.userId,
    required this.userSessionId,
  });

  String callId;

  String callSessionId;

  String callType;

  /// Duration of the request in milliseconds
  String duration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ParticipantSeriesPublisherStats? publisher;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ParticipantSeriesSubscriberStats? subscriber;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ParticipantSeriesTimeframe? timeframe;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ParticipantSeriesUserStats? user;

  String userId;

  String userSessionId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetCallSessionParticipantStatsDetailsResponse &&
          other.callId == callId &&
          other.callSessionId == callSessionId &&
          other.callType == callType &&
          other.duration == duration &&
          other.publisher == publisher &&
          other.subscriber == subscriber &&
          other.timeframe == timeframe &&
          other.user == user &&
          other.userId == userId &&
          other.userSessionId == userSessionId;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callId.hashCode) +
      (callSessionId.hashCode) +
      (callType.hashCode) +
      (duration.hashCode) +
      (publisher == null ? 0 : publisher!.hashCode) +
      (subscriber == null ? 0 : subscriber!.hashCode) +
      (timeframe == null ? 0 : timeframe!.hashCode) +
      (user == null ? 0 : user!.hashCode) +
      (userId.hashCode) +
      (userSessionId.hashCode);

  @override
  String toString() =>
      'GetCallSessionParticipantStatsDetailsResponse[callId=$callId, callSessionId=$callSessionId, callType=$callType, duration=$duration, publisher=$publisher, subscriber=$subscriber, timeframe=$timeframe, user=$user, userId=$userId, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_id'] = this.callId;
    json[r'call_session_id'] = this.callSessionId;
    json[r'call_type'] = this.callType;
    json[r'duration'] = this.duration;
    if (this.publisher != null) {
      json[r'publisher'] = this.publisher;
    } else {
      json[r'publisher'] = null;
    }
    if (this.subscriber != null) {
      json[r'subscriber'] = this.subscriber;
    } else {
      json[r'subscriber'] = null;
    }
    if (this.timeframe != null) {
      json[r'timeframe'] = this.timeframe;
    } else {
      json[r'timeframe'] = null;
    }
    if (this.user != null) {
      json[r'user'] = this.user;
    } else {
      json[r'user'] = null;
    }
    json[r'user_id'] = this.userId;
    json[r'user_session_id'] = this.userSessionId;
    return json;
  }

  /// Returns a new [GetCallSessionParticipantStatsDetailsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetCallSessionParticipantStatsDetailsResponse? fromJson(
      dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_id'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_id]" is missing from JSON.');
        assert(json[r'call_id'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_session_id'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_session_id]" is missing from JSON.');
        assert(json[r'call_session_id'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_session_id]" has a null value in JSON.');
        assert(json.containsKey(r'call_type'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_type]" is missing from JSON.');
        assert(json[r'call_type'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[call_type]" has a null value in JSON.');
        assert(json.containsKey(r'duration'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[duration]" is missing from JSON.');
        assert(json[r'duration'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[duration]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'user_session_id'),
            'Required key "GetCallSessionParticipantStatsDetailsResponse[user_session_id]" is missing from JSON.');
        assert(json[r'user_session_id'] != null,
            'Required key "GetCallSessionParticipantStatsDetailsResponse[user_session_id]" has a null value in JSON.');
        return true;
      }());

      return GetCallSessionParticipantStatsDetailsResponse(
        callId: mapValueOfType<String>(json, r'call_id')!,
        callSessionId: mapValueOfType<String>(json, r'call_session_id')!,
        callType: mapValueOfType<String>(json, r'call_type')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        publisher: ParticipantSeriesPublisherStats.fromJson(json[r'publisher']),
        subscriber:
            ParticipantSeriesSubscriberStats.fromJson(json[r'subscriber']),
        timeframe: ParticipantSeriesTimeframe.fromJson(json[r'timeframe']),
        user: ParticipantSeriesUserStats.fromJson(json[r'user']),
        userId: mapValueOfType<String>(json, r'user_id')!,
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
      );
    }
    return null;
  }

  static List<GetCallSessionParticipantStatsDetailsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GetCallSessionParticipantStatsDetailsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            GetCallSessionParticipantStatsDetailsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetCallSessionParticipantStatsDetailsResponse> mapFromJson(
      dynamic json) {
    final map = <String, GetCallSessionParticipantStatsDetailsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value =
            GetCallSessionParticipantStatsDetailsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetCallSessionParticipantStatsDetailsResponse-objects as value to a dart map
  static Map<String, List<GetCallSessionParticipantStatsDetailsResponse>>
      mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GetCallSessionParticipantStatsDetailsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] =
            GetCallSessionParticipantStatsDetailsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_id',
    'call_session_id',
    'call_type',
    'duration',
    'user_id',
    'user_session_id',
  };
}
