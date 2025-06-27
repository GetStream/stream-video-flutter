//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CountByMinuteResponse {
  /// Returns a new [CountByMinuteResponse] instance.
  CountByMinuteResponse({
    required this.count,
    required this.startTs,
  });

  int count;

  DateTime startTs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountByMinuteResponse &&
          other.count == count &&
          other.startTs == startTs;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (count.hashCode) + (startTs.hashCode);

  @override
  String toString() => 'CountByMinuteResponse[count=$count, startTs=$startTs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'count'] = this.count;
    json[r'start_ts'] = this.startTs.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [CountByMinuteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CountByMinuteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "CountByMinuteResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "CountByMinuteResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CountByMinuteResponse(
        count: mapValueOfType<int>(json, r'count')!,
        startTs: mapDateTime(json, r'start_ts', r'')!,
      );
    }
    return null;
  }

  static List<CountByMinuteResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CountByMinuteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CountByMinuteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CountByMinuteResponse> mapFromJson(dynamic json) {
    final map = <String, CountByMinuteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CountByMinuteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CountByMinuteResponse-objects as value to a dart map
  static Map<String, List<CountByMinuteResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CountByMinuteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CountByMinuteResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'count',
    'start_ts',
  };
}
