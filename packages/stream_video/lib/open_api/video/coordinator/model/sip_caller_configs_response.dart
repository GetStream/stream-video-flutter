//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SIPCallerConfigsResponse {
  /// Returns a new [SIPCallerConfigsResponse] instance.
  SIPCallerConfigsResponse({
    this.customData = const {},
    required this.id,
  });

  /// Custom data associated with the caller
  Map<String, Object> customData;

  /// Unique identifier for the caller
  String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SIPCallerConfigsResponse &&
          _deepEquality.equals(other.customData, customData) &&
          other.id == id;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (customData.hashCode) + (id.hashCode);

  @override
  String toString() =>
      'SIPCallerConfigsResponse[customData=$customData, id=$id]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'custom_data'] = this.customData;
    json[r'id'] = this.id;
    return json;
  }

  /// Returns a new [SIPCallerConfigsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SIPCallerConfigsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'custom_data'),
            'Required key "SIPCallerConfigsResponse[custom_data]" is missing from JSON.');
        assert(json[r'custom_data'] != null,
            'Required key "SIPCallerConfigsResponse[custom_data]" has a null value in JSON.');
        assert(json.containsKey(r'id'),
            'Required key "SIPCallerConfigsResponse[id]" is missing from JSON.');
        assert(json[r'id'] != null,
            'Required key "SIPCallerConfigsResponse[id]" has a null value in JSON.');
        return true;
      }());

      return SIPCallerConfigsResponse(
        customData: mapCastOfType<String, Object>(json, r'custom_data')!,
        id: mapValueOfType<String>(json, r'id')!,
      );
    }
    return null;
  }

  static List<SIPCallerConfigsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <SIPCallerConfigsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SIPCallerConfigsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SIPCallerConfigsResponse> mapFromJson(dynamic json) {
    final map = <String, SIPCallerConfigsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SIPCallerConfigsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SIPCallerConfigsResponse-objects as value to a dart map
  static Map<String, List<SIPCallerConfigsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<SIPCallerConfigsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SIPCallerConfigsResponse.listFromJson(
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
    'id',
  };
}
