//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TranscriptionSettingsRequest {
  /// Returns a new [TranscriptionSettingsRequest] instance.
  TranscriptionSettingsRequest({
    this.closedCaptionMode,
    this.mode,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? closedCaptionMode;

  TranscriptionSettingsRequestModeEnum? mode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TranscriptionSettingsRequest &&
     other.closedCaptionMode == closedCaptionMode &&
     other.mode == mode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (closedCaptionMode == null ? 0 : closedCaptionMode!.hashCode) +
    (mode == null ? 0 : mode!.hashCode);

  @override
  String toString() => 'TranscriptionSettingsRequest[closedCaptionMode=$closedCaptionMode, mode=$mode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.closedCaptionMode != null) {
      json[r'closed_caption_mode'] = this.closedCaptionMode;
    } else {
      json[r'closed_caption_mode'] = null;
    }
    if (this.mode != null) {
      json[r'mode'] = this.mode;
    } else {
      json[r'mode'] = null;
    }
    return json;
  }

  /// Returns a new [TranscriptionSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TranscriptionSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TranscriptionSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TranscriptionSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TranscriptionSettingsRequest(
        closedCaptionMode: mapValueOfType<String>(json, r'closed_caption_mode'),
        mode: TranscriptionSettingsRequestModeEnum.fromJson(json[r'mode']),
      );
    }
    return null;
  }

  static List<TranscriptionSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TranscriptionSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, TranscriptionSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TranscriptionSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TranscriptionSettingsRequest-objects as value to a dart map
  static Map<String, List<TranscriptionSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TranscriptionSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TranscriptionSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class TranscriptionSettingsRequestModeEnum {
  /// Instantiate a new enum with the provided [value].
  const TranscriptionSettingsRequestModeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const available = TranscriptionSettingsRequestModeEnum._(r'available');
  static const disabled = TranscriptionSettingsRequestModeEnum._(r'disabled');
  static const autoOn = TranscriptionSettingsRequestModeEnum._(r'auto-on');

  /// List of all possible values in this [enum][TranscriptionSettingsRequestModeEnum].
  static const values = <TranscriptionSettingsRequestModeEnum>[
    available,
    disabled,
    autoOn,
  ];

  static TranscriptionSettingsRequestModeEnum? fromJson(dynamic value) => TranscriptionSettingsRequestModeEnumTypeTransformer().decode(value);

  static List<TranscriptionSettingsRequestModeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TranscriptionSettingsRequestModeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TranscriptionSettingsRequestModeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [TranscriptionSettingsRequestModeEnum] to String,
/// and [decode] dynamic data back to [TranscriptionSettingsRequestModeEnum].
class TranscriptionSettingsRequestModeEnumTypeTransformer {
  factory TranscriptionSettingsRequestModeEnumTypeTransformer() => _instance ??= const TranscriptionSettingsRequestModeEnumTypeTransformer._();

  const TranscriptionSettingsRequestModeEnumTypeTransformer._();

  String encode(TranscriptionSettingsRequestModeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a TranscriptionSettingsRequestModeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  TranscriptionSettingsRequestModeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'available': return TranscriptionSettingsRequestModeEnum.available;
        case r'disabled': return TranscriptionSettingsRequestModeEnum.disabled;
        case r'auto-on': return TranscriptionSettingsRequestModeEnum.autoOn;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [TranscriptionSettingsRequestModeEnumTypeTransformer] instance.
  static TranscriptionSettingsRequestModeEnumTypeTransformer? _instance;
}


