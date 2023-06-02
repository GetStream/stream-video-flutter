//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TargetResolutionRequest {
  /// Returns a new [TargetResolutionRequest] instance.
  TargetResolutionRequest({
    this.bitrate,
    this.height,
    this.width,
  });

  /// Maximum value: 6000000
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? bitrate;

  /// Minimum value: 240
  /// Maximum value: 2560
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? height;

  /// Minimum value: 240
  /// Maximum value: 2560
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? width;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TargetResolutionRequest &&
     other.bitrate == bitrate &&
     other.height == height &&
     other.width == width;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (bitrate == null ? 0 : bitrate!.hashCode) +
    (height == null ? 0 : height!.hashCode) +
    (width == null ? 0 : width!.hashCode);

  @override
  String toString() => 'TargetResolutionRequest[bitrate=$bitrate, height=$height, width=$width]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.bitrate != null) {
      json[r'bitrate'] = this.bitrate;
    } else {
      json[r'bitrate'] = null;
    }
    if (this.height != null) {
      json[r'height'] = this.height;
    } else {
      json[r'height'] = null;
    }
    if (this.width != null) {
      json[r'width'] = this.width;
    } else {
      json[r'width'] = null;
    }
    return json;
  }

  /// Returns a new [TargetResolutionRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TargetResolutionRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TargetResolutionRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TargetResolutionRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TargetResolutionRequest(
        bitrate: mapValueOfType<int>(json, r'bitrate'),
        height: mapValueOfType<int>(json, r'height'),
        width: mapValueOfType<int>(json, r'width'),
      );
    }
    return null;
  }

  static List<TargetResolutionRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TargetResolutionRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TargetResolutionRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TargetResolutionRequest> mapFromJson(dynamic json) {
    final map = <String, TargetResolutionRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TargetResolutionRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TargetResolutionRequest-objects as value to a dart map
  static Map<String, List<TargetResolutionRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TargetResolutionRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TargetResolutionRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

