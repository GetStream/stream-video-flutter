//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallsRequest {
  /// Returns a new [QueryCallsRequest] instance.
  QueryCallsRequest({
    this.filterConditions = const {},
    this.limit,
    this.next,
    this.prev,
    this.sort = const [],
    this.watch,
  });

  Map<String, Object> filterConditions;

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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? watch;

  @override
  bool operator ==(Object other) => identical(this, other) || other is QueryCallsRequest &&
     other.filterConditions == filterConditions &&
     other.limit == limit &&
     other.next == next &&
     other.prev == prev &&
     other.sort == sort &&
     other.watch == watch;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (filterConditions.hashCode) +
    (limit == null ? 0 : limit!.hashCode) +
    (next == null ? 0 : next!.hashCode) +
    (prev == null ? 0 : prev!.hashCode) +
    (sort.hashCode) +
    (watch == null ? 0 : watch!.hashCode);

  @override
  String toString() => 'QueryCallsRequest[filterConditions=$filterConditions, limit=$limit, next=$next, prev=$prev, sort=$sort, watch=$watch]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'filter_conditions'] = this.filterConditions;
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
    if (this.watch != null) {
      json[r'watch'] = this.watch;
    } else {
      json[r'watch'] = null;
    }
    return json;
  }

  /// Returns a new [QueryCallsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "QueryCallsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "QueryCallsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryCallsRequest(
        filterConditions: mapCastOfType<String, Object>(json, r'filter_conditions') ?? const {},
        limit: mapValueOfType<int>(json, r'limit'),
        next: mapValueOfType<String>(json, r'next'),
        prev: mapValueOfType<String>(json, r'prev'),
        sort: SortParamRequest.listFromJson(json[r'sort']),
        watch: mapValueOfType<bool>(json, r'watch'),
      );
    }
    return null;
  }

  static List<QueryCallsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QueryCallsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallsRequest> mapFromJson(dynamic json) {
    final map = <String, QueryCallsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryCallsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallsRequest-objects as value to a dart map
  static Map<String, List<QueryCallsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QueryCallsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

