//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressVideoLayerResponse {
  /// Returns a new [IngressVideoLayerResponse] instance.
  IngressVideoLayerResponse({
    required this.bitrate,
    required this.codec,
    required this.frameRateLimit,
    required this.maxDimension,
    required this.minDimension,
  });

  int bitrate;

  String codec;

  int frameRateLimit;

  int maxDimension;

  int minDimension;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressVideoLayerResponse &&
          other.bitrate == bitrate &&
          other.codec == codec &&
          other.frameRateLimit == frameRateLimit &&
          other.maxDimension == maxDimension &&
          other.minDimension == minDimension;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (bitrate.hashCode) +
      (codec.hashCode) +
      (frameRateLimit.hashCode) +
      (maxDimension.hashCode) +
      (minDimension.hashCode);

  @override
  String toString() =>
      'IngressVideoLayerResponse[bitrate=$bitrate, codec=$codec, frameRateLimit=$frameRateLimit, maxDimension=$maxDimension, minDimension=$minDimension]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'bitrate'] = this.bitrate;
    json[r'codec'] = this.codec;
    json[r'frame_rate_limit'] = this.frameRateLimit;
    json[r'max_dimension'] = this.maxDimension;
    json[r'min_dimension'] = this.minDimension;
    return json;
  }

  /// Returns a new [IngressVideoLayerResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressVideoLayerResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IngressVideoLayerResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IngressVideoLayerResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngressVideoLayerResponse(
        bitrate: mapValueOfType<int>(json, r'bitrate')!,
        codec: mapValueOfType<String>(json, r'codec')!,
        frameRateLimit: mapValueOfType<int>(json, r'frame_rate_limit')!,
        maxDimension: mapValueOfType<int>(json, r'max_dimension')!,
        minDimension: mapValueOfType<int>(json, r'min_dimension')!,
      );
    }
    return null;
  }

  static List<IngressVideoLayerResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressVideoLayerResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressVideoLayerResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressVideoLayerResponse> mapFromJson(dynamic json) {
    final map = <String, IngressVideoLayerResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressVideoLayerResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressVideoLayerResponse-objects as value to a dart map
  static Map<String, List<IngressVideoLayerResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressVideoLayerResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressVideoLayerResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'bitrate',
    'codec',
    'frame_rate_limit',
    'max_dimension',
    'min_dimension',
  };
}
