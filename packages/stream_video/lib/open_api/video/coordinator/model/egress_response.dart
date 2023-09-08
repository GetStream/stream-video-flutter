//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EgressResponse {
  /// Returns a new [EgressResponse] instance.
  EgressResponse({
    required this.broadcasting,
    this.hls,
    this.rtmps = const [],
  });

  bool broadcasting;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  EgressHLSResponse? hls;

  List<EgressRTMPResponse> rtmps;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EgressResponse &&
     other.broadcasting == broadcasting &&
     other.hls == hls &&
     other.rtmps == rtmps;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (broadcasting.hashCode) +
    (hls == null ? 0 : hls!.hashCode) +
    (rtmps.hashCode);

  @override
  String toString() => 'EgressResponse[broadcasting=$broadcasting, hls=$hls, rtmps=$rtmps]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'broadcasting'] = this.broadcasting;
    if (this.hls != null) {
      json[r'hls'] = this.hls;
    } else {
      json[r'hls'] = null;
    }
      json[r'rtmps'] = this.rtmps;
    return json;
  }

  /// Returns a new [EgressResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EgressResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EgressResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EgressResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EgressResponse(
        broadcasting: mapValueOfType<bool>(json, r'broadcasting')!,
        hls: EgressHLSResponse.fromJson(json[r'hls']),
        rtmps: EgressRTMPResponse.listFromJson(json[r'rtmps']),
      );
    }
    return null;
  }

  static List<EgressResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EgressResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EgressResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EgressResponse> mapFromJson(dynamic json) {
    final map = <String, EgressResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EgressResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EgressResponse-objects as value to a dart map
  static Map<String, List<EgressResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EgressResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EgressResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'broadcasting',
    'rtmps',
  };
}

