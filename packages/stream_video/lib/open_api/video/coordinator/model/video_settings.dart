//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoSettings {
  /// Returns a new [VideoSettings] instance.
  VideoSettings({
    required this.accessRequestEnabled,
    required this.enabled,
  });

  bool accessRequestEnabled;

  bool enabled;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoSettings &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.enabled == enabled;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (enabled.hashCode);

  @override
  String toString() => 'VideoSettings[accessRequestEnabled=$accessRequestEnabled, enabled=$enabled]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'enabled'] = this.enabled;
    return json;
  }

  /// Returns a new [VideoSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoSettings(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
      );
    }
    return null;
  }

  static List<VideoSettings>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoSettings> mapFromJson(dynamic json) {
    final map = <String, VideoSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoSettings-objects as value to a dart map
  static Map<String, List<VideoSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoSettings>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoSettings.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_request_enabled',
    'enabled',
  };
}

