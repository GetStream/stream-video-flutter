//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MemberRequest {
  /// Returns a new [MemberRequest] instance.
  MemberRequest({
    this.custom = const {},
    this.role,
    required this.userId,
  });

  /// Custom data for this object
  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? role;

  String userId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MemberRequest &&
     other.custom == custom &&
     other.role == role &&
     other.userId == userId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (custom.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (userId.hashCode);

  @override
  String toString() => 'MemberRequest[custom=$custom, role=$role, userId=$userId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'custom'] = this.custom;
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
      json[r'user_id'] = this.userId;
    return json;
  }

  /// Returns a new [MemberRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MemberRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MemberRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MemberRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MemberRequest(
        custom: mapCastOfType<String, Object>(json, r'custom') ?? const {},
        role: mapValueOfType<String>(json, r'role'),
        userId: mapValueOfType<String>(json, r'user_id')!,
      );
    }
    return null;
  }

  static List<MemberRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MemberRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MemberRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MemberRequest> mapFromJson(dynamic json) {
    final map = <String, MemberRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MemberRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MemberRequest-objects as value to a dart map
  static Map<String, List<MemberRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MemberRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MemberRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'user_id',
  };
}

