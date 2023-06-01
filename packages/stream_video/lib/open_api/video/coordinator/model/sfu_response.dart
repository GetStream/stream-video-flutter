//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SFUResponse {
  /// Returns a new [SFUResponse] instance.
  SFUResponse({
    required this.edgeName,
    required this.url,
    required this.wsEndpoint,
  });

  String edgeName;

  String url;

  String wsEndpoint;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SFUResponse &&
     other.edgeName == edgeName &&
     other.url == url &&
     other.wsEndpoint == wsEndpoint;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (edgeName.hashCode) +
    (url.hashCode) +
    (wsEndpoint.hashCode);

  @override
  String toString() => 'SFUResponse[edgeName=$edgeName, url=$url, wsEndpoint=$wsEndpoint]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'edge_name'] = this.edgeName;
      json[r'url'] = this.url;
      json[r'ws_endpoint'] = this.wsEndpoint;
    return json;
  }

  /// Returns a new [SFUResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SFUResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SFUResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SFUResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SFUResponse(
        edgeName: mapValueOfType<String>(json, r'edge_name')!,
        url: mapValueOfType<String>(json, r'url')!,
        wsEndpoint: mapValueOfType<String>(json, r'ws_endpoint')!,
      );
    }
    return null;
  }

  static List<SFUResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SFUResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SFUResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SFUResponse> mapFromJson(dynamic json) {
    final map = <String, SFUResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SFUResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SFUResponse-objects as value to a dart map
  static Map<String, List<SFUResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SFUResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SFUResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'edge_name',
    'url',
    'ws_endpoint',
  };
}

