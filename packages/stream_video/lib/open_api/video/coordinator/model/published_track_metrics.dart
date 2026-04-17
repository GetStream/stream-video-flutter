//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PublishedTrackMetrics {
  /// Returns a new [PublishedTrackMetrics] instance.
  PublishedTrackMetrics({
    this.bitrate,
    this.codec,
    this.framerate,
    this.resolution,
    this.trackId,
    this.trackType,
    this.warnings = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MetricTimeSeries? bitrate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? codec;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MetricTimeSeries? framerate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ResolutionMetricsTimeSeries? resolution;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trackId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trackType;

  List<SessionWarningResponse> warnings;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublishedTrackMetrics &&
          other.bitrate == bitrate &&
          other.codec == codec &&
          other.framerate == framerate &&
          other.resolution == resolution &&
          other.trackId == trackId &&
          other.trackType == trackType &&
          _deepEquality.equals(other.warnings, warnings);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (bitrate == null ? 0 : bitrate!.hashCode) +
      (codec == null ? 0 : codec!.hashCode) +
      (framerate == null ? 0 : framerate!.hashCode) +
      (resolution == null ? 0 : resolution!.hashCode) +
      (trackId == null ? 0 : trackId!.hashCode) +
      (trackType == null ? 0 : trackType!.hashCode) +
      (warnings.hashCode);

  @override
  String toString() =>
      'PublishedTrackMetrics[bitrate=$bitrate, codec=$codec, framerate=$framerate, resolution=$resolution, trackId=$trackId, trackType=$trackType, warnings=$warnings]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.bitrate != null) {
      json[r'bitrate'] = this.bitrate;
    } else {
      json[r'bitrate'] = null;
    }
    if (this.codec != null) {
      json[r'codec'] = this.codec;
    } else {
      json[r'codec'] = null;
    }
    if (this.framerate != null) {
      json[r'framerate'] = this.framerate;
    } else {
      json[r'framerate'] = null;
    }
    if (this.resolution != null) {
      json[r'resolution'] = this.resolution;
    } else {
      json[r'resolution'] = null;
    }
    if (this.trackId != null) {
      json[r'track_id'] = this.trackId;
    } else {
      json[r'track_id'] = null;
    }
    if (this.trackType != null) {
      json[r'track_type'] = this.trackType;
    } else {
      json[r'track_type'] = null;
    }
    json[r'warnings'] = this.warnings;
    return json;
  }

  /// Returns a new [PublishedTrackMetrics] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PublishedTrackMetrics? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return PublishedTrackMetrics(
        bitrate: MetricTimeSeries.fromJson(json[r'bitrate']),
        codec: mapValueOfType<String>(json, r'codec'),
        framerate: MetricTimeSeries.fromJson(json[r'framerate']),
        resolution: ResolutionMetricsTimeSeries.fromJson(json[r'resolution']),
        trackId: mapValueOfType<String>(json, r'track_id'),
        trackType: mapValueOfType<String>(json, r'track_type'),
        warnings: SessionWarningResponse.listFromJson(json[r'warnings']),
      );
    }
    return null;
  }

  static List<PublishedTrackMetrics> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PublishedTrackMetrics>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PublishedTrackMetrics.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PublishedTrackMetrics> mapFromJson(dynamic json) {
    final map = <String, PublishedTrackMetrics>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PublishedTrackMetrics.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PublishedTrackMetrics-objects as value to a dart map
  static Map<String, List<PublishedTrackMetrics>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PublishedTrackMetrics>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PublishedTrackMetrics.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
