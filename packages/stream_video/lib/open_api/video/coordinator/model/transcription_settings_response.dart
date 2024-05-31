//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranscriptionSettingsResponse {
  /// Returns a new [TranscriptionSettingsResponse] instance.
  TranscriptionSettingsResponse({
    required this.closedCaptionMode,
    this.languages = const [],
    required this.mode,
  });

  String closedCaptionMode;

  List<String> languages;

  TranscriptionSettingsResponseModeEnum mode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TranscriptionSettingsResponse &&
    other.closedCaptionMode == closedCaptionMode &&
    _deepEquality.equals(other.languages, languages) &&
    other.mode == mode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (closedCaptionMode.hashCode) +
    (languages.hashCode) +
    (mode.hashCode);

  @override
  String toString() => 'TranscriptionSettingsResponse[closedCaptionMode=$closedCaptionMode, languages=$languages, mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'closed_caption_mode'] = this.closedCaptionMode;
      json[r'languages'] = this.languages;
      json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [TranscriptionSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranscriptionSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TranscriptionSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TranscriptionSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TranscriptionSettingsResponse(
        closedCaptionMode: mapValueOfType<String>(json, r'closed_caption_mode')!,
        languages: json[r'languages'] is Iterable
            ? (json[r'languages'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        mode: TranscriptionSettingsResponseModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<TranscriptionSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranscriptionSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, TranscriptionSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranscriptionSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranscriptionSettingsResponse-objects as value to a dart map
  static Map<String, List<TranscriptionSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TranscriptionSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranscriptionSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'closed_caption_mode',
    'languages',
    'mode',
  };
}


class TranscriptionSettingsResponseModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsResponseModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = TranscriptionSettingsResponseModeEnum._(r'available');
  static const disabled = TranscriptionSettingsResponseModeEnum._(r'disabled');
  static const autoOn = TranscriptionSettingsResponseModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsResponseModeEnum].
  static const values = <TranscriptionSettingsResponseModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsResponseModeEnum? fromJson(dynamic value) => TranscriptionSettingsResponseModeEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsResponseModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettingsResponseModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsResponseModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsResponseModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsResponseModeEnum].
class TranscriptionSettingsResponseModeEnumTypeTransformer {
  factory TranscriptionSettingsResponseModeEnumTypeTransformer() => _instance ??= const TranscriptionSettingsResponseModeEnumTypeTransformer._();

  const TranscriptionSettingsResponseModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsResponseModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsResponseModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsResponseModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available': return TranscriptionSettingsResponseModeEnum.available;
        case r'disabled': return TranscriptionSettingsResponseModeEnum.disabled;
        case r'auto-on': return TranscriptionSettingsResponseModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsResponseModeEnumTypeTransformer] instance.
  static TranscriptionSettingsResponseModeEnumTypeTransformer? _instance;
}


