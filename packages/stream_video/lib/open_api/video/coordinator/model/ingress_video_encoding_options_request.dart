//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressVideoEncodingOptionsRequest {
  /// Returns a new [IngressVideoEncodingOptionsRequest] instance.
  IngressVideoEncodingOptionsRequest({
    this.layers = const [],
    required this.source_,
  });

  List<IngressVideoLayerRequest> layers;

  IngressSourceRequest source_;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressVideoEncodingOptionsRequest &&
          _deepEquality.equals(other.layers, layers) &&
          other.source_ == source_;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (layers.hashCode) + (source_.hashCode);

  @override
  String toString() =>
      'IngressVideoEncodingOptionsRequest[layers=$layers, source_=$source_]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'layers'] = this.layers;
    json[r'source'] = this.source_;
    return json;
  }

  /// Returns a new [IngressVideoEncodingOptionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressVideoEncodingOptionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'layers'),
            'Required key "IngressVideoEncodingOptionsRequest[layers]" is missing from JSON.');
        assert(json[r'layers'] != null,
            'Required key "IngressVideoEncodingOptionsRequest[layers]" has a null value in JSON.');
        assert(json.containsKey(r'source'),
            'Required key "IngressVideoEncodingOptionsRequest[source]" is missing from JSON.');
        assert(json[r'source'] != null,
            'Required key "IngressVideoEncodingOptionsRequest[source]" has a null value in JSON.');
        return true;
      }());

      return IngressVideoEncodingOptionsRequest(
        layers: IngressVideoLayerRequest.listFromJson(json[r'layers']),
        source_: IngressSourceRequest.fromJson(json[r'source'])!,
      );
    }
    return null;
  }

  static List<IngressVideoEncodingOptionsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressVideoEncodingOptionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressVideoEncodingOptionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressVideoEncodingOptionsRequest> mapFromJson(
      dynamic json) {
    final map = <String, IngressVideoEncodingOptionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressVideoEncodingOptionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressVideoEncodingOptionsRequest-objects as value to a dart map
  static Map<String, List<IngressVideoEncodingOptionsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressVideoEncodingOptionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressVideoEncodingOptionsRequest.listFromJson(
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
