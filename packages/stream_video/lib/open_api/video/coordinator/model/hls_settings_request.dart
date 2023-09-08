//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HLSSettingsRequest {
  /// Returns a new [HLSSettingsRequest] instance.
  HLSSettingsRequest({
    this.autoOn,
    this.enabled,
    this.qualityTracks = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? autoOn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enabled;

  List<String> qualityTracks;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HLSSettingsRequest &&
     other.autoOn == autoOn &&
     other.enabled == enabled &&
     other.qualityTracks == qualityTracks;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (autoOn == null ? 0 : autoOn!.hashCode) +
    (enabled == null ? 0 : enabled!.hashCode) +
    (qualityTracks.hashCode);

  @override
  String toString() => 'HLSSettingsRequest[autoOn=$autoOn, enabled=$enabled, qualityTracks=$qualityTracks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.autoOn != null) {
      json[r'auto_on'] = this.autoOn;
    } else {
      json[r'auto_on'] = null;
    }
    if (this.enabled != null) {
      json[r'enabled'] = this.enabled;
    } else {
      json[r'enabled'] = null;
    }
      json[r'quality_tracks'] = this.qualityTracks;
    return json;
  }

  /// Returns a new [HLSSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HLSSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "HLSSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "HLSSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HLSSettingsRequest(
        autoOn: mapValueOfType<bool>(json, r'auto_on'),
        enabled: mapValueOfType<bool>(json, r'enabled'),
        qualityTracks: json[r'quality_tracks'] is List
            ? (json[r'quality_tracks'] as List).cast<String>()
            : const [],
      );
    }
    return null;
  }

  static List<HLSSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HLSSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HLSSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HLSSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, HLSSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HLSSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HLSSettingsRequest-objects as value to a dart map
  static Map<String, List<HLSSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<HLSSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HLSSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

