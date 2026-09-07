//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EncryptionSettingsResponse {
  /// Returns a new [EncryptionSettingsResponse] instance.
  EncryptionSettingsResponse({
    required this.mode,
  });

  /// the resolved encryption mode for the call
  EncryptionSettingsResponseModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncryptionSettingsResponse && other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (mode.hashCode);

  @override
  String toString() => 'EncryptionSettingsResponse[mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [EncryptionSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EncryptionSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "EncryptionSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "EncryptionSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EncryptionSettingsResponse(
        mode: EncryptionSettingsResponseModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<EncryptionSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <EncryptionSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EncryptionSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EncryptionSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, EncryptionSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EncryptionSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EncryptionSettingsResponse-objects as value to a dart map
  static Map<String, List<EncryptionSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<EncryptionSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EncryptionSettingsResponse.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'mode',
  };
}

class EncryptionSettingsResponseModeEnum {
  /// Instantiate a new enum with the provided [value].
  const EncryptionSettingsResponseModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = EncryptionSettingsResponseModeEnum._(r'available');
  static const disabled = EncryptionSettingsResponseModeEnum._(r'disabled');
  static const autoOn = EncryptionSettingsResponseModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][EncryptionSettingsResponseModeEnum].
  static const values = <EncryptionSettingsResponseModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static EncryptionSettingsResponseModeEnum? fromJson(dynamic value) =>
      EncryptionSettingsResponseModeEnumTypeTransformer().decode(value);

  static List<EncryptionSettingsResponseModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <EncryptionSettingsResponseModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EncryptionSettingsResponseModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

class EncryptionSettingsResponseModeEnumTypeTransformer {
  factory EncryptionSettingsResponseModeEnumTypeTransformer() =>
      _instance ??= const EncryptionSettingsResponseModeEnumTypeTransformer._();

  const EncryptionSettingsResponseModeEnumTypeTransformer._();

  String encode(EncryptionSettingsResponseModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EncryptionSettingsResponseModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EncryptionSettingsResponseModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return EncryptionSettingsResponseModeEnum.available;
        case r'disabled':
          return EncryptionSettingsResponseModeEnum.disabled;
        case r'auto-on':
          return EncryptionSettingsResponseModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EncryptionSettingsResponseModeEnumTypeTransformer] instance.
  static EncryptionSettingsResponseModeEnumTypeTransformer? _instance;
}
