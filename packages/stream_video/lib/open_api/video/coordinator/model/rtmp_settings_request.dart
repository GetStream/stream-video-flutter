//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RTMPSettingsRequest {
  /// Returns a new [RTMPSettingsRequest] instance.
  RTMPSettingsRequest({
    this.enabled,
    this.quality,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enabled;

  /// Resolution to set for the RTMP stream
  RTMPSettingsRequestQualityEnum? quality;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RTMPSettingsRequest &&
    other.enabled == enabled &&
    other.quality == quality;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (enabled == null ? 0 : enabled!.hashCode) +
    (quality == null ? 0 : quality!.hashCode);

  @override
  String toString() => 'RTMPSettingsRequest[enabled=$enabled, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.enabled != null) {
      json[r'enabled'] = this.enabled;
    } else {
      json[r'enabled'] = null;
    }
    if (this.quality != null) {
      json[r'quality'] = this.quality;
    } else {
      json[r'quality'] = null;
    }
    return json;
  }

  /// Returns a new [RTMPSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RTMPSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RTMPSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RTMPSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RTMPSettingsRequest(
        enabled: mapValueOfType<bool>(json, r'enabled'),
        quality: RTMPSettingsRequestQualityEnum.fromJson(json[r'quality']),
      );
    }
    return null;
  }

  static List<RTMPSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RTMPSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RTMPSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RTMPSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, RTMPSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RTMPSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RTMPSettingsRequest-objects as value to a dart map
  static Map<String, List<RTMPSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RTMPSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RTMPSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

/// Resolution to set for the RTMP stream
class RTMPSettingsRequestQualityEnum {
  /// Instantiate a new enum with the provided [value].
  const RTMPSettingsRequestQualityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const n360p = RTMPSettingsRequestQualityEnum._(r'360p');
  static const n480p = RTMPSettingsRequestQualityEnum._(r'480p');
  static const n720p = RTMPSettingsRequestQualityEnum._(r'720p');
  static const n1080p = RTMPSettingsRequestQualityEnum._(r'1080p');
  static const n1440p = RTMPSettingsRequestQualityEnum._(r'1440p');
  static const portrait360x640 = RTMPSettingsRequestQualityEnum._(r'portrait-360x640');
  static const portrait480x854 = RTMPSettingsRequestQualityEnum._(r'portrait-480x854');
  static const portrait720x1280 = RTMPSettingsRequestQualityEnum._(r'portrait-720x1280');
  static const portrait1080x1920 = RTMPSettingsRequestQualityEnum._(r'portrait-1080x1920');
  static const portrait1440x2560 = RTMPSettingsRequestQualityEnum._(r'portrait-1440x2560');

  /// List of all possible values in this [enum][RTMPSettingsRequestQualityEnum].
  static const values = <RTMPSettingsRequestQualityEnum>[
    n360p,
    n480p,
    n720p,
    n1080p,
    n1440p,
    portrait360x640,
    portrait480x854,
    portrait720x1280,
    portrait1080x1920,
    portrait1440x2560,
  ];

  static RTMPSettingsRequestQualityEnum? fromJson(dynamic value) => RTMPSettingsRequestQualityEnumTypeTransformer().decode(value);

  static List<RTMPSettingsRequestQualityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RTMPSettingsRequestQualityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RTMPSettingsRequestQualityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RTMPSettingsRequestQualityEnum] to String,
/// and [decode] dynamic data back to [RTMPSettingsRequestQualityEnum].
class RTMPSettingsRequestQualityEnumTypeTransformer {
  factory RTMPSettingsRequestQualityEnumTypeTransformer() => _instance ??= const RTMPSettingsRequestQualityEnumTypeTransformer._();

  const RTMPSettingsRequestQualityEnumTypeTransformer._();

  String encode(RTMPSettingsRequestQualityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RTMPSettingsRequestQualityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RTMPSettingsRequestQualityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'360p': return RTMPSettingsRequestQualityEnum.n360p;
        case r'480p': return RTMPSettingsRequestQualityEnum.n480p;
        case r'720p': return RTMPSettingsRequestQualityEnum.n720p;
        case r'1080p': return RTMPSettingsRequestQualityEnum.n1080p;
        case r'1440p': return RTMPSettingsRequestQualityEnum.n1440p;
        case r'portrait-360x640': return RTMPSettingsRequestQualityEnum.portrait360x640;
        case r'portrait-480x854': return RTMPSettingsRequestQualityEnum.portrait480x854;
        case r'portrait-720x1280': return RTMPSettingsRequestQualityEnum.portrait720x1280;
        case r'portrait-1080x1920': return RTMPSettingsRequestQualityEnum.portrait1080x1920;
        case r'portrait-1440x2560': return RTMPSettingsRequestQualityEnum.portrait1440x2560;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RTMPSettingsRequestQualityEnumTypeTransformer] instance.
  static RTMPSettingsRequestQualityEnumTypeTransformer? _instance;
}


