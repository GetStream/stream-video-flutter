//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoSettingsResponse {
  /// Returns a new [VideoSettingsResponse] instance.
  VideoSettingsResponse({
    required this.accessRequestEnabled,
    required this.cameraDefaultOn,
    required this.cameraFacing,
    required this.enabled,
    required this.targetResolution,
  });

  bool accessRequestEnabled;

  bool cameraDefaultOn;

  VideoSettingsResponseCameraFacingEnum cameraFacing;

  bool enabled;

  TargetResolution targetResolution;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoSettingsResponse &&
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
  String toString() => 'VideoSettingsResponse[accessRequestEnabled=$accessRequestEnabled, cameraDefaultOn=$cameraDefaultOn, cameraFacing=$cameraFacing, enabled=$enabled, targetResolution=$targetResolution]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_request_enabled'] = this.accessRequestEnabled;
      json[r'camera_default_on'] = this.cameraDefaultOn;
      json[r'camera_facing'] = this.cameraFacing;
      json[r'enabled'] = this.enabled;
      json[r'target_resolution'] = this.targetResolution;
    return json;
  }

  /// Returns a new [VideoSettingsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoSettingsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoSettingsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoSettingsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoSettingsResponse(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled')!,
        cameraDefaultOn: mapValueOfType<bool>(json, r'camera_default_on')!,
        cameraFacing: VideoSettingsResponseCameraFacingEnum.fromJson(json[r'camera_facing'])!,
        enabled: mapValueOfType<bool>(json, r'enabled')!,
        targetResolution: TargetResolution.fromJson(json[r'target_resolution'])!,
      );
    }
    return null;
  }

  static List<VideoSettingsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettingsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettingsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoSettingsResponse> mapFromJson(dynamic json) {
    final map = <String, VideoSettingsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoSettingsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoSettingsResponse-objects as value to a dart map
  static Map<String, List<VideoSettingsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoSettingsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoSettingsResponse.listFromJson(entry.value, growable: growable,);
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


class VideoSettingsResponseCameraFacingEnum {
  /// Instantiate a new enum with the provided [value].
  const VideoSettingsResponseCameraFacingEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const front = VideoSettingsResponseCameraFacingEnum._(r'front');
  static const back = VideoSettingsResponseCameraFacingEnum._(r'back');
  static const external_ = VideoSettingsResponseCameraFacingEnum._(r'external');

  /// List of all possible values in this [enum][VideoSettingsResponseCameraFacingEnum].
  static const values = <VideoSettingsResponseCameraFacingEnum>[
    front,
    back,
    external_,
  ];

  static VideoSettingsResponseCameraFacingEnum? fromJson(dynamic value) => VideoSettingsResponseCameraFacingEnumTypeTransformer().decode(value);

  static List<VideoSettingsResponseCameraFacingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettingsResponseCameraFacingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettingsResponseCameraFacingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoSettingsResponseCameraFacingEnum] to String,
/// and [decode] dynamic data back to [VideoSettingsResponseCameraFacingEnum].
class VideoSettingsResponseCameraFacingEnumTypeTransformer {
  factory VideoSettingsResponseCameraFacingEnumTypeTransformer() => _instance ??= const VideoSettingsResponseCameraFacingEnumTypeTransformer._();

  const VideoSettingsResponseCameraFacingEnumTypeTransformer._();

  String encode(VideoSettingsResponseCameraFacingEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a VideoSettingsResponseCameraFacingEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoSettingsResponseCameraFacingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'front': return VideoSettingsResponseCameraFacingEnum.front;
        case r'back': return VideoSettingsResponseCameraFacingEnum.back;
        case r'external': return VideoSettingsResponseCameraFacingEnum.external_;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [VideoSettingsResponseCameraFacingEnumTypeTransformer] instance.
  static VideoSettingsResponseCameraFacingEnumTypeTransformer? _instance;
}


