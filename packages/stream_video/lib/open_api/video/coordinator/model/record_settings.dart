//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecordSettings {
  /// Returns a new [RecordSettings] instance.
  RecordSettings({
    required this.audioOnly,
    required this.mode,
    required this.quality,
  });

  bool audioOnly;

  RecordSettingsModeEnum mode;

  RecordSettingsQualityEnum quality;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordSettings &&
     other.audioOnly == audioOnly &&
     other.mode == mode &&
     other.quality == quality;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioOnly.hashCode) +
    (mode.hashCode) +
    (quality.hashCode);

  @override
  String toString() => 'RecordSettings[audioOnly=$audioOnly, mode=$mode, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'audio_only'] = this.audioOnly;
      json[r'mode'] = this.mode;
      json[r'quality'] = this.quality;
    return json;
  }

  /// Returns a new [RecordSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecordSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecordSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecordSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecordSettings(
        audioOnly: mapValueOfType<bool>(json, r'audio_only')!,
        mode: RecordSettingsModeEnum.fromJson(json[r'mode'])!,
        quality: RecordSettingsQualityEnum.fromJson(json[r'quality'])!,
      );
    }
    return null;
  }

  static List<RecordSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecordSettings> mapFromJson(dynamic json) {
    final map = <String, RecordSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecordSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecordSettings-objects as value to a dart map
  static Map<String, List<RecordSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecordSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecordSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'audio_only',
    'mode',
    'quality',
  };
}


class RecordSettingsModeEnum {
  /// Instantiate a new enum with the provided [value].
  const RecordSettingsModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = RecordSettingsModeEnum._(r'available');
  static const disabled = RecordSettingsModeEnum._(r'disabled');
  static const autoOn = RecordSettingsModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][RecordSettingsModeEnum].
  static const values = <RecordSettingsModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static RecordSettingsModeEnum? fromJson(dynamic value) => RecordSettingsModeEnumTypeTransformer().decode(value);

  static List<RecordSettingsModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RecordSettingsModeEnum] to String,
/// and [decode] dynamic data back to [RecordSettingsModeEnum].
class RecordSettingsModeEnumTypeTransformer {
  factory RecordSettingsModeEnumTypeTransformer() => _instance ??= const RecordSettingsModeEnumTypeTransformer._();

  const RecordSettingsModeEnumTypeTransformer._();

  String encode(RecordSettingsModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RecordSettingsModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RecordSettingsModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available': return RecordSettingsModeEnum.available;
        case r'disabled': return RecordSettingsModeEnum.disabled;
        case r'auto-on': return RecordSettingsModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RecordSettingsModeEnumTypeTransformer] instance.
  static RecordSettingsModeEnumTypeTransformer? _instance;
}



class RecordSettingsQualityEnum {
  /// Instantiate a new enum with the provided [value].
  const RecordSettingsQualityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const audioOnly = RecordSettingsQualityEnum._(r'audio-only');
  static const n360p = RecordSettingsQualityEnum._(r'360p');
  static const n480p = RecordSettingsQualityEnum._(r'480p');
  static const n720p = RecordSettingsQualityEnum._(r'720p');
  static const n1080p = RecordSettingsQualityEnum._(r'1080p');
  static const n1440p = RecordSettingsQualityEnum._(r'1440p');

  /// List of all possible values in this [enum][RecordSettingsQualityEnum].
  static const values = <RecordSettingsQualityEnum>[
    audioOnly,
    n360p,
    n480p,
    n720p,
    n1080p,
    n1440p,
  ];

  static RecordSettingsQualityEnum? fromJson(dynamic value) => RecordSettingsQualityEnumTypeTransformer().decode(value);

  static List<RecordSettingsQualityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsQualityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsQualityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RecordSettingsQualityEnum] to String,
/// and [decode] dynamic data back to [RecordSettingsQualityEnum].
class RecordSettingsQualityEnumTypeTransformer {
  factory RecordSettingsQualityEnumTypeTransformer() => _instance ??= const RecordSettingsQualityEnumTypeTransformer._();

  const RecordSettingsQualityEnumTypeTransformer._();

  String encode(RecordSettingsQualityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RecordSettingsQualityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RecordSettingsQualityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'audio-only': return RecordSettingsQualityEnum.audioOnly;
        case r'360p': return RecordSettingsQualityEnum.n360p;
        case r'480p': return RecordSettingsQualityEnum.n480p;
        case r'720p': return RecordSettingsQualityEnum.n720p;
        case r'1080p': return RecordSettingsQualityEnum.n1080p;
        case r'1440p': return RecordSettingsQualityEnum.n1440p;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RecordSettingsQualityEnumTypeTransformer] instance.
  static RecordSettingsQualityEnumTypeTransformer? _instance;
}


