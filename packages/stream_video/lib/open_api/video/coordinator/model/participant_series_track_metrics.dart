//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantSeriesTrackMetrics {
  /// Returns a new [ParticipantSeriesTrackMetrics] instance.
  ParticipantSeriesTrackMetrics({
    this.codec,
    this.label,
    this.metrics = const {},
    this.metricsMeta = const {},
    this.metricsOrder = const [],
    this.rid,
    this.thresholds = const {},
    required this.trackId,
    this.trackType,
  });

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
  String? label;

  Map<String, List<List<double>>> metrics;

  Map<String, MetricDescriptor> metricsMeta;

  List<String> metricsOrder;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? rid;

  Map<String, List<MetricThreshold>> thresholds;

  String trackId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? trackType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSeriesTrackMetrics &&
          other.codec == codec &&
          other.label == label &&
          _deepEquality.equals(other.metrics, metrics) &&
          _deepEquality.equals(other.metricsMeta, metricsMeta) &&
          _deepEquality.equals(other.metricsOrder, metricsOrder) &&
          other.rid == rid &&
          _deepEquality.equals(other.thresholds, thresholds) &&
          other.trackId == trackId &&
          other.trackType == trackType;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (codec == null ? 0 : codec!.hashCode) +
      (label == null ? 0 : label!.hashCode) +
      (metrics.hashCode) +
      (metricsMeta.hashCode) +
      (metricsOrder.hashCode) +
      (rid == null ? 0 : rid!.hashCode) +
      (thresholds.hashCode) +
      (trackId.hashCode) +
      (trackType == null ? 0 : trackType!.hashCode);

  @override
  String toString() =>
      'ParticipantSeriesTrackMetrics[codec=$codec, label=$label, metrics=$metrics, metricsMeta=$metricsMeta, metricsOrder=$metricsOrder, rid=$rid, thresholds=$thresholds, trackId=$trackId, trackType=$trackType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.codec != null) {
      json[r'codec'] = this.codec;
    } else {
      json[r'codec'] = null;
    }
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
    json[r'metrics'] = this.metrics;
    json[r'metrics_meta'] = this.metricsMeta;
    json[r'metrics_order'] = this.metricsOrder;
    if (this.rid != null) {
      json[r'rid'] = this.rid;
    } else {
      json[r'rid'] = null;
    }
    json[r'thresholds'] = this.thresholds;
    json[r'track_id'] = this.trackId;
    if (this.trackType != null) {
      json[r'track_type'] = this.trackType;
    } else {
      json[r'track_type'] = null;
    }
    return json;
  }

  /// Returns a new [ParticipantSeriesTrackMetrics] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantSeriesTrackMetrics? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'track_id'),
            'Required key "ParticipantSeriesTrackMetrics[track_id]" is missing from JSON.');
        assert(json[r'track_id'] != null,
            'Required key "ParticipantSeriesTrackMetrics[track_id]" has a null value in JSON.');
        return true;
      }());

      return ParticipantSeriesTrackMetrics(
        codec: mapValueOfType<String>(json, r'codec'),
        label: mapValueOfType<String>(json, r'label'),
        // MANUAL_EDIT: _mapListListDoubleFromJson instead of List.mapListFromJson
        metrics: json[r'metrics'] == null
            ? const {}
            : _mapListListDoubleFromJson(json[r'metrics']),
        metricsMeta: MetricDescriptor.mapFromJson(json[r'metrics_meta']),
        metricsOrder: json[r'metrics_order'] is Iterable
            ? (json[r'metrics_order'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        rid: mapValueOfType<String>(json, r'rid'),
        thresholds: json[r'thresholds'] == null
            ? const {}
            : MetricThreshold.mapListFromJson(json[r'thresholds']),
        trackId: mapValueOfType<String>(json, r'track_id')!,
        trackType: mapValueOfType<String>(json, r'track_type'),
      );
    }
    return null;
  }

  static List<ParticipantSeriesTrackMetrics> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantSeriesTrackMetrics>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantSeriesTrackMetrics.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantSeriesTrackMetrics> mapFromJson(dynamic json) {
    final map = <String, ParticipantSeriesTrackMetrics>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantSeriesTrackMetrics.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantSeriesTrackMetrics-objects as value to a dart map
  static Map<String, List<ParticipantSeriesTrackMetrics>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantSeriesTrackMetrics>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantSeriesTrackMetrics.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'track_id',
  };
}
