//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallStatsReportReadyEvent {
  /// Returns a new [CallStatsReportReadyEvent] instance.
  CallStatsReportReadyEvent({
    required this.callCid,
    required this.createdAt,
    this.isTrimmed,
    this.participantsOverview = const [],
    required this.sessionId,
    this.type = 'call.stats_report_ready',
  });

  String callCid;

  DateTime createdAt;

  /// Whether participants_overview is truncated by the server-side limit
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isTrimmed;

  /// Top participant sessions overview
  List<CallStatsParticipant> participantsOverview;

  /// Call session ID
  String sessionId;

  /// The type of event, \"call.report_ready\" in this case
  String type;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallStatsReportReadyEvent &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.isTrimmed == isTrimmed &&
          _deepEquality.equals(
              other.participantsOverview, participantsOverview) &&
          other.sessionId == sessionId &&
          other.type == type;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (callCid.hashCode) +
      (createdAt.hashCode) +
      (isTrimmed == null ? 0 : isTrimmed!.hashCode) +
      (participantsOverview.hashCode) +
      (sessionId.hashCode) +
      (type.hashCode);

  @override
  String toString() =>
      'CallStatsReportReadyEvent[callCid=$callCid, createdAt=$createdAt, isTrimmed=$isTrimmed, participantsOverview=$participantsOverview, sessionId=$sessionId, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'call_cid'] = this.callCid;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.isTrimmed != null) {
      json[r'is_trimmed'] = this.isTrimmed;
    } else {
      json[r'is_trimmed'] = null;
    }
    json[r'participants_overview'] = this.participantsOverview;
    json[r'session_id'] = this.sessionId;
    json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallStatsReportReadyEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallStatsReportReadyEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'call_cid'),
            'Required key "CallStatsReportReadyEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "CallStatsReportReadyEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "CallStatsReportReadyEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "CallStatsReportReadyEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'session_id'),
            'Required key "CallStatsReportReadyEvent[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null,
            'Required key "CallStatsReportReadyEvent[session_id]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "CallStatsReportReadyEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "CallStatsReportReadyEvent[type]" has a null value in JSON.');
        return true;
      }());

      return CallStatsReportReadyEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        isTrimmed: mapValueOfType<bool>(json, r'is_trimmed'),
        participantsOverview:
            CallStatsParticipant.listFromJson(json[r'participants_overview']),
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallStatsReportReadyEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <CallStatsReportReadyEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallStatsReportReadyEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallStatsReportReadyEvent> mapFromJson(dynamic json) {
    final map = <String, CallStatsReportReadyEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallStatsReportReadyEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallStatsReportReadyEvent-objects as value to a dart map
  static Map<String, List<CallStatsReportReadyEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<CallStatsReportReadyEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallStatsReportReadyEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'session_id',
    'type',
  };
}
