//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoSettings {
  /// Returns a new [VideoSettings] instance.
  VideoSettings({
    required this.accessRequestEnabled,
    required this.cameraDefaultOn,
    required this.cameraFacing,
    required this.enabled,
    required this.targetResolution,
  });

  bool accessRequestEnabled;

  bool cameraDefaultOn;

  VideoSettingsCameraFacingEnum cameraFacing;

  bool enabled;

  TargetResolution targetResolution;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoSettings &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.cameraDefaultOn == cameraDefaultOn &&
     other.cameraFacing == cameraFacing &&
     other.enabled == enabled &&
     other.targetResolution == targetResolution;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled.hashCode) +
    (cameraDefaultOn.hashCode) +
    (cameraFacing.hashCode) +
    (enabled.hashCode) +
    (targetResolution.hashCode);

  @override
  String toString() => 'VideoSettings[accessRequestEnabled=$accessRequestEnabled, cameraDefaultOn=$cameraDefaultOn, cameraFacing=$cameraFacing, enabled=$enabled, targetResolution=$targetResolution]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'camera_default_on'] = this.cameraDefaultOn;
      json[r'camera_facing'] = this.cameraFacing;
      json[r'enabled'] = this.enabled;
      json[r'target_resolution'] = this.targetResolution;
    return json;
  }

  /// Returns a new [VideoSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoSettings[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoSettings(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        cameraDefaultOn: mapValueOfType<bool>(json, r'camera_default_on')!,
        cameraFacing: VideoSettingsCameraFacingEnum.fromJson(json[r'camera_facing'])!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        targetResolution: TargetResolution.fromJson(json[r'target_resolution'])!,
      );
    }
    return null;
  }

  static List<VideoSettings> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoSettings> mapFromJson(dynamic json) {
    final map = <String, VideoSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoSettings-objects as value to a dart map
  static Map<String, List<VideoSettings>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoSettings.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_request_enabled',
    'camera_default_on',
    'camera_facing',
    'enabled',
    'target_resolution',
  };
}


class VideoSettingsCameraFacingEnum {
  /// Instantiate a new enum with the provided [value].
  const VideoSettingsCameraFacingEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const front = VideoSettingsCameraFacingEnum._(r'front');
  static const back = VideoSettingsCameraFacingEnum._(r'back');
  static const external_ = VideoSettingsCameraFacingEnum._(r'external');

  /// List of all possible values in this [enum][VideoSettingsCameraFacingEnum].
  static const values = <VideoSettingsCameraFacingEnum>[
    front,
    back,
    external_,
  ];

  static VideoSettingsCameraFacingEnum? fromJson(dynamic value) => VideoSettingsCameraFacingEnumTypeTransformer().decode(value);

  static List<VideoSettingsCameraFacingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettingsCameraFacingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettingsCameraFacingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoSettingsCameraFacingEnum] to String,
/// and [decode] dynamic data back to [VideoSettingsCameraFacingEnum].
class VideoSettingsCameraFacingEnumTypeTransformer {
  factory VideoSettingsCameraFacingEnumTypeTransformer() => _instance ??= const VideoSettingsCameraFacingEnumTypeTransformer._();

  const VideoSettingsCameraFacingEnumTypeTransformer._();

  String encode(VideoSettingsCameraFacingEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a VideoSettingsCameraFacingEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoSettingsCameraFacingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'front': return VideoSettingsCameraFacingEnum.front;
        case r'back': return VideoSettingsCameraFacingEnum.back;
        case r'external': return VideoSettingsCameraFacingEnum.external_;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [VideoSettingsCameraFacingEnumTypeTransformer] instance.
  static VideoSettingsCameraFacingEnumTypeTransformer? _instance;
}


