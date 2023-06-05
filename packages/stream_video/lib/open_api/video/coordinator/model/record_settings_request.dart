//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecordSettingsRequest {
  /// Returns a new [RecordSettingsRequest] instance.
  RecordSettingsRequest({
    this.audioOnly,
    this.mode,
    this.quality,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? audioOnly;

  RecordSettingsRequestModeEnum? mode;

  RecordSettingsRequestQualityEnum? quality;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecordSettingsRequest &&
     other.audioOnly == audioOnly &&
     other.mode == mode &&
     other.quality == quality;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (audioOnly == null ? 0 : audioOnly!.hashCode) +
    (mode == null ? 0 : mode!.hashCode) +
    (quality == null ? 0 : quality!.hashCode);

  @override
  String toString() => 'RecordSettingsRequest[audioOnly=$audioOnly, mode=$mode, quality=$quality]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.audioOnly != null) {
      json[r'audio_only'] = this.audioOnly;
    } else {
      json[r'audio_only'] = null;
    }
    if (this.mode != null) {
      json[r'mode'] = this.mode;
    } else {
      json[r'mode'] = null;
    }
    if (this.quality != null) {
      json[r'quality'] = this.quality;
    } else {
      json[r'quality'] = null;
    }
    return json;
  }

  /// Returns a new [RecordSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecordSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecordSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecordSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecordSettingsRequest(
        audioOnly: mapValueOfType<bool>(json, r'audio_only'),
        mode: RecordSettingsRequestModeEnum.fromJson(json[r'mode']),
        quality: RecordSettingsRequestQualityEnum.fromJson(json[r'quality']),
      );
    }
    return null;
  }

  static List<RecordSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecordSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, RecordSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecordSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecordSettingsRequest-objects as value to a dart map
  static Map<String, List<RecordSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecordSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecordSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class RecordSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const RecordSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = RecordSettingsRequestModeEnum._(r'available');
  static const disabled = RecordSettingsRequestModeEnum._(r'disabled');
  static const autoOn = RecordSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][RecordSettingsRequestModeEnum].
  static const values = <RecordSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static RecordSettingsRequestModeEnum? fromJson(dynamic value) => RecordSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<RecordSettingsRequestModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RecordSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [RecordSettingsRequestModeEnum].
class RecordSettingsRequestModeEnumTypeTransformer {
  factory RecordSettingsRequestModeEnumTypeTransformer() => _instance ??= const RecordSettingsRequestModeEnumTypeTransformer._();

  const RecordSettingsRequestModeEnumTypeTransformer._();

  String encode(RecordSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RecordSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RecordSettingsRequestModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available': return RecordSettingsRequestModeEnum.available;
        case r'disabled': return RecordSettingsRequestModeEnum.disabled;
        case r'auto-on': return RecordSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RecordSettingsRequestModeEnumTypeTransformer] instance.
  static RecordSettingsRequestModeEnumTypeTransformer? _instance;
}



class RecordSettingsRequestQualityEnum {
  /// Instantiate a new enum with the provided [value].
  const RecordSettingsRequestQualityEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const audioOnly = RecordSettingsRequestQualityEnum._(r'audio-only');
  static const n360p = RecordSettingsRequestQualityEnum._(r'360p');
  static const n480p = RecordSettingsRequestQualityEnum._(r'480p');
  static const n720p = RecordSettingsRequestQualityEnum._(r'720p');
  static const n1080p = RecordSettingsRequestQualityEnum._(r'1080p');
  static const n1440p = RecordSettingsRequestQualityEnum._(r'1440p');

  /// List of all possible values in this [enum][RecordSettingsRequestQualityEnum].
  static const values = <RecordSettingsRequestQualityEnum>[
    audioOnly,
    n360p,
    n480p,
    n720p,
    n1080p,
    n1440p,
  ];

  static RecordSettingsRequestQualityEnum? fromJson(dynamic value) => RecordSettingsRequestQualityEnumTypeTransformer().decode(value);

  static List<RecordSettingsRequestQualityEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecordSettingsRequestQualityEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecordSettingsRequestQualityEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RecordSettingsRequestQualityEnum] to String,
/// and [decode] dynamic data back to [RecordSettingsRequestQualityEnum].
class RecordSettingsRequestQualityEnumTypeTransformer {
  factory RecordSettingsRequestQualityEnumTypeTransformer() => _instance ??= const RecordSettingsRequestQualityEnumTypeTransformer._();

  const RecordSettingsRequestQualityEnumTypeTransformer._();

  String encode(RecordSettingsRequestQualityEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RecordSettingsRequestQualityEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RecordSettingsRequestQualityEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'audio-only': return RecordSettingsRequestQualityEnum.audioOnly;
        case r'360p': return RecordSettingsRequestQualityEnum.n360p;
        case r'480p': return RecordSettingsRequestQualityEnum.n480p;
        case r'720p': return RecordSettingsRequestQualityEnum.n720p;
        case r'1080p': return RecordSettingsRequestQualityEnum.n1080p;
        case r'1440p': return RecordSettingsRequestQualityEnum.n1440p;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RecordSettingsRequestQualityEnumTypeTransformer] instance.
  static RecordSettingsRequestQualityEnumTypeTransformer? _instance;
}


