//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallMembersResponse {
  /// Returns a new [QueryCallMembersResponse] instance.
  QueryCallMembersResponse({
    required this.duration,
    this.members = const [],
    this.next,
    this.prev,
  });

  /// Duration of the request in milliseconds
  String duration;

  List<MemberResponse> members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? next;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? prev;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QueryCallMembersResponse &&
    other.duration == duration &&
    _deepEquality.equals(other.members, members) &&
    other.next == next &&
    other.prev == prev;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (duration.hashCode) +
    (members.hashCode) +
    (next == null ? 0 : next!.hashCode) +
    (prev == null ? 0 : prev!.hashCode);

  @override
  String toString() => 'QueryCallMembersResponse[duration=$duration, members=$members, next=$next, prev=$prev]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'duration'] = this.duration;
      json[r'members'] = this.members;
    if (this.next != null) {
      json[r'next'] = this.next;
    } else {
      json[r'next'] = null;
    }
    if (this.prev != null) {
      json[r'prev'] = this.prev;
    } else {
      json[r'prev'] = null;
    }
    return json;
  }

  /// Returns a new [QueryCallMembersResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallMembersResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "QueryCallMembersResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "QueryCallMembersResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryCallMembersResponse(
        duration: mapValueOfType<String>(json, r'duration')!,
        members: MemberResponse.listFromJson(json[r'members']),
        next: mapValueOfType<String>(json, r'next'),
        prev: mapValueOfType<String>(json, r'prev'),
      );
    }
    return null;
  }

  static List<QueryCallMembersResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QueryCallMembersResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallMembersResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallMembersResponse> mapFromJson(dynamic json) {
    final map = <String, QueryCallMembersResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryCallMembersResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallMembersResponse-objects as value to a dart map
  static Map<String, List<QueryCallMembersResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QueryCallMembersResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallMembersResponse.listFromJson(entry.value, growable: growable,);
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

