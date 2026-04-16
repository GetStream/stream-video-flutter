//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressSourceRequest {
  /// Returns a new [IngressSourceRequest] instance.
  IngressSourceRequest({
    required this.fps,
    required this.height,
    required this.width,
  });

  IngressSourceRequestFpsEnum fps;

  /// Minimum value: 2
  int height;

  /// Minimum value: 2
  int width;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressSourceRequest &&
          other.fps == fps &&
          other.height == height &&
          other.width == width;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (fps.hashCode) + (height.hashCode) + (width.hashCode);

  @override
  String toString() =>
      'IngressSourceRequest[fps=$fps, height=$height, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'fps'] = this.fps;
    json[r'height'] = this.height;
    json[r'width'] = this.width;
    return json;
  }

  /// Returns a new [IngressSourceRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressSourceRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fps'),
            'Required key "IngressSourceRequest[fps]" is missing from JSON.');
        assert(json[r'fps'] != null,
            'Required key "IngressSourceRequest[fps]" has a null value in JSON.');
        assert(json.containsKey(r'height'),
            'Required key "IngressSourceRequest[height]" is missing from JSON.');
        assert(json[r'height'] != null,
            'Required key "IngressSourceRequest[height]" has a null value in JSON.');
        assert(json.containsKey(r'width'),
            'Required key "IngressSourceRequest[width]" is missing from JSON.');
        assert(json[r'width'] != null,
            'Required key "IngressSourceRequest[width]" has a null value in JSON.');
        return true;
      }());

      return IngressSourceRequest(
        fps: IngressSourceRequestFpsEnum.fromJson(json[r'fps'])!,
        height: mapValueOfType<int>(json, r'height')!,
        width: mapValueOfType<int>(json, r'width')!,
      );
    }
    return null;
  }

  static List<IngressSourceRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressSourceRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressSourceRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressSourceRequest> mapFromJson(dynamic json) {
    final map = <String, IngressSourceRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressSourceRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressSourceRequest-objects as value to a dart map
  static Map<String, List<IngressSourceRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressSourceRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressSourceRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fps',
    'height',
    'width',
  };
}

class IngressSourceRequestFpsEnum {
  /// Instantiate a new enum with the provided [value].
  const IngressSourceRequestFpsEnum._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  String toString() => value.toString();

  int toJson() => value;

  static const number30 = IngressSourceRequestFpsEnum._(30);
  static const number60 = IngressSourceRequestFpsEnum._(60);

  /// List of all possible values in this [enum][IngressSourceRequestFpsEnum].
  static const values = <IngressSourceRequestFpsEnum>[
    number30,
    number60,
  ];

  static IngressSourceRequestFpsEnum? fromJson(dynamic value) =>
      IngressSourceRequestFpsEnumTypeTransformer().decode(value);

  static List<IngressSourceRequestFpsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressSourceRequestFpsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressSourceRequestFpsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [IngressSourceRequestFpsEnum] to int,
/// and [decode] dynamic data back to [IngressSourceRequestFpsEnum].
class IngressSourceRequestFpsEnumTypeTransformer {
  factory IngressSourceRequestFpsEnumTypeTransformer() =>
      _instance ??= const IngressSourceRequestFpsEnumTypeTransformer._();

  const IngressSourceRequestFpsEnumTypeTransformer._();

  int encode(IngressSourceRequestFpsEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a IngressSourceRequestFpsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  IngressSourceRequestFpsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case 30:
          return IngressSourceRequestFpsEnum.number30;
        case 60:
          return IngressSourceRequestFpsEnum.number60;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [IngressSourceRequestFpsEnumTypeTransformer] instance.
  static IngressSourceRequestFpsEnumTypeTransformer? _instance;
}
