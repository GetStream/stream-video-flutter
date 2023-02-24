//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GetOrCreateCallRequest {
  /// Returns a new [GetOrCreateCallRequest] instance.
  GetOrCreateCallRequest({
    this.data,
    this.members,
    this.ring,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  CallRequest? data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  PaginationParamsRequest? members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? ring;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GetOrCreateCallRequest &&
     other.data == data &&
     other.members == members &&
     other.ring == ring;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (data == null ? 0 : data!.hashCode) +
    (members == null ? 0 : members!.hashCode) +
    (ring == null ? 0 : ring!.hashCode);

  @override
  String toString() => 'GetOrCreateCallRequest[data=$data, members=$members, ring=$ring]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    if (this.members != null) {
      json[r'members'] = this.members;
    } else {
      json[r'members'] = null;
    }
    if (this.ring != null) {
      json[r'ring'] = this.ring;
    } else {
      json[r'ring'] = null;
    }
    return json;
  }

  /// Returns a new [GetOrCreateCallRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GetOrCreateCallRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GetOrCreateCallRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GetOrCreateCallRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GetOrCreateCallRequest(
        data: CallRequest.fromJson(json[r'data']),
        members: PaginationParamsRequest.fromJson(json[r'members']),
        ring: mapValueOfType<bool>(json, r'ring'),
      );
    }
    return null;
  }

  static List<GetOrCreateCallRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GetOrCreateCallRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GetOrCreateCallRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GetOrCreateCallRequest> mapFromJson(dynamic json) {
    final map = <String, GetOrCreateCallRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetOrCreateCallRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GetOrCreateCallRequest-objects as value to a dart map
  static Map<String, List<GetOrCreateCallRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GetOrCreateCallRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GetOrCreateCallRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

