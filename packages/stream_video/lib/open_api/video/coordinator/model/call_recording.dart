//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallRecording {
  /// Returns a new [CallRecording] instance.
  CallRecording({
    required this.endTime,
    required this.filename,
    required this.startTime,
    required this.url,
  });

  DateTime endTime;

  String filename;

  DateTime startTime;

  String url;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallRecording &&
     other.endTime == endTime &&
     other.filename == filename &&
     other.startTime == startTime &&
     other.url == url;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (endTime.hashCode) +
    (filename.hashCode) +
    (startTime.hashCode) +
    (url.hashCode);

  @override
  String toString() => 'CallRecording[endTime=$endTime, filename=$filename, startTime=$startTime, url=$url]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'end_time'] = this.endTime.toUtc().toIso8601String();
      json[r'filename'] = this.filename;
      json[r'start_time'] = this.startTime.toUtc().toIso8601String();
      json[r'url'] = this.url;
    return json;
  }

  /// Returns a new [CallRecording] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallRecording? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallRecording[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallRecording[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallRecording(
        endTime: mapDateTime(json, r'end_time', '')!,
        filename: mapValueOfType<String>(json, r'filename')!,
        startTime: mapDateTime(json, r'start_time', '')!,
        url: mapValueOfType<String>(json, r'url')!,
      );
    }
    return null;
  }

  static List<CallRecording> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallRecording>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallRecording.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallRecording> mapFromJson(dynamic json) {
    final map = <String, CallRecording>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallRecording.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallRecording-objects as value to a dart map
  static Map<String, List<CallRecording>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallRecording>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallRecording.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'end_time',
    'filename',
    'start_time',
    'url',
  };
}

