//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallClosedCaption {
  /// Returns a new [CallClosedCaption] instance.
  CallClosedCaption({
    required this.endTime,
    required this.speakerId,
    required this.startTime,
    required this.text,
  });

  DateTime endTime;

  String speakerId;

  DateTime startTime;

  String text;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallClosedCaption &&
    other.endTime == endTime &&
    other.speakerId == speakerId &&
    other.startTime == startTime &&
    other.text == text;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (endTime.hashCode) +
    (speakerId.hashCode) +
    (startTime.hashCode) +
    (text.hashCode);

  @override
  String toString() => 'CallClosedCaption[endTime=$endTime, speakerId=$speakerId, startTime=$startTime, text=$text]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'end_time'] = this.endTime.toUtc().toIso8601String();
      json[r'speaker_id'] = this.speakerId;
      json[r'start_time'] = this.startTime.toUtc().toIso8601String();
      json[r'text'] = this.text;
    return json;
  }

  /// Returns a new [CallClosedCaption] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallClosedCaption? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallClosedCaption[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallClosedCaption[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallClosedCaption(
        endTime: mapDateTime(json, r'end_time', r'')!,
        speakerId: mapValueOfType<String>(json, r'speaker_id')!,
        startTime: mapDateTime(json, r'start_time', r'')!,
        text: mapValueOfType<String>(json, r'text')!,
      );
    }
    return null;
  }

  static List<CallClosedCaption> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallClosedCaption>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallClosedCaption.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallClosedCaption> mapFromJson(dynamic json) {
    final map = <String, CallClosedCaption>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallClosedCaption.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallClosedCaption-objects as value to a dart map
  static Map<String, List<CallClosedCaption>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallClosedCaption>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallClosedCaption.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'end_time',
    'speaker_id',
    'start_time',
    'text',
  };
}

