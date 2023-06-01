//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateCallMembersRequest {
  /// Returns a new [UpdateCallMembersRequest] instance.
  UpdateCallMembersRequest({
    this.removeMembers = const [],
    this.updateMembers = const [],
  });

  /// List of userID to remove
  List<String> removeMembers;

  /// List of members to update or insert
  List<MemberRequest> updateMembers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateCallMembersRequest &&
     other.removeMembers == removeMembers &&
     other.updateMembers == updateMembers;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (removeMembers.hashCode) +
    (updateMembers.hashCode);

  @override
  String toString() => 'UpdateCallMembersRequest[removeMembers=$removeMembers, updateMembers=$updateMembers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'remove_members'] = this.removeMembers;
      json[r'update_members'] = this.updateMembers;
    return json;
  }

  /// Returns a new [UpdateCallMembersRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateCallMembersRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateCallMembersRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateCallMembersRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateCallMembersRequest(
        removeMembers: json[r'remove_members'] is List
            ? (json[r'remove_members'] as List).cast<String>()
            : const [],
        updateMembers: MemberRequest.listFromJson(json[r'update_members']),
      );
    }
    return null;
  }

  static List<UpdateCallMembersRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateCallMembersRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateCallMembersRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateCallMembersRequest> mapFromJson(dynamic json) {
    final map = <String, UpdateCallMembersRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateCallMembersRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateCallMembersRequest-objects as value to a dart map
  static Map<String, List<UpdateCallMembersRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateCallMembersRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateCallMembersRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

