//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsParticipantSession {
  /// Returns a new [CallStatsParticipantSession] instance.
  CallStatsParticipantSession({
    this.browser,
    this.browserVersion,
    this.cqScore,
    this.currentIp,
    this.currentSfu,
    this.distanceToSfuKilometers,
    this.endedAt,
    this.freezesDurationMs,
    required this.isLive,
    this.jitterMs,
    this.latencyMs,
    this.location,
    this.os,
    required this.publishedTracks,
    this.publisherType,
    this.sdk,
    this.sdkVersion,
    this.startedAt,
    this.unifiedSessionId,
    required this.userSessionId,
    this.webrtcVersion,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? browser;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? browserVersion;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? cqScore;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currentIp;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currentSfu;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? distanceToSfuKilometers;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? endedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? freezesDurationMs;

  bool isLive;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? jitterMs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? latencyMs;

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
  String? os;

  PublishedTrackFlags publishedTracks;

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
  String? sdk;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdkVersion;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unifiedSessionId;

  String userSessionId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? webrtcVersion;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsParticipantSession &&
          other.browser == browser &&
          other.browserVersion == browserVersion &&
          other.cqScore == cqScore &&
          other.currentIp == currentIp &&
          other.currentSfu == currentSfu &&
          other.distanceToSfuKilometers == distanceToSfuKilometers &&
          other.endedAt == endedAt &&
          other.freezesDurationMs == freezesDurationMs &&
          other.isLive == isLive &&
          other.jitterMs == jitterMs &&
          other.latencyMs == latencyMs &&
          other.location == location &&
          other.os == os &&
          other.publishedTracks == publishedTracks &&
          other.publisherType == publisherType &&
          other.sdk == sdk &&
          other.sdkVersion == sdkVersion &&
          other.startedAt == startedAt &&
          other.unifiedSessionId == unifiedSessionId &&
          other.userSessionId == userSessionId &&
          other.webrtcVersion == webrtcVersion;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (browser == null ? 0 : browser!.hashCode) +
      (browserVersion == null ? 0 : browserVersion!.hashCode) +
      (cqScore == null ? 0 : cqScore!.hashCode) +
      (currentIp == null ? 0 : currentIp!.hashCode) +
      (currentSfu == null ? 0 : currentSfu!.hashCode) +
      (distanceToSfuKilometers == null
          ? 0
          : distanceToSfuKilometers!.hashCode) +
      (endedAt == null ? 0 : endedAt!.hashCode) +
      (freezesDurationMs == null ? 0 : freezesDurationMs!.hashCode) +
      (isLive.hashCode) +
      (jitterMs == null ? 0 : jitterMs!.hashCode) +
      (latencyMs == null ? 0 : latencyMs!.hashCode) +
      (location == null ? 0 : location!.hashCode) +
      (os == null ? 0 : os!.hashCode) +
      (publishedTracks.hashCode) +
      (publisherType == null ? 0 : publisherType!.hashCode) +
      (sdk == null ? 0 : sdk!.hashCode) +
      (sdkVersion == null ? 0 : sdkVersion!.hashCode) +
      (startedAt == null ? 0 : startedAt!.hashCode) +
      (unifiedSessionId == null ? 0 : unifiedSessionId!.hashCode) +
      (userSessionId.hashCode) +
      (webrtcVersion == null ? 0 : webrtcVersion!.hashCode);

  @override
  String toString() =>
      'CallStatsParticipantSession[browser=$browser, browserVersion=$browserVersion, cqScore=$cqScore, currentIp=$currentIp, currentSfu=$currentSfu, distanceToSfuKilometers=$distanceToSfuKilometers, endedAt=$endedAt, freezesDurationMs=$freezesDurationMs, isLive=$isLive, jitterMs=$jitterMs, latencyMs=$latencyMs, location=$location, os=$os, publishedTracks=$publishedTracks, publisherType=$publisherType, sdk=$sdk, sdkVersion=$sdkVersion, startedAt=$startedAt, unifiedSessionId=$unifiedSessionId, userSessionId=$userSessionId, webrtcVersion=$webrtcVersion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.browser != null) {
      json[r'browser'] = this.browser;
    } else {
      json[r'browser'] = null;
    }
    if (this.browserVersion != null) {
      json[r'browser_version'] = this.browserVersion;
    } else {
      json[r'browser_version'] = null;
    }
    if (this.cqScore != null) {
      json[r'cq_score'] = this.cqScore;
    } else {
      json[r'cq_score'] = null;
    }
    if (this.currentIp != null) {
      json[r'current_ip'] = this.currentIp;
    } else {
      json[r'current_ip'] = null;
    }
    if (this.currentSfu != null) {
      json[r'current_sfu'] = this.currentSfu;
    } else {
      json[r'current_sfu'] = null;
    }
    if (this.distanceToSfuKilometers != null) {
      json[r'distance_to_sfu_kilometers'] = this.distanceToSfuKilometers;
    } else {
      json[r'distance_to_sfu_kilometers'] = null;
    }
    if (this.endedAt != null) {
      json[r'ended_at'] = this.endedAt!.toUtc().toIso8601String();
    } else {
      json[r'ended_at'] = null;
    }
    if (this.freezesDurationMs != null) {
      json[r'freezes_duration_ms'] = this.freezesDurationMs;
    } else {
      json[r'freezes_duration_ms'] = null;
    }
    json[r'is_live'] = this.isLive;
    if (this.jitterMs != null) {
      json[r'jitter_ms'] = this.jitterMs;
    } else {
      json[r'jitter_ms'] = null;
    }
    if (this.latencyMs != null) {
      json[r'latency_ms'] = this.latencyMs;
    } else {
      json[r'latency_ms'] = null;
    }
    if (this.location != null) {
      json[r'location'] = this.location;
    } else {
      json[r'location'] = null;
    }
    if (this.os != null) {
      json[r'os'] = this.os;
    } else {
      json[r'os'] = null;
    }
    json[r'published_tracks'] = this.publishedTracks;
    if (this.publisherType != null) {
      json[r'publisher_type'] = this.publisherType;
    } else {
      json[r'publisher_type'] = null;
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
    if (this.startedAt != null) {
      json[r'started_at'] = this.startedAt!.toUtc().toIso8601String();
    } else {
      json[r'started_at'] = null;
    }
    if (this.unifiedSessionId != null) {
      json[r'unified_session_id'] = this.unifiedSessionId;
    } else {
      json[r'unified_session_id'] = null;
    }
    json[r'user_session_id'] = this.userSessionId;
    if (this.webrtcVersion != null) {
      json[r'webrtc_version'] = this.webrtcVersion;
    } else {
      json[r'webrtc_version'] = null;
    }
    return json;
  }

  /// Returns a new [CallStatsParticipantSession] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsParticipantSession? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'is_live'),
            'Required key "CallStatsParticipantSession[is_live]" is missing from JSON.');
        assert(json[r'is_live'] != null,
            'Required key "CallStatsParticipantSession[is_live]" has a null value in JSON.');
        assert(json.containsKey(r'published_tracks'),
            'Required key "CallStatsParticipantSession[published_tracks]" is missing from JSON.');
        assert(json[r'published_tracks'] != null,
            'Required key "CallStatsParticipantSession[published_tracks]" has a null value in JSON.');
        assert(json.containsKey(r'user_session_id'),
            'Required key "CallStatsParticipantSession[user_session_id]" is missing from JSON.');
        assert(json[r'user_session_id'] != null,
            'Required key "CallStatsParticipantSession[user_session_id]" has a null value in JSON.');
        return true;
      }());

      return CallStatsParticipantSession(
        browser: mapValueOfType<String>(json, r'browser'),
        browserVersion: mapValueOfType<String>(json, r'browser_version'),
        cqScore: mapValueOfType<int>(json, r'cq_score'),
        currentIp: mapValueOfType<String>(json, r'current_ip'),
        currentSfu: mapValueOfType<String>(json, r'current_sfu'),
        distanceToSfuKilometers:
            mapValueOfType<double>(json, r'distance_to_sfu_kilometers'),
        endedAt: mapDateTime(json, r'ended_at', r''),
        freezesDurationMs: mapValueOfType<int>(json, r'freezes_duration_ms'),
        isLive: mapValueOfType<bool>(json, r'is_live')!,
        jitterMs: mapValueOfType<int>(json, r'jitter_ms'),
        latencyMs: mapValueOfType<int>(json, r'latency_ms'),
        location: CallStatsLocation.fromJson(json[r'location']),
        os: mapValueOfType<String>(json, r'os'),
        publishedTracks:
            PublishedTrackFlags.fromJson(json[r'published_tracks'])!,
        publisherType: mapValueOfType<String>(json, r'publisher_type'),
        sdk: mapValueOfType<String>(json, r'sdk'),
        sdkVersion: mapValueOfType<String>(json, r'sdk_version'),
        startedAt: mapDateTime(json, r'started_at', r''),
        unifiedSessionId: mapValueOfType<String>(json, r'unified_session_id'),
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
        webrtcVersion: mapValueOfType<String>(json, r'webrtc_version'),
      );
    }
    return null;
  }

  static List<CallStatsParticipantSession> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsParticipantSession>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsParticipantSession.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsParticipantSession> mapFromJson(dynamic json) {
    final map = <String, CallStatsParticipantSession>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsParticipantSession.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsParticipantSession-objects as value to a dart map
  static Map<String, List<CallStatsParticipantSession>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsParticipantSession>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsParticipantSession.listFromJson(
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
    'user_session_id',
  };
}
