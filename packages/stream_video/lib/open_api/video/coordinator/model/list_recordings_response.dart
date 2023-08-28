//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ListRecordingsResponse {
  /// Returns a new [ListRecordingsResponse] instance.
  ListRecordingsResponse({
    required this.duration,
    this.recordings = const [],
  });

  String duration;

  List<CallRecording> recordings;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ListRecordingsResponse &&
     other.duration == duration &&
     other.recordings == recordings;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (duration.hashCode) +
    (recordings.hashCode);

  @override
  String toString() => 'ListRecordingsResponse[duration=$duration, recordings=$recordings]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'duration'] = this.duration;
      json[r'recordings'] = this.recordings;
    return json;
  }

  /// Returns a new [ListRecordingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ListRecordingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ListRecordingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ListRecordingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ListRecordingsResponse(
        duration: mapValueOfType<String>(json, r'duration')!,
        recordings: CallRecording.listFromJson(json[r'recordings']),
      );
    }
    return null;
  }

  static List<ListRecordingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ListRecordingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ListRecordingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ListRecordingsResponse> mapFromJson(dynamic json) {
    final map = <String, ListRecordingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ListRecordingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ListRecordingsResponse-objects as value to a dart map
  static Map<String, List<ListRecordingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ListRecordingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ListRecordingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'duration',
    'recordings',
  };
}

