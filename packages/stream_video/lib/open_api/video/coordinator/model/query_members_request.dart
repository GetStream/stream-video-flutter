//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryMembersRequest {
  /// Returns a new [QueryMembersRequest] instance.
  QueryMembersRequest({
    this.filterConditions = const {},
    required this.id,
    this.limit,
    this.next,
    this.prev,
    this.sort = const [],
    required this.type,
  });

  Map<String, Object> filterConditions;

  String id;

  /// Minimum value: 0
  /// Maximum value: 25
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? limit;

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

  List<SortParamRequest> sort;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QueryMembersRequest &&
     other.filterConditions == filterConditions &&
     other.id == id &&
     other.limit == limit &&
     other.next == next &&
     other.prev == prev &&
     other.sort == sort &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (filterConditions.hashCode) +
    (id.hashCode) +
    (limit == null ? 0 : limit!.hashCode) +
    (next == null ? 0 : next!.hashCode) +
    (prev == null ? 0 : prev!.hashCode) +
    (sort.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'QueryMembersRequest[filterConditions=$filterConditions, id=$id, limit=$limit, next=$next, prev=$prev, sort=$sort, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'filter_conditions'] = this.filterConditions;
      json[r'id'] = this.id;
    if (this.limit != null) {
      json[r'limit'] = this.limit;
    } else {
      json[r'limit'] = null;
    }
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
      json[r'sort'] = this.sort;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [QueryMembersRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryMembersRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "QueryMembersRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "QueryMembersRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryMembersRequest(
        filterConditions: mapCastOfType<String, Object>(json, r'filter_conditions') ?? const {},
        id: mapValueOfType<String>(json, r'id')!,
        limit: mapValueOfType<int>(json, r'limit'),
        next: mapValueOfType<String>(json, r'next'),
        prev: mapValueOfType<String>(json, r'prev'),
        sort: SortParamRequest.listFromJson(json[r'sort']),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<QueryMembersRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QueryMembersRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryMembersRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryMembersRequest> mapFromJson(dynamic json) {
    final map = <String, QueryMembersRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryMembersRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryMembersRequest-objects as value to a dart map
  static Map<String, List<QueryMembersRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QueryMembersRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryMembersRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'type',
  };
}

