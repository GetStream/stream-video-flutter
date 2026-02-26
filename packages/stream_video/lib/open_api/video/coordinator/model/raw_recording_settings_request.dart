//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RawRecordingSettingsRequest {
  /// Returns a new [RawRecordingSettingsRequest] instance.
  RawRecordingSettingsRequest({
    required this.mode,
  });

  RawRecordingSettingsRequestModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawRecordingSettingsRequest && other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (mode.hashCode);

  @override
  String toString() => 'RawRecordingSettingsRequest[mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [RawRecordingSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RawRecordingSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "RawRecordingSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "RawRecordingSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RawRecordingSettingsRequest(
        mode: RawRecordingSettingsRequestModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<RawRecordingSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RawRecordingSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RawRecordingSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RawRecordingSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, RawRecordingSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RawRecordingSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RawRecordingSettingsRequest-objects as value to a dart map
  static Map<String, List<RawRecordingSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<RawRecordingSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RawRecordingSettingsRequest.listFromJson(
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

class RawRecordingSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const RawRecordingSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = RawRecordingSettingsRequestModeEnum._(r'available');
  static const disabled = RawRecordingSettingsRequestModeEnum._(r'disabled');
  static const autoOn = RawRecordingSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][RawRecordingSettingsRequestModeEnum].
  static const values = <RawRecordingSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static RawRecordingSettingsRequestModeEnum? fromJson(dynamic value) =>
      RawRecordingSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<RawRecordingSettingsRequestModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <RawRecordingSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RawRecordingSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RawRecordingSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [RawRecordingSettingsRequestModeEnum].
class RawRecordingSettingsRequestModeEnumTypeTransformer {
  factory RawRecordingSettingsRequestModeEnumTypeTransformer() => _instance ??=
      const RawRecordingSettingsRequestModeEnumTypeTransformer._();

  const RawRecordingSettingsRequestModeEnumTypeTransformer._();

  String encode(RawRecordingSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RawRecordingSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RawRecordingSettingsRequestModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return RawRecordingSettingsRequestModeEnum.available;
        case r'disabled':
          return RawRecordingSettingsRequestModeEnum.disabled;
        case r'auto-on':
          return RawRecordingSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RawRecordingSettingsRequestModeEnumTypeTransformer] instance.
  static RawRecordingSettingsRequestModeEnumTypeTransformer? _instance;
}
