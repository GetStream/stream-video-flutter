//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ParticipantSeriesPublisherStats {
  /// Returns a new [ParticipantSeriesPublisherStats] instance.
  ParticipantSeriesPublisherStats({
    this.global = const {},
    this.globalMeta = const {},
    this.globalMetricsOrder = const [],
    this.globalThresholds = const {},
    this.tracks = const {},
  });

  Map<String, List<List<double>>> global;

  Map<String, MetricDescriptor> globalMeta;

  List<String> globalMetricsOrder;

  Map<String, List<MetricThreshold>> globalThresholds;

  Map<String, List<ParticipantSeriesTrackMetrics>> tracks;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipantSeriesPublisherStats &&
          _deepEquality.equals(other.global, global) &&
          _deepEquality.equals(other.globalMeta, globalMeta) &&
          _deepEquality.equals(other.globalMetricsOrder, globalMetricsOrder) &&
          _deepEquality.equals(other.globalThresholds, globalThresholds) &&
          _deepEquality.equals(other.tracks, tracks);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (global.hashCode) +
      (globalMeta.hashCode) +
      (globalMetricsOrder.hashCode) +
      (globalThresholds.hashCode) +
      (tracks.hashCode);

  @override
  String toString() =>
      'ParticipantSeriesPublisherStats[global=$global, globalMeta=$globalMeta, globalMetricsOrder=$globalMetricsOrder, globalThresholds=$globalThresholds, tracks=$tracks]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'global'] = this.global;
    json[r'global_meta'] = this.globalMeta;
    json[r'global_metrics_order'] = this.globalMetricsOrder;
    json[r'global_thresholds'] = this.globalThresholds;
    json[r'tracks'] = this.tracks;
    return json;
  }

  /// Returns a new [ParticipantSeriesPublisherStats] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ParticipantSeriesPublisherStats? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ParticipantSeriesPublisherStats(
        // MANUAL_EDIT: _mapListListDoubleFromJson instead of List.mapListFromJson
        global: json[r'global'] == null
            ? const {}
            : _mapListListDoubleFromJson(json[r'global']),
        globalMeta: MetricDescriptor.mapFromJson(json[r'global_meta']),
        globalMetricsOrder: json[r'global_metrics_order'] is Iterable
            ? (json[r'global_metrics_order'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        globalThresholds: json[r'global_thresholds'] == null
            ? const {}
            : MetricThreshold.mapListFromJson(json[r'global_thresholds']),
        tracks: json[r'tracks'] == null
            ? const {}
            : ParticipantSeriesTrackMetrics.mapListFromJson(json[r'tracks']),
      );
    }
    return null;
  }

  static List<ParticipantSeriesPublisherStats> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ParticipantSeriesPublisherStats>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ParticipantSeriesPublisherStats.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ParticipantSeriesPublisherStats> mapFromJson(
      dynamic json) {
    final map = <String, ParticipantSeriesPublisherStats>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ParticipantSeriesPublisherStats.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ParticipantSeriesPublisherStats-objects as value to a dart map
  static Map<String, List<ParticipantSeriesPublisherStats>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ParticipantSeriesPublisherStats>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ParticipantSeriesPublisherStats.listFromJson(
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
