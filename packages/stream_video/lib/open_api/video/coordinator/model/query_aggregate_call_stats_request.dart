//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class QueryAggregateCallStatsRequest {
  /// Returns a new [QueryAggregateCallStatsRequest] instance.
  QueryAggregateCallStatsRequest({
    this.from,
    this.reportTypes = const [],
    this.to,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? from;

  List<String> reportTypes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? to;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryAggregateCallStatsRequest &&
          other.from == from &&
          _deepEquality.equals(other.reportTypes, reportTypes) &&
          other.to == to;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (from == null ? 0 : from!.hashCode) +
      (reportTypes.hashCode) +
      (to == null ? 0 : to!.hashCode);

  @override
  String toString() =>
      'QueryAggregateCallStatsRequest[from=$from, reportTypes=$reportTypes, to=$to]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.from != null) {
      json[r'from'] = this.from;
    } else {
      json[r'from'] = null;
    }
    json[r'report_types'] = this.reportTypes;
    if (this.to != null) {
      json[r'to'] = this.to;
    } else {
      json[r'to'] = null;
    }
    return json;
  }

  /// Returns a new [QueryAggregateCallStatsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static QueryAggregateCallStatsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "QueryAggregateCallStatsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "QueryAggregateCallStatsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return QueryAggregateCallStatsRequest(
        from: mapValueOfType<String>(json, r'from'),
        reportTypes: json[r'report_types'] is Iterable
            ? (json[r'report_types'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        to: mapValueOfType<String>(json, r'to'),
      );
    }
    return null;
  }

  static List<QueryAggregateCallStatsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <QueryAggregateCallStatsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = QueryAggregateCallStatsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, QueryAggregateCallStatsRequest> mapFromJson(dynamic json) {
    final map = <String, QueryAggregateCallStatsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = QueryAggregateCallStatsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of QueryAggregateCallStatsRequest-objects as value to a dart map
  static Map<String, List<QueryAggregateCallStatsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<QueryAggregateCallStatsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = QueryAggregateCallStatsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
