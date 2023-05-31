//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OwnUserResponse {
  /// Returns a new [OwnUserResponse] instance.
  OwnUserResponse({
    required this.createdAt,
    this.custom = const {},
    this.deletedAt,
    this.devices = const [],
    required this.id,
    this.image,
    this.name,
    required this.role,
    this.teams = const [],
    required this.updatedAt,
  });

  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? deletedAt;

  List<Device> devices;

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
  String? name;

  String role;

  List<String> teams;

  DateTime updatedAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OwnUserResponse &&
     other.createdAt == createdAt &&
     other.custom == custom &&
     other.deletedAt == deletedAt &&
     other.devices == devices &&
     other.id == id &&
     other.image == image &&
     other.name == name &&
     other.role == role &&
     other.teams == teams &&
     other.updatedAt == updatedAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (createdAt.hashCode) +
    (custom.hashCode) +
    (deletedAt == null ? 0 : deletedAt!.hashCode) +
    (devices.hashCode) +
    (id.hashCode) +
    (image == null ? 0 : image!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (role.hashCode) +
    (teams.hashCode) +
    (updatedAt.hashCode);

  @override
  String toString() => 'OwnUserResponse[createdAt=$createdAt, custom=$custom, deletedAt=$deletedAt, devices=$devices, id=$id, image=$image, name=$name, role=$role, teams=$teams, updatedAt=$updatedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'custom'] = this.custom;
    if (this.deletedAt != null) {
      json[r'deleted_at'] = this.deletedAt!.toUtc().toIso8601String();
    } else {
      json[r'deleted_at'] = null;
    }
      json[r'devices'] = this.devices;
      json[r'id'] = this.id;
    if (this.image != null) {
      json[r'image'] = this.image;
    } else {
      json[r'image'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
      json[r'role'] = this.role;
      json[r'teams'] = this.teams;
      json[r'updated_at'] = this.updatedAt.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [OwnUserResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OwnUserResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OwnUserResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OwnUserResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OwnUserResponse(
        createdAt: mapDateTime(json, r'created_at', '')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        deletedAt: mapDateTime(json, r'deleted_at', ''),
        devices: Device.listFromJson(json[r'devices']),
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        name: mapValueOfType<String>(json, r'name'),
        role: mapValueOfType<String>(json, r'role')!,
        teams: json[r'teams'] is List
            ? (json[r'teams'] as List).cast<String>()
            : const [],
        updatedAt: mapDateTime(json, r'updated_at', '')!,
      );
    }
    return null;
  }

  static List<OwnUserResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OwnUserResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OwnUserResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OwnUserResponse> mapFromJson(dynamic json) {
    final map = <String, OwnUserResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OwnUserResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OwnUserResponse-objects as value to a dart map
  static Map<String, List<OwnUserResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OwnUserResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OwnUserResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'created_at',
    'custom',
    'devices',
    'id',
    'role',
    'teams',
    'updated_at',
  };
}

