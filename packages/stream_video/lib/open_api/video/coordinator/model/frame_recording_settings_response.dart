//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FrameRecordingSettingsResponse {
  /// Returns a new [FrameRecordingSettingsResponse] instance.
  FrameRecordingSettingsResponse({
    required this.captureIntervalInSeconds,
    required this.mode,
    this.quality,
  });

  /// Minimum value: 2
  /// Maximum value: 60
  int captureIntervalInSeconds;

  FrameRecordingSettingsResponseModeEnum mode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? quality;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameRecordingSettingsResponse &&
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
      'FrameRecordingSettingsResponse[captureIntervalInSeconds=$captureIntervalInSeconds, mode=$mode, quality=$quality]';

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

  /// Returns a new [FrameRecordingSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FrameRecordingSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FrameRecordingSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FrameRecordingSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FrameRecordingSettingsResponse(
        captureIntervalInSeconds:
            mapValueOfType<int>(json, r'capture_interval_in_seconds')!,
        mode: FrameRecordingSettingsResponseModeEnum.fromJson(json[r'mode'])!,
        quality: mapValueOfType<String>(json, r'quality'),
      );
    }
    return null;
  }

  static List<FrameRecordingSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FrameRecordingSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FrameRecordingSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FrameRecordingSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, FrameRecordingSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FrameRecordingSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FrameRecordingSettingsResponse-objects as value to a dart map
  static Map<String, List<FrameRecordingSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FrameRecordingSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FrameRecordingSettingsResponse.listFromJson(
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

class FrameRecordingSettingsResponseModeEnum {
  /// Instantiate a new enum with the provided [value].
  const FrameRecordingSettingsResponseModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      FrameRecordingSettingsResponseModeEnum._(r'available');
  static const disabled = FrameRecordingSettingsResponseModeEnum._(r'disabled');
  static const autoOn = FrameRecordingSettingsResponseModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][FrameRecordingSettingsResponseModeEnum].
  static const values = <FrameRecordingSettingsResponseModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static FrameRecordingSettingsResponseModeEnum? fromJson(dynamic value) =>
      FrameRecordingSettingsResponseModeEnumTypeTransformer().decode(value);

  static List<FrameRecordingSettingsResponseModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FrameRecordingSettingsResponseModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FrameRecordingSettingsResponseModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [FrameRecordingSettingsResponseModeEnum] to String,
/// and [decode] dynamic data back to [FrameRecordingSettingsResponseModeEnum].
class FrameRecordingSettingsResponseModeEnumTypeTransformer {
  factory FrameRecordingSettingsResponseModeEnumTypeTransformer() =>
      _instance ??=
          const FrameRecordingSettingsResponseModeEnumTypeTransformer._();

  const FrameRecordingSettingsResponseModeEnumTypeTransformer._();

  String encode(FrameRecordingSettingsResponseModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a FrameRecordingSettingsResponseModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  FrameRecordingSettingsResponseModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return FrameRecordingSettingsResponseModeEnum.available;
        case r'disabled':
          return FrameRecordingSettingsResponseModeEnum.disabled;
        case r'auto-on':
          return FrameRecordingSettingsResponseModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [FrameRecordingSettingsResponseModeEnumTypeTransformer] instance.
  static FrameRecordingSettingsResponseModeEnumTypeTransformer? _instance;
}
