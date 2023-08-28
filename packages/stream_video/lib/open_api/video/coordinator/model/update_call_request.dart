//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateCallRequest {
  /// Returns a new [UpdateCallRequest] instance.
  UpdateCallRequest({
    this.custom = const {},
    this.settingsOverride,
    this.startsAt,
  });

  /// Custom data for this object
  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallSettingsRequest? settingsOverride;

  /// the time the call is scheduled to start
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startsAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateCallRequest &&
     other.custom == custom &&
     other.settingsOverride == settingsOverride &&
     other.startsAt == startsAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (settingsOverride == null ? 0 : settingsOverride!.hashCode) +
    (startsAt == null ? 0 : startsAt!.hashCode);

  @override
  String toString() => 'UpdateCallRequest[custom=$custom, settingsOverride=$settingsOverride, startsAt=$startsAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
    if (this.settingsOverride != null) {
      json[r'settings_override'] = this.settingsOverride;
    } else {
      json[r'settings_override'] = null;
    }
    if (this.startsAt != null) {
      json[r'starts_at'] = this.startsAt!.toUtc().toIso8601String();
    } else {
      json[r'starts_at'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateCallRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateCallRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateCallRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        settingsOverride: CallSettingsRequest.fromJson(json[r'settings_override']),
        startsAt: mapDateTime(json, r'starts_at', ''),
      );
    }
    return null;
  }

  static List<UpdateCallRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateCallRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateCallRequest-objects as value to a dart map
  static Map<String, List<UpdateCallRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateCallRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

