//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IndividualRecordingSettingsResponse {
  /// Returns a new [IndividualRecordingSettingsResponse] instance.
  IndividualRecordingSettingsResponse({
    required this.mode,
  });

  IndividualRecordingSettingsResponseModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndividualRecordingSettingsResponse && other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (mode.hashCode);

  @override
  String toString() => 'IndividualRecordingSettingsResponse[mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [IndividualRecordingSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IndividualRecordingSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IndividualRecordingSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IndividualRecordingSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IndividualRecordingSettingsResponse(
        mode: IndividualRecordingSettingsResponseModeEnum.fromJson(
            json[r'mode'])!,
      );
    }
    return null;
  }

  static List<IndividualRecordingSettingsResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IndividualRecordingSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IndividualRecordingSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IndividualRecordingSettingsResponse> mapFromJson(
      dynamic json) {
    final map = <String, IndividualRecordingSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IndividualRecordingSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IndividualRecordingSettingsResponse-objects as value to a dart map
  static Map<String, List<IndividualRecordingSettingsResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IndividualRecordingSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IndividualRecordingSettingsResponse.listFromJson(
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

class IndividualRecordingSettingsResponseModeEnum {
  /// Instantiate a new enum with the provided [value].
  const IndividualRecordingSettingsResponseModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      IndividualRecordingSettingsResponseModeEnum._(r'available');
  static const disabled =
      IndividualRecordingSettingsResponseModeEnum._(r'disabled');
  static const autoOn =
      IndividualRecordingSettingsResponseModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][IndividualRecordingSettingsResponseModeEnum].
  static const values = <IndividualRecordingSettingsResponseModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static IndividualRecordingSettingsResponseModeEnum? fromJson(dynamic value) =>
      IndividualRecordingSettingsResponseModeEnumTypeTransformer()
          .decode(value);

  static List<IndividualRecordingSettingsResponseModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IndividualRecordingSettingsResponseModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IndividualRecordingSettingsResponseModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [IndividualRecordingSettingsResponseModeEnum] to String,
/// and [decode] dynamic data back to [IndividualRecordingSettingsResponseModeEnum].
class IndividualRecordingSettingsResponseModeEnumTypeTransformer {
  factory IndividualRecordingSettingsResponseModeEnumTypeTransformer() =>
      _instance ??=
          const IndividualRecordingSettingsResponseModeEnumTypeTransformer._();

  const IndividualRecordingSettingsResponseModeEnumTypeTransformer._();

  String encode(IndividualRecordingSettingsResponseModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a IndividualRecordingSettingsResponseModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  IndividualRecordingSettingsResponseModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return IndividualRecordingSettingsResponseModeEnum.available;
        case r'disabled':
          return IndividualRecordingSettingsResponseModeEnum.disabled;
        case r'auto-on':
          return IndividualRecordingSettingsResponseModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [IndividualRecordingSettingsResponseModeEnumTypeTransformer] instance.
  static IndividualRecordingSettingsResponseModeEnumTypeTransformer? _instance;
}
