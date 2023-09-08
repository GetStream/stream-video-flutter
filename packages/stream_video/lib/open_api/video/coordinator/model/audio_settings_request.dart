//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AudioSettingsRequest {
  /// Returns a new [AudioSettingsRequest] instance.
  AudioSettingsRequest({
    this.accessRequestEnabled,
    required this.defaultDevice,
    this.micDefaultOn,
    this.opusDtxEnabled,
    this.redundantCodingEnabled,
    this.speakerDefaultOn,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? accessRequestEnabled;

  AudioSettingsRequestDefaultDeviceEnum defaultDevice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? micDefaultOn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? opusDtxEnabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? redundantCodingEnabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? speakerDefaultOn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AudioSettingsRequest &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.defaultDevice == defaultDevice &&
     other.micDefaultOn == micDefaultOn &&
     other.opusDtxEnabled == opusDtxEnabled &&
     other.redundantCodingEnabled == redundantCodingEnabled &&
     other.speakerDefaultOn == speakerDefaultOn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled == null ? 0 : accessRequestEnabled!.hashCode) +
    (defaultDevice.hashCode) +
    (micDefaultOn == null ? 0 : micDefaultOn!.hashCode) +
    (opusDtxEnabled == null ? 0 : opusDtxEnabled!.hashCode) +
    (redundantCodingEnabled == null ? 0 : redundantCodingEnabled!.hashCode) +
    (speakerDefaultOn == null ? 0 : speakerDefaultOn!.hashCode);

  @override
  String toString() => 'AudioSettingsRequest[accessRequestEnabled=$accessRequestEnabled, defaultDevice=$defaultDevice, micDefaultOn=$micDefaultOn, opusDtxEnabled=$opusDtxEnabled, redundantCodingEnabled=$redundantCodingEnabled, speakerDefaultOn=$speakerDefaultOn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.accessRequestEnabled != null) {
      json[r'access_request_enabled'] = this.accessRequestEnabled;
    } else {
      json[r'access_request_enabled'] = null;
    }
      json[r'default_device'] = this.defaultDevice;
    if (this.micDefaultOn != null) {
      json[r'mic_default_on'] = this.micDefaultOn;
    } else {
      json[r'mic_default_on'] = null;
    }
    if (this.opusDtxEnabled != null) {
      json[r'opus_dtx_enabled'] = this.opusDtxEnabled;
    } else {
      json[r'opus_dtx_enabled'] = null;
    }
    if (this.redundantCodingEnabled != null) {
      json[r'redundant_coding_enabled'] = this.redundantCodingEnabled;
    } else {
      json[r'redundant_coding_enabled'] = null;
    }
    if (this.speakerDefaultOn != null) {
      json[r'speaker_default_on'] = this.speakerDefaultOn;
    } else {
      json[r'speaker_default_on'] = null;
    }
    return json;
  }

  /// Returns a new [AudioSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AudioSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AudioSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AudioSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AudioSettingsRequest(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled'),
        defaultDevice: AudioSettingsRequestDefaultDeviceEnum.fromJson(json[r'default_device'])!,
        micDefaultOn: mapValueOfType<bool>(json, r'mic_default_on'),
        opusDtxEnabled: mapValueOfType<bool>(json, r'opus_dtx_enabled'),
        redundantCodingEnabled: mapValueOfType<bool>(json, r'redundant_coding_enabled'),
        speakerDefaultOn: mapValueOfType<bool>(json, r'speaker_default_on'),
      );
    }
    return null;
  }

  static List<AudioSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AudioSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AudioSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AudioSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, AudioSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AudioSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AudioSettingsRequest-objects as value to a dart map
  static Map<String, List<AudioSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AudioSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AudioSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'default_device',
  };
}


class AudioSettingsRequestDefaultDeviceEnum {
  /// Instantiate a new enum with the provided [value].
  const AudioSettingsRequestDefaultDeviceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const speaker = AudioSettingsRequestDefaultDeviceEnum._(r'speaker');
  static const earpiece = AudioSettingsRequestDefaultDeviceEnum._(r'earpiece');

  /// List of all possible values in this [enum][AudioSettingsRequestDefaultDeviceEnum].
  static const values = <AudioSettingsRequestDefaultDeviceEnum>[
    speaker,
    earpiece,
  ];

  static AudioSettingsRequestDefaultDeviceEnum? fromJson(dynamic value) => AudioSettingsRequestDefaultDeviceEnumTypeTransformer().decode(value);

  static List<AudioSettingsRequestDefaultDeviceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AudioSettingsRequestDefaultDeviceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AudioSettingsRequestDefaultDeviceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AudioSettingsRequestDefaultDeviceEnum] to String,
/// and [decode] dynamic data back to [AudioSettingsRequestDefaultDeviceEnum].
class AudioSettingsRequestDefaultDeviceEnumTypeTransformer {
  factory AudioSettingsRequestDefaultDeviceEnumTypeTransformer() => _instance ??= const AudioSettingsRequestDefaultDeviceEnumTypeTransformer._();

  const AudioSettingsRequestDefaultDeviceEnumTypeTransformer._();

  String encode(AudioSettingsRequestDefaultDeviceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AudioSettingsRequestDefaultDeviceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AudioSettingsRequestDefaultDeviceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'speaker': return AudioSettingsRequestDefaultDeviceEnum.speaker;
        case r'earpiece': return AudioSettingsRequestDefaultDeviceEnum.earpiece;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AudioSettingsRequestDefaultDeviceEnumTypeTransformer] instance.
  static AudioSettingsRequestDefaultDeviceEnumTypeTransformer? _instance;
}


