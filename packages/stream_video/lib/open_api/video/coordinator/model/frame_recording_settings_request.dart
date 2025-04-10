//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FrameRecordingSettingsRequest {
  /// Returns a new [FrameRecordingSettingsRequest] instance.
  FrameRecordingSettingsRequest({
    required this.captureIntervalInSeconds,
    required this.mode,
    this.quality,
  });

  /// Minimum value: 2
  /// Maximum value: 60
  int captureIntervalInSeconds;

  FrameRecordingSettingsRequestModeEnum mode;

  FrameRecordingSettingsRequestQualityEnum? quality;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameRecordingSettingsRequest &&
          other.captureIntervalInSeconds == captureIntervalInSeconds &&
          other.mode == mode &&
          other.quality == quality;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (captureIntervalInSeconds.hashCode) +
      (mode.hashCode) +
      (quality == null ? 0 : quality!.hashCode);

  @override
  String toString() =>
      'FrameRecordingSettingsRequest[captureIntervalInSeconds=$captureIntervalInSeconds, mode=$mode, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'capture_interval_in_seconds'] = this.captureIntervalInSeconds;
    json[r'mode'] = this.mode;
    if (this.quality != null) {
      json[r'quality'] = this.quality;
    } else {
      json[r'quality'] = null;
    }
    return json;
  }

  /// Returns a new [FrameRecordingSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FrameRecordingSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FrameRecordingSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FrameRecordingSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FrameRecordingSettingsRequest(
        captureIntervalInSeconds:
            mapValueOfType<int>(json, r'capture_interval_in_seconds')!,
        mode: FrameRecordingSettingsRequestModeEnum.fromJson(json[r'mode'])!,
        quality:
            FrameRecordingSettingsRequestQualityEnum.fromJson(json[r'quality']),
      );
    }
    return null;
  }

  static List<FrameRecordingSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FrameRecordingSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FrameRecordingSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FrameRecordingSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, FrameRecordingSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FrameRecordingSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FrameRecordingSettingsRequest-objects as value to a dart map
  static Map<String, List<FrameRecordingSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FrameRecordingSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FrameRecordingSettingsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'capture_interval_in_seconds',
    'mode',
  };
}

class FrameRecordingSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const FrameRecordingSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      FrameRecordingSettingsRequestModeEnum._(r'available');
  static const disabled = FrameRecordingSettingsRequestModeEnum._(r'disabled');
  static const autoOn = FrameRecordingSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][FrameRecordingSettingsRequestModeEnum].
  static const values = <FrameRecordingSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static FrameRecordingSettingsRequestModeEnum? fromJson(dynamic value) =>
      FrameRecordingSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<FrameRecordingSettingsRequestModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FrameRecordingSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FrameRecordingSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [FrameRecordingSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [FrameRecordingSettingsRequestModeEnum].
class FrameRecordingSettingsRequestModeEnumTypeTransformer {
  factory FrameRecordingSettingsRequestModeEnumTypeTransformer() =>
      _instance ??=
          const FrameRecordingSettingsRequestModeEnumTypeTransformer._();

  const FrameRecordingSettingsRequestModeEnumTypeTransformer._();

  String encode(FrameRecordingSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a FrameRecordingSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  FrameRecordingSettingsRequestModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return FrameRecordingSettingsRequestModeEnum.available;
        case r'disabled':
          return FrameRecordingSettingsRequestModeEnum.disabled;
        case r'auto-on':
          return FrameRecordingSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [FrameRecordingSettingsRequestModeEnumTypeTransformer] instance.
  static FrameRecordingSettingsRequestModeEnumTypeTransformer? _instance;
}

class FrameRecordingSettingsRequestQualityEnum {
  /// Instantiate a new enum with the provided [value].
  const FrameRecordingSettingsRequestQualityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const n360p = FrameRecordingSettingsRequestQualityEnum._(r'360p');
  static const n480p = FrameRecordingSettingsRequestQualityEnum._(r'480p');
  static const n720p = FrameRecordingSettingsRequestQualityEnum._(r'720p');
  static const n1080p = FrameRecordingSettingsRequestQualityEnum._(r'1080p');
  static const n1440p = FrameRecordingSettingsRequestQualityEnum._(r'1440p');

  /// List of all possible values in this [enum][FrameRecordingSettingsRequestQualityEnum].
  static const values = <FrameRecordingSettingsRequestQualityEnum>[
    n360p,
    n480p,
    n720p,
    n1080p,
    n1440p,
  ];

  static FrameRecordingSettingsRequestQualityEnum? fromJson(dynamic value) =>
      FrameRecordingSettingsRequestQualityEnumTypeTransformer().decode(value);

  static List<FrameRecordingSettingsRequestQualityEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FrameRecordingSettingsRequestQualityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FrameRecordingSettingsRequestQualityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [FrameRecordingSettingsRequestQualityEnum] to String,
/// and [decode] dynamic data back to [FrameRecordingSettingsRequestQualityEnum].
class FrameRecordingSettingsRequestQualityEnumTypeTransformer {
  factory FrameRecordingSettingsRequestQualityEnumTypeTransformer() =>
      _instance ??=
          const FrameRecordingSettingsRequestQualityEnumTypeTransformer._();

  const FrameRecordingSettingsRequestQualityEnumTypeTransformer._();

  String encode(FrameRecordingSettingsRequestQualityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a FrameRecordingSettingsRequestQualityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  FrameRecordingSettingsRequestQualityEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'360p':
          return FrameRecordingSettingsRequestQualityEnum.n360p;
        case r'480p':
          return FrameRecordingSettingsRequestQualityEnum.n480p;
        case r'720p':
          return FrameRecordingSettingsRequestQualityEnum.n720p;
        case r'1080p':
          return FrameRecordingSettingsRequestQualityEnum.n1080p;
        case r'1440p':
          return FrameRecordingSettingsRequestQualityEnum.n1440p;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [FrameRecordingSettingsRequestQualityEnumTypeTransformer] instance.
  static FrameRecordingSettingsRequestQualityEnumTypeTransformer? _instance;
}
