//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LayoutSettingsRequest {
  /// Returns a new [LayoutSettingsRequest] instance.
  LayoutSettingsRequest({
    this.externalAppUrl,
    this.externalCssUrl,
    required this.name,
    this.options = const {},
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? externalAppUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? externalCssUrl;

  LayoutSettingsRequestNameEnum name;

  Map<String, Object> options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is LayoutSettingsRequest &&
    other.externalAppUrl == externalAppUrl &&
    other.externalCssUrl == externalCssUrl &&
    other.name == name &&
    _deepEquality.equals(other.options, options);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (externalAppUrl == null ? 0 : externalAppUrl!.hashCode) +
    (externalCssUrl == null ? 0 : externalCssUrl!.hashCode) +
    (name.hashCode) +
    (options.hashCode);

  @override
  String toString() => 'LayoutSettingsRequest[externalAppUrl=$externalAppUrl, externalCssUrl=$externalCssUrl, name=$name, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.externalAppUrl != null) {
      json[r'external_app_url'] = this.externalAppUrl;
    } else {
      json[r'external_app_url'] = null;
    }
    if (this.externalCssUrl != null) {
      json[r'external_css_url'] = this.externalCssUrl;
    } else {
      json[r'external_css_url'] = null;
    }
      json[r'name'] = this.name;
      json[r'options'] = this.options;
    return json;
  }

  /// Returns a new [LayoutSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LayoutSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "LayoutSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "LayoutSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LayoutSettingsRequest(
        externalAppUrl: mapValueOfType<String>(json, r'external_app_url'),
        externalCssUrl: mapValueOfType<String>(json, r'external_css_url'),
        name: LayoutSettingsRequestNameEnum.fromJson(json[r'name'])!,
        options: mapCastOfType<String, Object>(json, r'options') ?? const {},
      );
    }
    return null;
  }

  static List<LayoutSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LayoutSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LayoutSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LayoutSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, LayoutSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LayoutSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LayoutSettingsRequest-objects as value to a dart map
  static Map<String, List<LayoutSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<LayoutSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LayoutSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}


class LayoutSettingsRequestNameEnum {
  /// Instantiate a new enum with the provided [value].
  const LayoutSettingsRequestNameEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const spotlight = LayoutSettingsRequestNameEnum._(r'spotlight');
  static const grid = LayoutSettingsRequestNameEnum._(r'grid');
  static const singleParticipant = LayoutSettingsRequestNameEnum._(r'single-participant');
  static const mobile = LayoutSettingsRequestNameEnum._(r'mobile');
  static const custom = LayoutSettingsRequestNameEnum._(r'custom');

  /// List of all possible values in this [enum][LayoutSettingsRequestNameEnum].
  static const values = <LayoutSettingsRequestNameEnum>[
    spotlight,
    grid,
    singleParticipant,
    mobile,
    custom,
  ];

  static LayoutSettingsRequestNameEnum? fromJson(dynamic value) => LayoutSettingsRequestNameEnumTypeTransformer().decode(value);

  static List<LayoutSettingsRequestNameEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <LayoutSettingsRequestNameEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LayoutSettingsRequestNameEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LayoutSettingsRequestNameEnum] to String,
/// and [decode] dynamic data back to [LayoutSettingsRequestNameEnum].
class LayoutSettingsRequestNameEnumTypeTransformer {
  factory LayoutSettingsRequestNameEnumTypeTransformer() => _instance ??= const LayoutSettingsRequestNameEnumTypeTransformer._();

  const LayoutSettingsRequestNameEnumTypeTransformer._();

  String encode(LayoutSettingsRequestNameEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a LayoutSettingsRequestNameEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LayoutSettingsRequestNameEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'spotlight': return LayoutSettingsRequestNameEnum.spotlight;
        case r'grid': return LayoutSettingsRequestNameEnum.grid;
        case r'single-participant': return LayoutSettingsRequestNameEnum.singleParticipant;
        case r'mobile': return LayoutSettingsRequestNameEnum.mobile;
        case r'custom': return LayoutSettingsRequestNameEnum.custom;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [LayoutSettingsRequestNameEnumTypeTransformer] instance.
  static LayoutSettingsRequestNameEnumTypeTransformer? _instance;
}


