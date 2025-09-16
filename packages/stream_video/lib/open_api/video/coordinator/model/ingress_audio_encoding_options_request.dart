//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngressAudioEncodingOptionsRequest {
  /// Returns a new [IngressAudioEncodingOptionsRequest] instance.
  IngressAudioEncodingOptionsRequest({
    required this.bitrate,
    required this.channels,
    this.enableDtx,
  });

  /// Minimum value: 16000
  /// Maximum value: 128000
  int bitrate;

  IngressAudioEncodingOptionsRequestChannelsEnum channels;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enableDtx;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngressAudioEncodingOptionsRequest &&
          other.bitrate == bitrate &&
          other.channels == channels &&
          other.enableDtx == enableDtx;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (bitrate.hashCode) +
      (channels.hashCode) +
      (enableDtx == null ? 0 : enableDtx!.hashCode);

  @override
  String toString() =>
      'IngressAudioEncodingOptionsRequest[bitrate=$bitrate, channels=$channels, enableDtx=$enableDtx]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'bitrate'] = this.bitrate;
    json[r'channels'] = this.channels;
    if (this.enableDtx != null) {
      json[r'enable_dtx'] = this.enableDtx;
    } else {
      json[r'enable_dtx'] = null;
    }
    return json;
  }

  /// Returns a new [IngressAudioEncodingOptionsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngressAudioEncodingOptionsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "IngressAudioEncodingOptionsRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "IngressAudioEncodingOptionsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngressAudioEncodingOptionsRequest(
        bitrate: mapValueOfType<int>(json, r'bitrate')!,
        channels: IngressAudioEncodingOptionsRequestChannelsEnum.fromJson(
            json[r'channels'])!,
        enableDtx: mapValueOfType<bool>(json, r'enable_dtx'),
      );
    }
    return null;
  }

  static List<IngressAudioEncodingOptionsRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressAudioEncodingOptionsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngressAudioEncodingOptionsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngressAudioEncodingOptionsRequest> mapFromJson(
      dynamic json) {
    final map = <String, IngressAudioEncodingOptionsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngressAudioEncodingOptionsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngressAudioEncodingOptionsRequest-objects as value to a dart map
  static Map<String, List<IngressAudioEncodingOptionsRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<IngressAudioEncodingOptionsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngressAudioEncodingOptionsRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'bitrate',
    'channels',
  };
}

class IngressAudioEncodingOptionsRequestChannelsEnum {
  /// Instantiate a new enum with the provided [value].
  const IngressAudioEncodingOptionsRequestChannelsEnum._(this.value);

  /// The underlying value of this enum member.
  final int value;

  @override
  String toString() => value.toString();

  int toJson() => value;

  static const number1 = IngressAudioEncodingOptionsRequestChannelsEnum._(1);
  static const number2 = IngressAudioEncodingOptionsRequestChannelsEnum._(2);

  /// List of all possible values in this [enum][IngressAudioEncodingOptionsRequestChannelsEnum].
  static const values = <IngressAudioEncodingOptionsRequestChannelsEnum>[
    number1,
    number2,
  ];

  static IngressAudioEncodingOptionsRequestChannelsEnum? fromJson(
          dynamic value) =>
      IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer()
          .decode(value);

  static List<IngressAudioEncodingOptionsRequestChannelsEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <IngressAudioEncodingOptionsRequestChannelsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value =
            IngressAudioEncodingOptionsRequestChannelsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [IngressAudioEncodingOptionsRequestChannelsEnum] to int,
/// and [decode] dynamic data back to [IngressAudioEncodingOptionsRequestChannelsEnum].
class IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer {
  factory IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer() =>
      _instance ??=
          const IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer
              ._();

  const IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer._();

  int encode(IngressAudioEncodingOptionsRequestChannelsEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a IngressAudioEncodingOptionsRequestChannelsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  IngressAudioEncodingOptionsRequestChannelsEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case 1:
          return IngressAudioEncodingOptionsRequestChannelsEnum.number1;
        case 2:
          return IngressAudioEncodingOptionsRequestChannelsEnum.number2;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer] instance.
  static IngressAudioEncodingOptionsRequestChannelsEnumTypeTransformer?
      _instance;
}
