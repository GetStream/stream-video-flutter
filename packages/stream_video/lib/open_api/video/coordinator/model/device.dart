//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Device {
  /// Returns a new [Device] instance.
  Device({
    required this.createdAt,
    this.disabled,
    this.disabledReason,
    required this.id,
    required this.pushProvider,
    this.pushProviderName,
    this.voip,
  });

  /// Date/time of creation
  DateTime createdAt;

  /// Whether device is disabled or not
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? disabled;

  /// Reason explaining why device had been disabled
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? disabledReason;

  String id;

  String pushProvider;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pushProviderName;

  /// When true the token is for Apple VoIP push notifications
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? voip;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Device &&
     other.createdAt == createdAt &&
     other.disabled == disabled &&
     other.disabledReason == disabledReason &&
     other.id == id &&
     other.pushProvider == pushProvider &&
     other.pushProviderName == pushProviderName &&
     other.voip == voip;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (disabled == null ? 0 : disabled!.hashCode) +
    (disabledReason == null ? 0 : disabledReason!.hashCode) +
    (id.hashCode) +
    (pushProvider.hashCode) +
    (pushProviderName == null ? 0 : pushProviderName!.hashCode) +
    (voip == null ? 0 : voip!.hashCode);

  @override
  String toString() => 'Device[createdAt=$createdAt, disabled=$disabled, disabledReason=$disabledReason, id=$id, pushProvider=$pushProvider, pushProviderName=$pushProviderName, voip=$voip]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.disabled != null) {
      json[r'disabled'] = this.disabled;
    } else {
      json[r'disabled'] = null;
    }
    if (this.disabledReason != null) {
      json[r'disabled_reason'] = this.disabledReason;
    } else {
      json[r'disabled_reason'] = null;
    }
      json[r'id'] = this.id;
      json[r'push_provider'] = this.pushProvider;
    if (this.pushProviderName != null) {
      json[r'push_provider_name'] = this.pushProviderName;
    } else {
      json[r'push_provider_name'] = null;
    }
    if (this.voip != null) {
      json[r'voip'] = this.voip;
    } else {
      json[r'voip'] = null;
    }
    return json;
  }

  /// Returns a new [Device] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Device? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Device[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Device[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Device(
        createdAt: mapDateTime(json, r'created_at', '')!,
        disabled: mapValueOfType<bool>(json, r'disabled'),
        disabledReason: mapValueOfType<String>(json, r'disabled_reason'),
        id: mapValueOfType<String>(json, r'id')!,
        pushProvider: mapValueOfType<String>(json, r'push_provider')!,
        pushProviderName: mapValueOfType<String>(json, r'push_provider_name'),
        voip: mapValueOfType<bool>(json, r'voip'),
      );
    }
    return null;
  }

  static List<Device> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Device>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Device.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Device> mapFromJson(dynamic json) {
    final map = <String, Device>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Device.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Device-objects as value to a dart map
  static Map<String, List<Device>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Device>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Device.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'id',
    'push_provider',
  };
}

