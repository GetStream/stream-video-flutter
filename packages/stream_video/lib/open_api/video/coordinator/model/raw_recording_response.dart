//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RawRecordingResponse {
  /// Returns a new [RawRecordingResponse] instance.
  RawRecordingResponse({
    required this.status,
  });

  String status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawRecordingResponse && other.status == status;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (status.hashCode);

  @override
  String toString() => 'RawRecordingResponse[status=$status]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'status'] = this.status;
    return json;
  }

  /// Returns a new [RawRecordingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RawRecordingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'status'),
            'Required key "RawRecordingResponse[status]" is missing from JSON.');
        assert(json[r'status'] != null,
            'Required key "RawRecordingResponse[status]" has a null value in JSON.');
        return true;
      }());

      return RawRecordingResponse(
        status: mapValueOfType<String>(json, r'status')!,
      );
    }
    return null;
  }

  static List<RawRecordingResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RawRecordingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RawRecordingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RawRecordingResponse> mapFromJson(dynamic json) {
    final map = <String, RawRecordingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RawRecordingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RawRecordingResponse-objects as value to a dart map
  static Map<String, List<RawRecordingResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<RawRecordingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RawRecordingResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'status',
  };
}
