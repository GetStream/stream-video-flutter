//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantCountByMinuteResponse {
  /// Returns a new [ParticipantCountByMinuteResponse] instance.
  ParticipantCountByMinuteResponse({
    required this.first,
    required this.last,
    required this.max,
    required this.min,
    required this.startTs,
  });

  int first;

  int last;

  int max;

  int min;

  DateTime startTs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantCountByMinuteResponse &&
          other.first == first &&
          other.last == last &&
          other.max == max &&
          other.min == min &&
          other.startTs == startTs;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (first.hashCode) +
      (last.hashCode) +
      (max.hashCode) +
      (min.hashCode) +
      (startTs.hashCode);

  @override
  String toString() =>
      'ParticipantCountByMinuteResponse[first=$first, last=$last, max=$max, min=$min, startTs=$startTs]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'first'] = this.first;
    json[r'last'] = this.last;
    json[r'max'] = this.max;
    json[r'min'] = this.min;
    json[r'start_ts'] = this.startTs.toUtc().toIso8601String();
    return json;
  }

  /// Returns a new [ParticipantCountByMinuteResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantCountByMinuteResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ParticipantCountByMinuteResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ParticipantCountByMinuteResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ParticipantCountByMinuteResponse(
        first: mapValueOfType<int>(json, r'first')!,
        last: mapValueOfType<int>(json, r'last')!,
        max: mapValueOfType<int>(json, r'max')!,
        min: mapValueOfType<int>(json, r'min')!,
        startTs: mapDateTime(json, r'start_ts', r'')!,
      );
    }
    return null;
  }

  static List<ParticipantCountByMinuteResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantCountByMinuteResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantCountByMinuteResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantCountByMinuteResponse> mapFromJson(
      dynamic json) {
    final map = <String, ParticipantCountByMinuteResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantCountByMinuteResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantCountByMinuteResponse-objects as value to a dart map
  static Map<String, List<ParticipantCountByMinuteResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantCountByMinuteResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantCountByMinuteResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'first',
    'last',
    'max',
    'min',
    'start_ts',
  };
}
