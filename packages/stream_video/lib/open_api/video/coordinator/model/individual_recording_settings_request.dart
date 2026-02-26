//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IndividualRecordingSettingsRequest {
  /// Returns a new [IndividualRecordingSettingsRequest] instance.
  IndividualRecordingSettingsRequest({
    required this.mode,
  });

  IndividualRecordingSettingsRequestModeEnum mode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndividualRecordingSettingsRequest && other.mode == mode;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (mode.hashCode);

  @override
  String toString() => 'IndividualRecordingSettingsRequest[mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'mode'] = this.mode;
    return json;
  }

  /// Returns a new [IndividualRecordingSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IndividualRecordingSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IndividualRecordingSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IndividualRecordingSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IndividualRecordingSettingsRequest(
        mode:
            IndividualRecordingSettingsRequestModeEnum.fromJson(json[r'mode'])!,
      );
    }
    return null;
  }

  static List<IndividualRecordingSettingsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IndividualRecordingSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IndividualRecordingSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IndividualRecordingSettingsRequest> mapFromJson(
      dynamic json) {
    final map = <String, IndividualRecordingSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IndividualRecordingSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IndividualRecordingSettingsRequest-objects as value to a dart map
  static Map<String, List<IndividualRecordingSettingsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IndividualRecordingSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IndividualRecordingSettingsRequest.listFromJson(
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

class IndividualRecordingSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const IndividualRecordingSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available =
      IndividualRecordingSettingsRequestModeEnum._(r'available');
  static const disabled =
      IndividualRecordingSettingsRequestModeEnum._(r'disabled');
  static const autoOn =
      IndividualRecordingSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][IndividualRecordingSettingsRequestModeEnum].
  static const values = <IndividualRecordingSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static IndividualRecordingSettingsRequestModeEnum? fromJson(dynamic value) =>
      IndividualRecordingSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<IndividualRecordingSettingsRequestModeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IndividualRecordingSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IndividualRecordingSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [IndividualRecordingSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [IndividualRecordingSettingsRequestModeEnum].
class IndividualRecordingSettingsRequestModeEnumTypeTransformer {
  factory IndividualRecordingSettingsRequestModeEnumTypeTransformer() =>
      _instance ??=
          const IndividualRecordingSettingsRequestModeEnumTypeTransformer._();

  const IndividualRecordingSettingsRequestModeEnumTypeTransformer._();

  String encode(IndividualRecordingSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a IndividualRecordingSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  IndividualRecordingSettingsRequestModeEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available':
          return IndividualRecordingSettingsRequestModeEnum.available;
        case r'disabled':
          return IndividualRecordingSettingsRequestModeEnum.disabled;
        case r'auto-on':
          return IndividualRecordingSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [IndividualRecordingSettingsRequestModeEnumTypeTransformer] instance.
  static IndividualRecordingSettingsRequestModeEnumTypeTransformer? _instance;
}
