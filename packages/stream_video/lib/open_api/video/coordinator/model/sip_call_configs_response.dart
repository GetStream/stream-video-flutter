//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPCallConfigsResponse {
  /// Returns a new [SIPCallConfigsResponse] instance.
  SIPCallConfigsResponse({
    this.customData = const {},
  });

  /// Custom data associated with the call
  Map<String, Object> customData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPCallConfigsResponse &&
          _deepEquality.equals(other.customData, customData);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (customData.hashCode);

  @override
  String toString() => 'SIPCallConfigsResponse[customData=$customData]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'custom_data'] = this.customData;
    return json;
  }

  /// Returns a new [SIPCallConfigsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPCallConfigsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'custom_data'),
            'Required key "SIPCallConfigsResponse[custom_data]" is missing from JSON.');
        assert(json[r'custom_data'] != null,
            'Required key "SIPCallConfigsResponse[custom_data]" has a null value in JSON.');
        return true;
      }());

      return SIPCallConfigsResponse(
        customData: mapCastOfType<String, Object>(json, r'custom_data')!,
      );
    }
    return null;
  }

  static List<SIPCallConfigsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPCallConfigsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPCallConfigsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPCallConfigsResponse> mapFromJson(dynamic json) {
    final map = <String, SIPCallConfigsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SIPCallConfigsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPCallConfigsResponse-objects as value to a dart map
  static Map<String, List<SIPCallConfigsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPCallConfigsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPCallConfigsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'custom_data',
  };
}
