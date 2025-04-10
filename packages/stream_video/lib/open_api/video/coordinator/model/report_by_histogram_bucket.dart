//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReportByHistogramBucket {
  /// Returns a new [ReportByHistogramBucket] instance.
  ReportByHistogramBucket({
    required this.category,
    required this.count,
    this.lowerBound,
    required this.sum,
    this.upperBound,
  });

  String category;

  int count;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Bound? lowerBound;

  double sum;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Bound? upperBound;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportByHistogramBucket &&
          other.category == category &&
          other.count == count &&
          other.lowerBound == lowerBound &&
          other.sum == sum &&
          other.upperBound == upperBound;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (category.hashCode) +
      (count.hashCode) +
      (lowerBound == null ? 0 : lowerBound!.hashCode) +
      (sum.hashCode) +
      (upperBound == null ? 0 : upperBound!.hashCode);

  @override
  String toString() =>
      'ReportByHistogramBucket[category=$category, count=$count, lowerBound=$lowerBound, sum=$sum, upperBound=$upperBound]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'category'] = this.category;
    json[r'count'] = this.count;
    if (this.lowerBound != null) {
      json[r'lower_bound'] = this.lowerBound;
    } else {
      json[r'lower_bound'] = null;
    }
    json[r'sum'] = this.sum;
    if (this.upperBound != null) {
      json[r'upper_bound'] = this.upperBound;
    } else {
      json[r'upper_bound'] = null;
    }
    return json;
  }

  /// Returns a new [ReportByHistogramBucket] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReportByHistogramBucket? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ReportByHistogramBucket[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ReportByHistogramBucket[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReportByHistogramBucket(
        category: mapValueOfType<String>(json, r'category')!,
        count: mapValueOfType<int>(json, r'count')!,
        lowerBound: Bound.fromJson(json[r'lower_bound']),
        sum: mapValueOfType<double>(json, r'sum')!,
        upperBound: Bound.fromJson(json[r'upper_bound']),
      );
    }
    return null;
  }

  static List<ReportByHistogramBucket> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ReportByHistogramBucket>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReportByHistogramBucket.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReportByHistogramBucket> mapFromJson(dynamic json) {
    final map = <String, ReportByHistogramBucket>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReportByHistogramBucket.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReportByHistogramBucket-objects as value to a dart map
  static Map<String, List<ReportByHistogramBucket>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ReportByHistogramBucket>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReportByHistogramBucket.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'category',
    'count',
    'sum',
  };
}
