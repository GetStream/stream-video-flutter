//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BroadcastSettingsResponse {
  /// Returns a new [BroadcastSettingsResponse] instance.
  BroadcastSettingsResponse({
    required this.enabled,
    required this.hls,
    required this.rtmp,
  });

  bool enabled;

  HLSSettingsResponse hls;

  RTMPSettingsResponse rtmp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BroadcastSettingsResponse &&
    other.enabled == enabled &&
    other.hls == hls &&
    other.rtmp == rtmp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (hls.hashCode) +
    (rtmp.hashCode);

  @override
  String toString() => 'BroadcastSettingsResponse[enabled=$enabled, hls=$hls, rtmp=$rtmp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
      json[r'hls'] = this.hls;
      json[r'rtmp'] = this.rtmp;
    return json;
  }

  /// Returns a new [BroadcastSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BroadcastSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BroadcastSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BroadcastSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BroadcastSettingsResponse(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        hls: HLSSettingsResponse.fromJson(json[r'hls'])!,
        rtmp: RTMPSettingsResponse.fromJson(json[r'rtmp'])!,
      );
    }
    return null;
  }

  static List<BroadcastSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BroadcastSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BroadcastSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BroadcastSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, BroadcastSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BroadcastSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BroadcastSettingsResponse-objects as value to a dart map
  static Map<String, List<BroadcastSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BroadcastSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BroadcastSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
    'hls',
    'rtmp',
  };
}

