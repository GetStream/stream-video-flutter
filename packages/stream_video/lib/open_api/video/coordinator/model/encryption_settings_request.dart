//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EncryptionSettingsRequest {
  /// Returns a new [EncryptionSettingsRequest] instance.
  EncryptionSettingsRequest({
    this.mode,
  });

  /// Encryption mode. One of: available, disabled, auto-on
  EncryptionSettingsRequestModeEnum? mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncryptionSettingsRequest && other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (mode == null ? 0 : mode!.hashCode);

  @override
  String toString() => 'EncryptionSettingsRequest[mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.mode != null) {
      json[r'mode'] = this.mode;
    } else {
      json[r'mode'] = null;
    }
    return json;
  }

  /// Returns a new [EncryptionSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EncryptionSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return EncryptionSettingsRequest(
        mode: EncryptionSettingsRequestModeEnum.fromJson(json[r'mode']),
      );
    }
    return null;
  }

  static List<EncryptionSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <EncryptionSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EncryptionSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EncryptionSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, EncryptionSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EncryptionSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EncryptionSettingsRequest-objects as value to a dart map
  static Map<String, List<EncryptionSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<EncryptionSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EncryptionSettingsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}

class EncryptionSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const EncryptionSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = EncryptionSettingsRequestModeEnum._(r'available');
  static const disabled = EncryptionSettingsRequestModeEnum._(r'disabled');
  static const autoOn = EncryptionSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][EncryptionSettingsRequestModeEnum].
  static const values = <EncryptionSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static EncryptionSettingsRequestModeEnum? fromJson(dynamic value) =>
      EncryptionSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<EncryptionSettingsRequestModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <EncryptionSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EncryptionSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

class EncryptionSettingsRequestModeEnumTypeTransformer {
  factory EncryptionSettingsRequestModeEnumTypeTransformer() =>
      _instance ??= const EncryptionSettingsRequestModeEnumTypeTransformer._();

  const EncryptionSettingsRequestModeEnumTypeTransformer._();

  String encode(EncryptionSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a EncryptionSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EncryptionSettingsRequestModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return EncryptionSettingsRequestModeEnum.available;
        case r'disabled':
          return EncryptionSettingsRequestModeEnum.disabled;
        case r'auto-on':
          return EncryptionSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EncryptionSettingsRequestModeEnumTypeTransformer] instance.
  static EncryptionSettingsRequestModeEnumTypeTransformer? _instance;
}
