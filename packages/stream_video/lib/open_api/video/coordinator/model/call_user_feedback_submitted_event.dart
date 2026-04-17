//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallUserFeedbackSubmittedEvent {
  /// Returns a new [CallUserFeedbackSubmittedEvent] instance.
  CallUserFeedbackSubmittedEvent({
    required this.callCid,
    required this.createdAt,
    this.custom = const {},
    required this.rating,
    this.reason,
    this.sdk,
    this.sdkVersion,
    required this.sessionId,
    this.type = 'call.user_feedback_submitted',
    required this.user,
  });

  String callCid;

  DateTime createdAt;

  /// Custom data provided by the user
  Map<String, Object> custom;

  /// The rating given by the user (1-5)
  int rating;

  /// The reason provided by the user for the rating
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdk;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdkVersion;

  /// Call session ID
  String sessionId;

  /// The type of event, \"call.user_feedback\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallUserFeedbackSubmittedEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.rating == rating &&
          other.reason == reason &&
          other.sdk == sdk &&
          other.sdkVersion == sdkVersion &&
          other.sessionId == sessionId &&
          other.type == type &&
          other.user == user;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (rating.hashCode) +
      (reason == null ? 0 : reason!.hashCode) +
      (sdk == null ? 0 : sdk!.hashCode) +
      (sdkVersion == null ? 0 : sdkVersion!.hashCode) +
      (sessionId.hashCode) +
      (type.hashCode) +
      (user.hashCode);

  @override
  String toString() =>
      'CallUserFeedbackSubmittedEvent[callCid=$callCid, createdAt=$createdAt, custom=$custom, rating=$rating, reason=$reason, sdk=$sdk, sdkVersion=$sdkVersion, sessionId=$sessionId, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    json[r'rating'] = this.rating;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    if (this.sdk != null) {
      json[r'sdk'] = this.sdk;
    } else {
      json[r'sdk'] = null;
    }
    if (this.sdkVersion != null) {
      json[r'sdk_version'] = this.sdkVersion;
    } else {
      json[r'sdk_version'] = null;
    }
    json[r'session_id'] = this.sessionId;
    json[r'type'] = this.type;
    json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [CallUserFeedbackSubmittedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallUserFeedbackSubmittedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "CallUserFeedbackSubmittedEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "CallUserFeedbackSubmittedEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'rating'),
            'Required key "CallUserFeedbackSubmittedEvent[rating]" is missing from JSON.');
        assert(json[r'rating'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[rating]" has a null value in JSON.');
        assert(json.containsKey(r'session_id'),
            'Required key "CallUserFeedbackSubmittedEvent[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[session_id]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "CallUserFeedbackSubmittedEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "CallUserFeedbackSubmittedEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "CallUserFeedbackSubmittedEvent[user]" has a null value in JSON.');
        return true;
      }());

      return CallUserFeedbackSubmittedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        rating: mapValueOfType<int>(json, r'rating')!,
        reason: mapValueOfType<String>(json, r'reason'),
        sdk: mapValueOfType<String>(json, r'sdk'),
        sdkVersion: mapValueOfType<String>(json, r'sdk_version'),
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<CallUserFeedbackSubmittedEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallUserFeedbackSubmittedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallUserFeedbackSubmittedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallUserFeedbackSubmittedEvent> mapFromJson(dynamic json) {
    final map = <String, CallUserFeedbackSubmittedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallUserFeedbackSubmittedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallUserFeedbackSubmittedEvent-objects as value to a dart map
  static Map<String, List<CallUserFeedbackSubmittedEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallUserFeedbackSubmittedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallUserFeedbackSubmittedEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'rating',
    'session_id',
    'type',
    'user',
  };
}
