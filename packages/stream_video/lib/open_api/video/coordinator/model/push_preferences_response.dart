//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PushPreferencesResponse {
  /// Returns a new [PushPreferencesResponse] instance.
  PushPreferencesResponse({
    this.callLevel,
    this.chatLevel,
    this.disabledUntil,
    this.feedsLevel,
    this.feedsPreferences,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? callLevel;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? chatLevel;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? disabledUntil;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? feedsLevel;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  FeedsPreferencesResponse? feedsPreferences;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushPreferencesResponse &&
          other.callLevel == callLevel &&
          other.chatLevel == chatLevel &&
          other.disabledUntil == disabledUntil &&
          other.feedsLevel == feedsLevel &&
          other.feedsPreferences == feedsPreferences;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callLevel == null ? 0 : callLevel!.hashCode) +
      (chatLevel == null ? 0 : chatLevel!.hashCode) +
      (disabledUntil == null ? 0 : disabledUntil!.hashCode) +
      (feedsLevel == null ? 0 : feedsLevel!.hashCode) +
      (feedsPreferences == null ? 0 : feedsPreferences!.hashCode);

  @override
  String toString() =>
      'PushPreferencesResponse[callLevel=$callLevel, chatLevel=$chatLevel, disabledUntil=$disabledUntil, feedsLevel=$feedsLevel, feedsPreferences=$feedsPreferences]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.callLevel != null) {
      json[r'call_level'] = this.callLevel;
    } else {
      json[r'call_level'] = null;
    }
    if (this.chatLevel != null) {
      json[r'chat_level'] = this.chatLevel;
    } else {
      json[r'chat_level'] = null;
    }
    if (this.disabledUntil != null) {
      json[r'disabled_until'] = this.disabledUntil!.toUtc().toIso8601String();
    } else {
      json[r'disabled_until'] = null;
    }
    if (this.feedsLevel != null) {
      json[r'feeds_level'] = this.feedsLevel;
    } else {
      json[r'feeds_level'] = null;
    }
    if (this.feedsPreferences != null) {
      json[r'feeds_preferences'] = this.feedsPreferences;
    } else {
      json[r'feeds_preferences'] = null;
    }
    return json;
  }

  /// Returns a new [PushPreferencesResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PushPreferencesResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "PushPreferencesResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "PushPreferencesResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PushPreferencesResponse(
        callLevel: mapValueOfType<String>(json, r'call_level'),
        chatLevel: mapValueOfType<String>(json, r'chat_level'),
        disabledUntil: mapDateTime(json, r'disabled_until', r''),
        feedsLevel: mapValueOfType<String>(json, r'feeds_level'),
        feedsPreferences:
            FeedsPreferencesResponse.fromJson(json[r'feeds_preferences']),
      );
    }
    return null;
  }

  static List<PushPreferencesResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PushPreferencesResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PushPreferencesResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PushPreferencesResponse> mapFromJson(dynamic json) {
    final map = <String, PushPreferencesResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PushPreferencesResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PushPreferencesResponse-objects as value to a dart map
  static Map<String, List<PushPreferencesResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PushPreferencesResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PushPreferencesResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
