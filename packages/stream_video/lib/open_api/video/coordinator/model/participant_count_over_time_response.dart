//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantCountOverTimeResponse {
  /// Returns a new [ParticipantCountOverTimeResponse] instance.
  ParticipantCountOverTimeResponse({
    this.byMinute = const [],
  });

  List<ParticipantCountByMinuteResponse> byMinute;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantCountOverTimeResponse &&
          _deepEquality.equals(other.byMinute, byMinute);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (byMinute.hashCode);

  @override
  String toString() => 'ParticipantCountOverTimeResponse[byMinute=$byMinute]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'by_minute'] = this.byMinute;
    return json;
  }

  /// Returns a new [ParticipantCountOverTimeResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantCountOverTimeResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ParticipantCountOverTimeResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ParticipantCountOverTimeResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ParticipantCountOverTimeResponse(
        byMinute:
            ParticipantCountByMinuteResponse.listFromJson(json[r'by_minute']),
      );
    }
    return null;
  }

  static List<ParticipantCountOverTimeResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantCountOverTimeResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantCountOverTimeResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantCountOverTimeResponse> mapFromJson(
      dynamic json) {
    final map = <String, ParticipantCountOverTimeResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantCountOverTimeResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantCountOverTimeResponse-objects as value to a dart map
  static Map<String, List<ParticipantCountOverTimeResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantCountOverTimeResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantCountOverTimeResponse.listFromJson(
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
