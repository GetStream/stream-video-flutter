//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CollectUserFeedbackRequest {
  /// Returns a new [CollectUserFeedbackRequest] instance.
  CollectUserFeedbackRequest({
    this.custom = const {},
    required this.rating,
    this.reason,
    required this.sdk,
    required this.sdkVersion,
    required this.userSessionId,
  });

  Map<String, Object> custom;

  /// Minimum value: 1
  /// Maximum value: 5
  int rating;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  String sdk;

  String sdkVersion;

  String userSessionId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CollectUserFeedbackRequest &&
    _deepEquality.equals(other.custom, custom) &&
    other.rating == rating &&
    other.reason == reason &&
    other.sdk == sdk &&
    other.sdkVersion == sdkVersion &&
    other.userSessionId == userSessionId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (rating.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (sdk.hashCode) +
    (sdkVersion.hashCode) +
    (userSessionId.hashCode);

  @override
  String toString() => 'CollectUserFeedbackRequest[custom=$custom, rating=$rating, reason=$reason, sdk=$sdk, sdkVersion=$sdkVersion, userSessionId=$userSessionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'rating'] = this.rating;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'sdk'] = this.sdk;
      json[r'sdk_version'] = this.sdkVersion;
      json[r'user_session_id'] = this.userSessionId;
    return json;
  }

  /// Returns a new [CollectUserFeedbackRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CollectUserFeedbackRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CollectUserFeedbackRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CollectUserFeedbackRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CollectUserFeedbackRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        rating: mapValueOfType<int>(json, r'rating')!,
        reason: mapValueOfType<String>(json, r'reason'),
        sdk: mapValueOfType<String>(json, r'sdk')!,
        sdkVersion: mapValueOfType<String>(json, r'sdk_version')!,
        userSessionId: mapValueOfType<String>(json, r'user_session_id')!,
      );
    }
    return null;
  }

  static List<CollectUserFeedbackRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CollectUserFeedbackRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CollectUserFeedbackRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CollectUserFeedbackRequest> mapFromJson(dynamic json) {
    final map = <String, CollectUserFeedbackRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CollectUserFeedbackRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CollectUserFeedbackRequest-objects as value to a dart map
  static Map<String, List<CollectUserFeedbackRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CollectUserFeedbackRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CollectUserFeedbackRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'rating',
    'sdk',
    'sdk_version',
    'user_session_id',
  };
}

