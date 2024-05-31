//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublishedTrackInfo {
  /// Returns a new [PublishedTrackInfo] instance.
  PublishedTrackInfo({
    this.codecMimeType,
    this.durationSeconds,
    this.trackType,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? codecMimeType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? durationSeconds;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trackType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PublishedTrackInfo &&
    other.codecMimeType == codecMimeType &&
    other.durationSeconds == durationSeconds &&
    other.trackType == trackType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (codecMimeType == null ? 0 : codecMimeType!.hashCode) +
    (durationSeconds == null ? 0 : durationSeconds!.hashCode) +
    (trackType == null ? 0 : trackType!.hashCode);

  @override
  String toString() => 'PublishedTrackInfo[codecMimeType=$codecMimeType, durationSeconds=$durationSeconds, trackType=$trackType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.codecMimeType != null) {
      json[r'codec_mime_type'] = this.codecMimeType;
    } else {
      json[r'codec_mime_type'] = null;
    }
    if (this.durationSeconds != null) {
      json[r'duration_seconds'] = this.durationSeconds;
    } else {
      json[r'duration_seconds'] = null;
    }
    if (this.trackType != null) {
      json[r'track_type'] = this.trackType;
    } else {
      json[r'track_type'] = null;
    }
    return json;
  }

  /// Returns a new [PublishedTrackInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublishedTrackInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PublishedTrackInfo[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PublishedTrackInfo[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PublishedTrackInfo(
        codecMimeType: mapValueOfType<String>(json, r'codec_mime_type'),
        durationSeconds: mapValueOfType<int>(json, r'duration_seconds'),
        trackType: mapValueOfType<String>(json, r'track_type'),
      );
    }
    return null;
  }

  static List<PublishedTrackInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PublishedTrackInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublishedTrackInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublishedTrackInfo> mapFromJson(dynamic json) {
    final map = <String, PublishedTrackInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublishedTrackInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublishedTrackInfo-objects as value to a dart map
  static Map<String, List<PublishedTrackInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PublishedTrackInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublishedTrackInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

