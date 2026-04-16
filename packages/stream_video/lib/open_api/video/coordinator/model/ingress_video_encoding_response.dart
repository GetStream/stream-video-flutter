//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressVideoEncodingResponse {
  /// Returns a new [IngressVideoEncodingResponse] instance.
  IngressVideoEncodingResponse({
    this.layers = const [],
    required this.source_,
  });

  List<IngressVideoLayerResponse> layers;

  IngressSourceResponse source_;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressVideoEncodingResponse &&
          _deepEquality.equals(other.layers, layers) &&
          other.source_ == source_;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (layers.hashCode) + (source_.hashCode);

  @override
  String toString() =>
      'IngressVideoEncodingResponse[layers=$layers, source_=$source_]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'layers'] = this.layers;
    json[r'source'] = this.source_;
    return json;
  }

  /// Returns a new [IngressVideoEncodingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressVideoEncodingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'layers'),
            'Required key "IngressVideoEncodingResponse[layers]" is missing from JSON.');
        assert(json[r'layers'] != null,
            'Required key "IngressVideoEncodingResponse[layers]" has a null value in JSON.');
        assert(json.containsKey(r'source'),
            'Required key "IngressVideoEncodingResponse[source]" is missing from JSON.');
        assert(json[r'source'] != null,
            'Required key "IngressVideoEncodingResponse[source]" has a null value in JSON.');
        return true;
      }());

      return IngressVideoEncodingResponse(
        layers: IngressVideoLayerResponse.listFromJson(json[r'layers']),
        source_: IngressSourceResponse.fromJson(json[r'source'])!,
      );
    }
    return null;
  }

  static List<IngressVideoEncodingResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressVideoEncodingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressVideoEncodingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressVideoEncodingResponse> mapFromJson(dynamic json) {
    final map = <String, IngressVideoEncodingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressVideoEncodingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressVideoEncodingResponse-objects as value to a dart map
  static Map<String, List<IngressVideoEncodingResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressVideoEncodingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressVideoEncodingResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'layers',
    'source',
  };
}
