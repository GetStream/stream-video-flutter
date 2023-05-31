//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateCallTypeResponse {
  /// Returns a new [UpdateCallTypeResponse] instance.
  UpdateCallTypeResponse({
    required this.createdAt,
    required this.duration,
    this.grants = const {},
    required this.name,
    required this.notificationSettings,
    required this.settings,
    required this.updatedAt,
  });

  DateTime createdAt;

  String duration;

  Map<String, List<String>> grants;

  String name;

  NotificationSettings notificationSettings;

  CallSettingsResponse settings;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateCallTypeResponse &&
     other.createdAt == createdAt &&
     other.duration == duration &&
     other.grants == grants &&
     other.name == name &&
     other.notificationSettings == notificationSettings &&
     other.settings == settings &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (duration.hashCode) +
    (grants.hashCode) +
    (name.hashCode) +
    (notificationSettings.hashCode) +
    (settings.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'UpdateCallTypeResponse[createdAt=$createdAt, duration=$duration, grants=$grants, name=$name, notificationSettings=$notificationSettings, settings=$settings, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'duration'] = this.duration;
      json[r'grants'] = this.grants;
      json[r'name'] = this.name;
      json[r'notification_settings'] = this.notificationSettings;
      json[r'settings'] = this.settings;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [UpdateCallTypeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateCallTypeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateCallTypeResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateCallTypeResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateCallTypeResponse(
        createdAt: mapDateTime(json, r'created_at', '')!,
        duration: mapValueOfType<String>(json, r'duration')!,
        grants: json[r'grants'] == null
          ? const {}
            : mapCastOfType<String, List<String>>(json, r'grants') ?? const {},
        name: mapValueOfType<String>(json, r'name')!,
        notificationSettings: NotificationSettings.fromJson(json[r'notification_settings'])!,
        settings: CallSettingsResponse.fromJson(json[r'settings'])!,
        updatedAt: mapDateTime(json, r'updated_at', '')!,
      );
    }
    return null;
  }

  static List<UpdateCallTypeResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateCallTypeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateCallTypeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateCallTypeResponse> mapFromJson(dynamic json) {
    final map = <String, UpdateCallTypeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateCallTypeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateCallTypeResponse-objects as value to a dart map
  static Map<String, List<UpdateCallTypeResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateCallTypeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateCallTypeResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'duration',
    'grants',
    'name',
    'notification_settings',
    'settings',
    'updated_at',
  };
}

