//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AudioSettingsResponse {
  /// Returns a new [AudioSettingsResponse] instance.
  AudioSettingsResponse({
    required this.accessRequestEnabled,
    required this.defaultDevice,
    required this.micDefaultOn,
    this.noiseCancellation,
    required this.opusDtxEnabled,
    required this.redundantCodingEnabled,
    required this.speakerDefaultOn,
  });

  bool accessRequestEnabled;

  AudioSettingsResponseDefaultDeviceEnum defaultDevice;

  bool micDefaultOn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  NoiseCancellationSettings? noiseCancellation;

  bool opusDtxEnabled;

  bool redundantCodingEnabled;

  bool speakerDefaultOn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AudioSettingsResponse &&
    other.accessRequestEnabled == accessRequestEnabled &&
    other.defaultDevice == defaultDevice &&
    other.micDefaultOn == micDefaultOn &&
    other.noiseCancellation == noiseCancellation &&
    other.opusDtxEnabled == opusDtxEnabled &&
    other.redundantCodingEnabled == redundantCodingEnabled &&
    other.speakerDefaultOn == speakerDefaultOn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (defaultDevice.hashCode) +
    (micDefaultOn.hashCode) +
    (noiseCancellation == null ? 0 : noiseCancellation!.hashCode) +
    (opusDtxEnabled.hashCode) +
    (redundantCodingEnabled.hashCode) +
    (speakerDefaultOn.hashCode);

  @override
  String toString() => 'AudioSettingsResponse[accessRequestEnabled=$accessRequestEnabled, defaultDevice=$defaultDevice, micDefaultOn=$micDefaultOn, noiseCancellation=$noiseCancellation, opusDtxEnabled=$opusDtxEnabled, redundantCodingEnabled=$redundantCodingEnabled, speakerDefaultOn=$speakerDefaultOn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'default_device'] = this.defaultDevice;
      json[r'mic_default_on'] = this.micDefaultOn;
    if (this.noiseCancellation != null) {
      json[r'noise_cancellation'] = this.noiseCancellation;
    } else {
      json[r'noise_cancellation'] = null;
    }
      json[r'opus_dtx_enabled'] = this.opusDtxEnabled;
      json[r'redundant_coding_enabled'] = this.redundantCodingEnabled;
      json[r'speaker_default_on'] = this.speakerDefaultOn;
    return json;
  }

  /// Returns a new [AudioSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AudioSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AudioSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AudioSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AudioSettingsResponse(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        defaultDevice: AudioSettingsResponseDefaultDeviceEnum.fromJson(json[r'default_device'])!,
        micDefaultOn: mapValueOfType<bool>(json, r'mic_default_on')!,
        noiseCancellation: NoiseCancellationSettings.fromJson(json[r'noise_cancellation']),
        opusDtxEnabled: mapValueOfType<bool>(json, r'opus_dtx_enabled')!,
        redundantCodingEnabled: mapValueOfType<bool>(json, r'redundant_coding_enabled')!,
        speakerDefaultOn: mapValueOfType<bool>(json, r'speaker_default_on')!,
      );
    }
    return null;
  }

  static List<AudioSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AudioSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AudioSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AudioSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, AudioSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AudioSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AudioSettingsResponse-objects as value to a dart map
  static Map<String, List<AudioSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AudioSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AudioSettingsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_request_enabled',
    'default_device',
    'mic_default_on',
    'opus_dtx_enabled',
    'redundant_coding_enabled',
    'speaker_default_on',
  };
}


class AudioSettingsResponseDefaultDeviceEnum {
  /// Instantiate a new enum with the provided [value].
  const AudioSettingsResponseDefaultDeviceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const speaker = AudioSettingsResponseDefaultDeviceEnum._(r'speaker');
  static const earpiece = AudioSettingsResponseDefaultDeviceEnum._(r'earpiece');

  /// List of all possible values in this [enum][AudioSettingsResponseDefaultDeviceEnum].
  static const values = <AudioSettingsResponseDefaultDeviceEnum>[
    speaker,
    earpiece,
  ];

  static AudioSettingsResponseDefaultDeviceEnum? fromJson(dynamic value) => AudioSettingsResponseDefaultDeviceEnumTypeTransformer().decode(value);

  static List<AudioSettingsResponseDefaultDeviceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AudioSettingsResponseDefaultDeviceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AudioSettingsResponseDefaultDeviceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AudioSettingsResponseDefaultDeviceEnum] to String,
/// and [decode] dynamic data back to [AudioSettingsResponseDefaultDeviceEnum].
class AudioSettingsResponseDefaultDeviceEnumTypeTransformer {
  factory AudioSettingsResponseDefaultDeviceEnumTypeTransformer() => _instance ??= const AudioSettingsResponseDefaultDeviceEnumTypeTransformer._();

  const AudioSettingsResponseDefaultDeviceEnumTypeTransformer._();

  String encode(AudioSettingsResponseDefaultDeviceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a AudioSettingsResponseDefaultDeviceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AudioSettingsResponseDefaultDeviceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'speaker': return AudioSettingsResponseDefaultDeviceEnum.speaker;
        case r'earpiece': return AudioSettingsResponseDefaultDeviceEnum.earpiece;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AudioSettingsResponseDefaultDeviceEnumTypeTransformer] instance.
  static AudioSettingsResponseDefaultDeviceEnumTypeTransformer? _instance;
}


