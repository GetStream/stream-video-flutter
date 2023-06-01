//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConnectUserDetailsRequest {
  /// Returns a new [ConnectUserDetailsRequest] instance.
  ConnectUserDetailsRequest({
    this.custom = const {},
    required this.id,
    this.image,
    this.name,
  });

  Map<String, Object> custom;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectUserDetailsRequest &&
     other.custom == custom &&
     other.id == id &&
     other.image == image &&
     other.name == name;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (id.hashCode) +
    (image == null ? 0 : image!.hashCode) +
    (name == null ? 0 : name!.hashCode);

  @override
  String toString() => 'ConnectUserDetailsRequest[custom=$custom, id=$id, image=$image, name=$name]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
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
    return json;
  }

  /// Returns a new [ConnectUserDetailsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectUserDetailsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectUserDetailsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectUserDetailsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectUserDetailsRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        id: mapValueOfType<String>(json, r'id')!,
        image: mapValueOfType<String>(json, r'image'),
        name: mapValueOfType<String>(json, r'name'),
      );
    }
    return null;
  }

  static List<ConnectUserDetailsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectUserDetailsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectUserDetailsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectUserDetailsRequest> mapFromJson(dynamic json) {
    final map = <String, ConnectUserDetailsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectUserDetailsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectUserDetailsRequest-objects as value to a dart map
  static Map<String, List<ConnectUserDetailsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectUserDetailsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectUserDetailsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
  };
}

