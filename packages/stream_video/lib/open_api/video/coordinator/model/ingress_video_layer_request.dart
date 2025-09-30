//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressVideoLayerRequest {
  /// Returns a new [IngressVideoLayerRequest] instance.
  IngressVideoLayerRequest({
    required this.bitrate,
    required this.codec,
    required this.frameRateLimit,
    required this.maxDimension,
    required this.minDimension,
  });

  /// Minimum value: 1000
  int bitrate;

  IngressVideoLayerRequestCodecEnum codec;

  /// Minimum value: 1
  /// Maximum value: 60
  int frameRateLimit;

  /// Minimum value: 240
  int maxDimension;

  /// Minimum value: 240
  int minDimension;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressVideoLayerRequest &&
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
      'IngressVideoLayerRequest[bitrate=$bitrate, codec=$codec, frameRateLimit=$frameRateLimit, maxDimension=$maxDimension, minDimension=$minDimension]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'bitrate'] = this.bitrate;
    json[r'codec'] = this.codec;
    json[r'frame_rate_limit'] = this.frameRateLimit;
    json[r'max_dimension'] = this.maxDimension;
    json[r'min_dimension'] = this.minDimension;
    return json;
  }

  /// Returns a new [IngressVideoLayerRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressVideoLayerRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IngressVideoLayerRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IngressVideoLayerRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngressVideoLayerRequest(
        bitrate: mapValueOfType<int>(json, r'bitrate')!,
        codec: IngressVideoLayerRequestCodecEnum.fromJson(json[r'codec'])!,
        frameRateLimit: mapValueOfType<int>(json, r'frame_rate_limit')!,
        maxDimension: mapValueOfType<int>(json, r'max_dimension')!,
        minDimension: mapValueOfType<int>(json, r'min_dimension')!,
      );
    }
    return null;
  }

  static List<IngressVideoLayerRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressVideoLayerRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressVideoLayerRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressVideoLayerRequest> mapFromJson(dynamic json) {
    final map = <String, IngressVideoLayerRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressVideoLayerRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressVideoLayerRequest-objects as value to a dart map
  static Map<String, List<IngressVideoLayerRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressVideoLayerRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressVideoLayerRequest.listFromJson(
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

class IngressVideoLayerRequestCodecEnum {
  /// Instantiate a new enum with the provided [value].
  const IngressVideoLayerRequestCodecEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const h264 = IngressVideoLayerRequestCodecEnum._(r'h264');
  static const vp8 = IngressVideoLayerRequestCodecEnum._(r'vp8');

  /// List of all possible values in this [enum][IngressVideoLayerRequestCodecEnum].
  static const values = <IngressVideoLayerRequestCodecEnum>[
    h264,
    vp8,
  ];

  static IngressVideoLayerRequestCodecEnum? fromJson(dynamic value) =>
      IngressVideoLayerRequestCodecEnumTypeTransformer().decode(value);

  static List<IngressVideoLayerRequestCodecEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressVideoLayerRequestCodecEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressVideoLayerRequestCodecEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [IngressVideoLayerRequestCodecEnum] to String,
/// and [decode] dynamic data back to [IngressVideoLayerRequestCodecEnum].
class IngressVideoLayerRequestCodecEnumTypeTransformer {
  factory IngressVideoLayerRequestCodecEnumTypeTransformer() =>
      _instance ??= const IngressVideoLayerRequestCodecEnumTypeTransformer._();

  const IngressVideoLayerRequestCodecEnumTypeTransformer._();

  String encode(IngressVideoLayerRequestCodecEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a IngressVideoLayerRequestCodecEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  IngressVideoLayerRequestCodecEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'h264':
          return IngressVideoLayerRequestCodecEnum.h264;
        case r'vp8':
          return IngressVideoLayerRequestCodecEnum.vp8;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [IngressVideoLayerRequestCodecEnumTypeTransformer] instance.
  static IngressVideoLayerRequestCodecEnumTypeTransformer? _instance;
}
