//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RequestPermissionRequest {
  /// Returns a new [RequestPermissionRequest] instance.
  RequestPermissionRequest({
    this.permissions = const [],
  });

  List<String> permissions;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RequestPermissionRequest &&
     other.permissions == permissions;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (permissions.hashCode);

  @override
  String toString() => 'RequestPermissionRequest[permissions=$permissions]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'permissions'] = this.permissions;
    return json;
  }

  /// Returns a new [RequestPermissionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RequestPermissionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RequestPermissionRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RequestPermissionRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RequestPermissionRequest(
        permissions: json[r'permissions'] is List
            ? (json[r'permissions'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }

  static List<RequestPermissionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RequestPermissionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RequestPermissionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RequestPermissionRequest> mapFromJson(dynamic json) {
    final map = <String, RequestPermissionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RequestPermissionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RequestPermissionRequest-objects as value to a dart map
  static Map<String, List<RequestPermissionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RequestPermissionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RequestPermissionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'permissions',
  };
}

