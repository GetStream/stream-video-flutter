//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HLSSettingsRequest {
  /// Returns a new [HLSSettingsRequest] instance.
  HLSSettingsRequest({
    this.autoOn,
    this.enabled,
    this.qualityTracks = const [],
  });

  /// Whether HLS broadcasting should start automatically
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? autoOn;

  /// Whether HLS broadcasting is enabled
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enabled;

  /// Quality tracks for HLS. One of: 360p, 480p, 720p, 1080p, 1440p, portrait-360x640, portrait-480x854, portrait-720x1280, portrait-1080x1920, portrait-1440x2560
  List<HLSSettingsRequestQualityTracksEnum> qualityTracks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HLSSettingsRequest &&
          other.autoOn == autoOn &&
          other.enabled == enabled &&
          _deepEquality.equals(other.qualityTracks, qualityTracks);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (autoOn == null ? 0 : autoOn!.hashCode) +
      (enabled == null ? 0 : enabled!.hashCode) +
      (qualityTracks.hashCode);

  @override
  String toString() =>
      'HLSSettingsRequest[autoOn=$autoOn, enabled=$enabled, qualityTracks=$qualityTracks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.autoOn != null) {
      json[r'auto_on'] = this.autoOn;
    } else {
      json[r'auto_on'] = null;
    }
    if (this.enabled != null) {
      json[r'enabled'] = this.enabled;
    } else {
      json[r'enabled'] = null;
    }
    json[r'quality_tracks'] = this.qualityTracks;
    return json;
  }

  /// Returns a new [HLSSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HLSSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'quality_tracks'),
            'Required key "HLSSettingsRequest[quality_tracks]" is missing from JSON.');
        assert(json[r'quality_tracks'] != null,
            'Required key "HLSSettingsRequest[quality_tracks]" has a null value in JSON.');
        return true;
      }());

      return HLSSettingsRequest(
        autoOn: mapValueOfType<bool>(json, r'auto_on'),
        enabled: mapValueOfType<bool>(json, r'enabled'),
        qualityTracks: HLSSettingsRequestQualityTracksEnum.listFromJson(
            json[r'quality_tracks']),
      );
    }
    return null;
  }

  static List<HLSSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <HLSSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HLSSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HLSSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, HLSSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HLSSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HLSSettingsRequest-objects as value to a dart map
  static Map<String, List<HLSSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<HLSSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HLSSettingsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'quality_tracks',
  };
}

class HLSSettingsRequestQualityTracksEnum {
  /// Instantiate a new enum with the provided [value].
  const HLSSettingsRequestQualityTracksEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const n360p = HLSSettingsRequestQualityTracksEnum._(r'360p');
  static const n480p = HLSSettingsRequestQualityTracksEnum._(r'480p');
  static const n720p = HLSSettingsRequestQualityTracksEnum._(r'720p');
  static const n1080p = HLSSettingsRequestQualityTracksEnum._(r'1080p');
  static const n1440p = HLSSettingsRequestQualityTracksEnum._(r'1440p');
  static const portrait360x640 =
      HLSSettingsRequestQualityTracksEnum._(r'portrait-360x640');
  static const portrait480x854 =
      HLSSettingsRequestQualityTracksEnum._(r'portrait-480x854');
  static const portrait720x1280 =
      HLSSettingsRequestQualityTracksEnum._(r'portrait-720x1280');
  static const portrait1080x1920 =
      HLSSettingsRequestQualityTracksEnum._(r'portrait-1080x1920');
  static const portrait1440x2560 =
      HLSSettingsRequestQualityTracksEnum._(r'portrait-1440x2560');

  /// List of all possible values in this [enum][HLSSettingsRequestQualityTracksEnum].
  static const values = <HLSSettingsRequestQualityTracksEnum>[
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

  static HLSSettingsRequestQualityTracksEnum? fromJson(dynamic value) =>
      HLSSettingsRequestQualityTracksEnumTypeTransformer().decode(value);

  static List<HLSSettingsRequestQualityTracksEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <HLSSettingsRequestQualityTracksEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HLSSettingsRequestQualityTracksEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [HLSSettingsRequestQualityTracksEnum] to String,
/// and [decode] dynamic data back to [HLSSettingsRequestQualityTracksEnum].
class HLSSettingsRequestQualityTracksEnumTypeTransformer {
  factory HLSSettingsRequestQualityTracksEnumTypeTransformer() => _instance ??=
      const HLSSettingsRequestQualityTracksEnumTypeTransformer._();

  const HLSSettingsRequestQualityTracksEnumTypeTransformer._();

  String encode(HLSSettingsRequestQualityTracksEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a HLSSettingsRequestQualityTracksEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  HLSSettingsRequestQualityTracksEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'360p':
          return HLSSettingsRequestQualityTracksEnum.n360p;
        case r'480p':
          return HLSSettingsRequestQualityTracksEnum.n480p;
        case r'720p':
          return HLSSettingsRequestQualityTracksEnum.n720p;
        case r'1080p':
          return HLSSettingsRequestQualityTracksEnum.n1080p;
        case r'1440p':
          return HLSSettingsRequestQualityTracksEnum.n1440p;
        case r'portrait-360x640':
          return HLSSettingsRequestQualityTracksEnum.portrait360x640;
        case r'portrait-480x854':
          return HLSSettingsRequestQualityTracksEnum.portrait480x854;
        case r'portrait-720x1280':
          return HLSSettingsRequestQualityTracksEnum.portrait720x1280;
        case r'portrait-1080x1920':
          return HLSSettingsRequestQualityTracksEnum.portrait1080x1920;
        case r'portrait-1440x2560':
          return HLSSettingsRequestQualityTracksEnum.portrait1440x2560;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [HLSSettingsRequestQualityTracksEnumTypeTransformer] instance.
  static HLSSettingsRequestQualityTracksEnumTypeTransformer? _instance;
}
