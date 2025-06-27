//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GroupedStatsResponse {
  /// Returns a new [GroupedStatsResponse] instance.
  GroupedStatsResponse({
    required this.name,
    required this.unique,
  });

  String name;

  int unique;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupedStatsResponse &&
          other.name == name &&
          other.unique == unique;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (name.hashCode) + (unique.hashCode);

  @override
  String toString() => 'GroupedStatsResponse[name=$name, unique=$unique]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'name'] = this.name;
    json[r'unique'] = this.unique;
    return json;
  }

  /// Returns a new [GroupedStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GroupedStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "GroupedStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "GroupedStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GroupedStatsResponse(
        name: mapValueOfType<String>(json, r'name')!,
        unique: mapValueOfType<int>(json, r'unique')!,
      );
    }
    return null;
  }

  static List<GroupedStatsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <GroupedStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GroupedStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GroupedStatsResponse> mapFromJson(dynamic json) {
    final map = <String, GroupedStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GroupedStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GroupedStatsResponse-objects as value to a dart map
  static Map<String, List<GroupedStatsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<GroupedStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GroupedStatsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'unique',
  };
}
