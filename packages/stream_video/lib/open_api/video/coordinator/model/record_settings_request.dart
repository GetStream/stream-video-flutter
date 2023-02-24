//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecordSettingsRequest {
  /// Returns a new [RecordSettingsRequest] instance.
  RecordSettingsRequest({
    this.audioOnly,
    this.mode,
    this.quality,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? audioOnly;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? mode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? quality;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordSettingsRequest &&
     other.audioOnly == audioOnly &&
     other.mode == mode &&
     other.quality == quality;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioOnly == null ? 0 : audioOnly!.hashCode) +
    (mode == null ? 0 : mode!.hashCode) +
    (quality == null ? 0 : quality!.hashCode);

  @override
  String toString() => 'RecordSettingsRequest[audioOnly=$audioOnly, mode=$mode, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audioOnly != null) {
      json[r'audio_only'] = this.audioOnly;
    } else {
      json[r'audio_only'] = null;
    }
    if (this.mode != null) {
      json[r'mode'] = this.mode;
    } else {
      json[r'mode'] = null;
    }
    if (this.quality != null) {
      json[r'quality'] = this.quality;
    } else {
      json[r'quality'] = null;
    }
    return json;
  }

  /// Returns a new [RecordSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecordSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecordSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecordSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecordSettingsRequest(
        audioOnly: mapValueOfType<bool>(json, r'audio_only'),
        mode: mapValueOfType<String>(json, r'mode'),
        quality: mapValueOfType<String>(json, r'quality'),
      );
    }
    return null;
  }

  static List<RecordSettingsRequest>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecordSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, RecordSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecordSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecordSettingsRequest-objects as value to a dart map
  static Map<String, List<RecordSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecordSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecordSettingsRequest.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

