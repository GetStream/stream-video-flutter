//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryCallStatsRequest {
  /// Returns a new [QueryCallStatsRequest] instance.
  QueryCallStatsRequest({
    this.filterConditions = const {},
    this.limit,
    this.next,
    this.prev,
    this.sort = const [],
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

  @override
  bool operator ==(Object other) => identical(this, other) || other is QueryCallStatsRequest &&
    _deepEquality.equals(other.filterConditions, filterConditions) &&
    other.limit == limit &&
    other.next == next &&
    other.prev == prev &&
    _deepEquality.equals(other.sort, sort);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (filterConditions.hashCode) +
    (limit == null ? 0 : limit!.hashCode) +
    (next == null ? 0 : next!.hashCode) +
    (prev == null ? 0 : prev!.hashCode) +
    (sort.hashCode);

  @override
  String toString() => 'QueryCallStatsRequest[filterConditions=$filterConditions, limit=$limit, next=$next, prev=$prev, sort=$sort]';

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
    return json;
  }

  /// Returns a new [QueryCallStatsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryCallStatsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "QueryCallStatsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "QueryCallStatsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryCallStatsRequest(
        filterConditions: mapCastOfType<String, Object>(json, r'filter_conditions') ?? const {},
        limit: mapValueOfType<int>(json, r'limit'),
        next: mapValueOfType<String>(json, r'next'),
        prev: mapValueOfType<String>(json, r'prev'),
        sort: SortParamRequest.listFromJson(json[r'sort']),
      );
    }
    return null;
  }

  static List<QueryCallStatsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <QueryCallStatsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryCallStatsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryCallStatsRequest> mapFromJson(dynamic json) {
    final map = <String, QueryCallStatsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryCallStatsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryCallStatsRequest-objects as value to a dart map
  static Map<String, List<QueryCallStatsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<QueryCallStatsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryCallStatsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

