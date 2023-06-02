//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AudioSettings {
  /// Returns a new [AudioSettings] instance.
  AudioSettings({
    required this.accessRequestEnabled,
    required this.micDefaultOn,
    required this.opusDtxEnabled,
    required this.redundantCodingEnabled,
    required this.speakerDefaultOn,
  });

  bool accessRequestEnabled;

  bool micDefaultOn;

  bool opusDtxEnabled;

  bool redundantCodingEnabled;

  bool speakerDefaultOn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AudioSettings &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.micDefaultOn == micDefaultOn &&
     other.opusDtxEnabled == opusDtxEnabled &&
     other.redundantCodingEnabled == redundantCodingEnabled &&
     other.speakerDefaultOn == speakerDefaultOn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (micDefaultOn.hashCode) +
    (opusDtxEnabled.hashCode) +
    (redundantCodingEnabled.hashCode) +
    (speakerDefaultOn.hashCode);

  @override
  String toString() => 'AudioSettings[accessRequestEnabled=$accessRequestEnabled, micDefaultOn=$micDefaultOn, opusDtxEnabled=$opusDtxEnabled, redundantCodingEnabled=$redundantCodingEnabled, speakerDefaultOn=$speakerDefaultOn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'mic_default_on'] = this.micDefaultOn;
      json[r'opus_dtx_enabled'] = this.opusDtxEnabled;
      json[r'redundant_coding_enabled'] = this.redundantCodingEnabled;
      json[r'speaker_default_on'] = this.speakerDefaultOn;
    return json;
  }

  /// Returns a new [AudioSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AudioSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AudioSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AudioSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AudioSettings(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        micDefaultOn: mapValueOfType<bool>(json, r'mic_default_on')!,
        opusDtxEnabled: mapValueOfType<bool>(json, r'opus_dtx_enabled')!,
        redundantCodingEnabled: mapValueOfType<bool>(json, r'redundant_coding_enabled')!,
        speakerDefaultOn: mapValueOfType<bool>(json, r'speaker_default_on')!,
      );
    }
    return null;
  }

  static List<AudioSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AudioSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AudioSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AudioSettings> mapFromJson(dynamic json) {
    final map = <String, AudioSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AudioSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AudioSettings-objects as value to a dart map
  static Map<String, List<AudioSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AudioSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AudioSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_request_enabled',
    'mic_default_on',
    'opus_dtx_enabled',
    'redundant_coding_enabled',
    'speaker_default_on',
  };
}

