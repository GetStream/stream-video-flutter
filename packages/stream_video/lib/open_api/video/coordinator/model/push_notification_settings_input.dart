//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PushNotificationSettingsInput {
  /// Returns a new [PushNotificationSettingsInput] instance.
  PushNotificationSettingsInput({
    this.disabled,
    this.disabledUntil,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  NullBool? disabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  NullTime? disabledUntil;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PushNotificationSettingsInput &&
    other.disabled == disabled &&
    other.disabledUntil == disabledUntil;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (disabled == null ? 0 : disabled!.hashCode) +
    (disabledUntil == null ? 0 : disabledUntil!.hashCode);

  @override
  String toString() => 'PushNotificationSettingsInput[disabled=$disabled, disabledUntil=$disabledUntil]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.disabled != null) {
      json[r'disabled'] = this.disabled;
    } else {
      json[r'disabled'] = null;
    }
    if (this.disabledUntil != null) {
      json[r'disabled_until'] = this.disabledUntil;
    } else {
      json[r'disabled_until'] = null;
    }
    return json;
  }

  /// Returns a new [PushNotificationSettingsInput] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PushNotificationSettingsInput? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PushNotificationSettingsInput[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PushNotificationSettingsInput[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PushNotificationSettingsInput(
        disabled: NullBool.fromJson(json[r'disabled']),
        disabledUntil: NullTime.fromJson(json[r'disabled_until']),
      );
    }
    return null;
  }

  static List<PushNotificationSettingsInput> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PushNotificationSettingsInput>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PushNotificationSettingsInput.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PushNotificationSettingsInput> mapFromJson(dynamic json) {
    final map = <String, PushNotificationSettingsInput>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PushNotificationSettingsInput.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PushNotificationSettingsInput-objects as value to a dart map
  static Map<String, List<PushNotificationSettingsInput>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PushNotificationSettingsInput>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PushNotificationSettingsInput.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

