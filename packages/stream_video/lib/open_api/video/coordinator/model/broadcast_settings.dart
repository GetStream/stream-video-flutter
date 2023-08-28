//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class BroadcastSettings {
  /// Returns a new [BroadcastSettings] instance.
  BroadcastSettings({
    required this.enabled,
    required this.hls,
  });

  bool enabled;

  HLSSettings hls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BroadcastSettings &&
     other.enabled == enabled &&
     other.hls == hls;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled.hashCode) +
    (hls.hashCode);

  @override
  String toString() => 'BroadcastSettings[enabled=$enabled, hls=$hls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'enabled'] = this.enabled;
      json[r'hls'] = this.hls;
    return json;
  }

  /// Returns a new [BroadcastSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static BroadcastSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "BroadcastSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "BroadcastSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return BroadcastSettings(
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        hls: HLSSettings.fromJson(json[r'hls'])!,
      );
    }
    return null;
  }

  static List<BroadcastSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <BroadcastSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = BroadcastSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, BroadcastSettings> mapFromJson(dynamic json) {
    final map = <String, BroadcastSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = BroadcastSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of BroadcastSettings-objects as value to a dart map
  static Map<String, List<BroadcastSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<BroadcastSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = BroadcastSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'enabled',
    'hls',
  };
}

