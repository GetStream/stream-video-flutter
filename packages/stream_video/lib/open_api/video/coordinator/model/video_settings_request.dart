//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoSettingsRequest {
  /// Returns a new [VideoSettingsRequest] instance.
  VideoSettingsRequest({
    this.accessRequestEnabled,
    this.cameraDefaultOn,
    this.cameraFacing,
    this.enabled,
    this.targetResolution,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? accessRequestEnabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? cameraDefaultOn;

  VideoSettingsRequestCameraFacingEnum? cameraFacing;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? enabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  TargetResolutionRequest? targetResolution;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoSettingsRequest &&
     other.accessRequestEnabled == accessRequestEnabled &&
     other.cameraDefaultOn == cameraDefaultOn &&
     other.cameraFacing == cameraFacing &&
     other.enabled == enabled &&
     other.targetResolution == targetResolution;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessRequestEnabled == null ? 0 : accessRequestEnabled!.hashCode) +
    (cameraDefaultOn == null ? 0 : cameraDefaultOn!.hashCode) +
    (cameraFacing == null ? 0 : cameraFacing!.hashCode) +
    (enabled == null ? 0 : enabled!.hashCode) +
    (targetResolution == null ? 0 : targetResolution!.hashCode);

  @override
  String toString() => 'VideoSettingsRequest[accessRequestEnabled=$accessRequestEnabled, cameraDefaultOn=$cameraDefaultOn, cameraFacing=$cameraFacing, enabled=$enabled, targetResolution=$targetResolution]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.accessRequestEnabled != null) {
      json[r'access_request_enabled'] = this.accessRequestEnabled;
    } else {
      json[r'access_request_enabled'] = null;
    }
    if (this.cameraDefaultOn != null) {
      json[r'camera_default_on'] = this.cameraDefaultOn;
    } else {
      json[r'camera_default_on'] = null;
    }
    if (this.cameraFacing != null) {
      json[r'camera_facing'] = this.cameraFacing;
    } else {
      json[r'camera_facing'] = null;
    }
    if (this.enabled != null) {
      json[r'enabled'] = this.enabled;
    } else {
      json[r'enabled'] = null;
    }
    if (this.targetResolution != null) {
      json[r'target_resolution'] = this.targetResolution;
    } else {
      json[r'target_resolution'] = null;
    }
    return json;
  }

  /// Returns a new [VideoSettingsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoSettingsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoSettingsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoSettingsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoSettingsRequest(
        accessRequestEnabled: mapValueOfType<bool>(json, r'access_request_enabled'),
        cameraDefaultOn: mapValueOfType<bool>(json, r'camera_default_on'),
        cameraFacing: VideoSettingsRequestCameraFacingEnum.fromJson(json[r'camera_facing']),
        enabled: mapValueOfType<bool>(json, r'enabled'),
        targetResolution: TargetResolutionRequest.fromJson(json[r'target_resolution']),
      );
    }
    return null;
  }

  static List<VideoSettingsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettingsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettingsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoSettingsRequest> mapFromJson(dynamic json) {
    final map = <String, VideoSettingsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoSettingsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoSettingsRequest-objects as value to a dart map
  static Map<String, List<VideoSettingsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoSettingsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoSettingsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class VideoSettingsRequestCameraFacingEnum {
  /// Instantiate a new enum with the provided [value].
  const VideoSettingsRequestCameraFacingEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const front = VideoSettingsRequestCameraFacingEnum._(r'front');
  static const back = VideoSettingsRequestCameraFacingEnum._(r'back');
  static const external_ = VideoSettingsRequestCameraFacingEnum._(r'external');

  /// List of all possible values in this [enum][VideoSettingsRequestCameraFacingEnum].
  static const values = <VideoSettingsRequestCameraFacingEnum>[
    front,
    back,
    external_,
  ];

  static VideoSettingsRequestCameraFacingEnum? fromJson(dynamic value) => VideoSettingsRequestCameraFacingEnumTypeTransformer().decode(value);

  static List<VideoSettingsRequestCameraFacingEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoSettingsRequestCameraFacingEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoSettingsRequestCameraFacingEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoSettingsRequestCameraFacingEnum] to String,
/// and [decode] dynamic data back to [VideoSettingsRequestCameraFacingEnum].
class VideoSettingsRequestCameraFacingEnumTypeTransformer {
  factory VideoSettingsRequestCameraFacingEnumTypeTransformer() => _instance ??= const VideoSettingsRequestCameraFacingEnumTypeTransformer._();

  const VideoSettingsRequestCameraFacingEnumTypeTransformer._();

  String encode(VideoSettingsRequestCameraFacingEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a VideoSettingsRequestCameraFacingEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoSettingsRequestCameraFacingEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'front': return VideoSettingsRequestCameraFacingEnum.front;
        case r'back': return VideoSettingsRequestCameraFacingEnum.back;
        case r'external': return VideoSettingsRequestCameraFacingEnum.external_;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [VideoSettingsRequestCameraFacingEnumTypeTransformer] instance.
  static VideoSettingsRequestCameraFacingEnumTypeTransformer? _instance;
}


