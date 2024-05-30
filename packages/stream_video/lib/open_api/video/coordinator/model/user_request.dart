//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserRequest {
  /// Returns a new [UserRequest] instance.
  UserRequest({
    this.custom = const {},
    required this.id,
    this.image,
    this.invisible,
    this.language,
    this.name,
    this.privacySettings,
    this.pushNotifications,
  });

  Map<String, Object> custom;

  /// User ID
  String id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? image;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? invisible;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? language;

  /// Optional name of user
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PrivacySettings? privacySettings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PushNotificationSettingsInput? pushNotifications;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserRequest &&
    _deepEquality.equals(other.custom, custom) &&
    other.id == id &&
    other.image == image &&
    other.invisible == invisible &&
    other.language == language &&
    other.name == name &&
    other.privacySettings == privacySettings &&
    other.pushNotifications == pushNotifications;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (id.hashCode) +
    (image == null ? 0 : image!.hashCode) +
    (invisible == null ? 0 : invisible!.hashCode) +
    (language == null ? 0 : language!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (privacySettings == null ? 0 : privacySettings!.hashCode) +
    (pushNotifications == null ? 0 : pushNotifications!.hashCode);

  @override
  String toString() => 'UserRequest[custom=$custom, id=$id, image=$image, invisible=$invisible, language=$language, name=$name, privacySettings=$privacySettings, pushNotifications=$pushNotifications]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
      json[r'id'] = this.id;
    if (this.image != null) {
      json[r'image'] = this.image;
    } else {
      json[r'image'] = null;
    }
    if (this.invisible != null) {
      json[r'invisible'] = this.invisible;
    } else {
      json[r'invisible'] = null;
    }
    if (this.language != null) {
      json[r'language'] = this.language;
    } else {
      json[r'language'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.privacySettings != null) {
      json[r'privacy_settings'] = this.privacySettings;
    } else {
      json[r'privacy_settings'] = null;
    }
    if (this.pushNotifications != null) {
      json[r'push_notifications'] = this.pushNotifications;
    } else {
      json[r'push_notifications'] = null;
    }
    return json;
  }

  /// Returns a new [UserRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        invisible: mapValueOfType<bool>(json, r'invisible'),
        language: mapValueOfType<String>(json, r'language'),
        name: mapValueOfType<String>(json, r'name'),
        privacySettings: PrivacySettings.fromJson(json[r'privacy_settings']),
        pushNotifications: PushNotificationSettingsInput.fromJson(json[r'push_notifications']),
      );
    }
    return null;
  }

  static List<UserRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserRequest> mapFromJson(dynamic json) {
    final map = <String, UserRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserRequest-objects as value to a dart map
  static Map<String, List<UserRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

