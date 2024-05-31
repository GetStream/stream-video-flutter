//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecordSettingsResponse {
  /// Returns a new [RecordSettingsResponse] instance.
  RecordSettingsResponse({
    required this.audioOnly,
    required this.mode,
    required this.quality,
  });

  bool audioOnly;

  String mode;

  String quality;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordSettingsResponse &&
    other.audioOnly == audioOnly &&
    other.mode == mode &&
    other.quality == quality;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioOnly.hashCode) +
    (mode.hashCode) +
    (quality.hashCode);

  @override
  String toString() => 'RecordSettingsResponse[audioOnly=$audioOnly, mode=$mode, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audio_only'] = this.audioOnly;
      json[r'mode'] = this.mode;
      json[r'quality'] = this.quality;
    return json;
  }

  /// Returns a new [RecordSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecordSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecordSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecordSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecordSettingsResponse(
        audioOnly: mapValueOfType<bool>(json, r'audio_only')!,
        mode: mapValueOfType<String>(json, r'mode')!,
        quality: mapValueOfType<String>(json, r'quality')!,
      );
    }
    return null;
  }

  static List<RecordSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecordSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, RecordSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecordSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecordSettingsResponse-objects as value to a dart map
  static Map<String, List<RecordSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecordSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecordSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio_only',
    'mode',
    'quality',
  };
}

