//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateCallMembersResponse {
  /// Returns a new [UpdateCallMembersResponse] instance.
  UpdateCallMembersResponse({
    required this.duration,
    this.members = const [],
  });

  /// Duration of the request in human-readable format
  String duration;

  List<MemberResponse> members;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateCallMembersResponse &&
     other.duration == duration &&
     other.members == members;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (duration.hashCode) +
    (members.hashCode);

  @override
  String toString() => 'UpdateCallMembersResponse[duration=$duration, members=$members]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'duration'] = this.duration;
      json[r'members'] = this.members;
    return json;
  }

  /// Returns a new [UpdateCallMembersResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateCallMembersResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdateCallMembersResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdateCallMembersResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdateCallMembersResponse(
        duration: mapValueOfType<String>(json, r'duration')!,
        members: MemberResponse.listFromJson(json[r'members']),
      );
    }
    return null;
  }

  static List<UpdateCallMembersResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateCallMembersResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateCallMembersResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateCallMembersResponse> mapFromJson(dynamic json) {
    final map = <String, UpdateCallMembersResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateCallMembersResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateCallMembersResponse-objects as value to a dart map
  static Map<String, List<UpdateCallMembersResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateCallMembersResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateCallMembersResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
    'members',
  };
}

