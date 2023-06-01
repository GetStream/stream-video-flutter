//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranscriptionSettings {
  /// Returns a new [TranscriptionSettings] instance.
  TranscriptionSettings({
    required this.closedCaptionMode,
    required this.mode,
  });

  String closedCaptionMode;

  TranscriptionSettingsModeEnum mode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TranscriptionSettings &&
     other.closedCaptionMode == closedCaptionMode &&
     other.mode == mode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (closedCaptionMode.hashCode) +
    (mode.hashCode);

  @override
  String toString() => 'TranscriptionSettings[closedCaptionMode=$closedCaptionMode, mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'closed_caption_mode'] = this.closedCaptionMode;
      json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [TranscriptionSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranscriptionSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TranscriptionSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TranscriptionSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TranscriptionSettings(
        closedCaptionMode: mapValueOfType<String>(json, r'closed_caption_mode')!,
        mode: TranscriptionSettingsModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<TranscriptionSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranscriptionSettings> mapFromJson(dynamic json) {
    final map = <String, TranscriptionSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranscriptionSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranscriptionSettings-objects as value to a dart map
  static Map<String, List<TranscriptionSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TranscriptionSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranscriptionSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'closed_caption_mode',
    'mode',
  };
}


class TranscriptionSettingsModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = TranscriptionSettingsModeEnum._(r'available');
  static const disabled = TranscriptionSettingsModeEnum._(r'disabled');
  static const autoOn = TranscriptionSettingsModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsModeEnum].
  static const values = <TranscriptionSettingsModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsModeEnum? fromJson(dynamic value) => TranscriptionSettingsModeEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettingsModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsModeEnum].
class TranscriptionSettingsModeEnumTypeTransformer {
  factory TranscriptionSettingsModeEnumTypeTransformer() => _instance ??= const TranscriptionSettingsModeEnumTypeTransformer._();

  const TranscriptionSettingsModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available': return TranscriptionSettingsModeEnum.available;
        case r'disabled': return TranscriptionSettingsModeEnum.disabled;
        case r'auto-on': return TranscriptionSettingsModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsModeEnumTypeTransformer] instance.
  static TranscriptionSettingsModeEnumTypeTransformer? _instance;
}


