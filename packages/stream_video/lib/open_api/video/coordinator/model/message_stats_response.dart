//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MessageStatsResponse {
  /// Returns a new [MessageStatsResponse] instance.
  MessageStatsResponse({
    this.countOverTime = const [],
  });

  List<CountByMinuteResponse> countOverTime;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatsResponse &&
          _deepEquality.equals(other.countOverTime, countOverTime);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (countOverTime.hashCode);

  @override
  String toString() => 'MessageStatsResponse[countOverTime=$countOverTime]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'count_over_time'] = this.countOverTime;
    return json;
  }

  /// Returns a new [MessageStatsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MessageStatsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "MessageStatsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "MessageStatsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MessageStatsResponse(
        countOverTime:
            CountByMinuteResponse.listFromJson(json[r'count_over_time']),
      );
    }
    return null;
  }

  static List<MessageStatsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <MessageStatsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MessageStatsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MessageStatsResponse> mapFromJson(dynamic json) {
    final map = <String, MessageStatsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MessageStatsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MessageStatsResponse-objects as value to a dart map
  static Map<String, List<MessageStatsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<MessageStatsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MessageStatsResponse.listFromJson(
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
