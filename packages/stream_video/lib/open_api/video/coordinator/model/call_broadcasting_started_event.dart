//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CallBroadcastingStartedEvent {
  /// Returns a new [CallBroadcastingStartedEvent] instance.
  CallBroadcastingStartedEvent({
    required this.callCid,
    required this.createdAt,
    required this.hlsPlaylistUrl,
    this.type = 'call.broadcasting_started',
  });

  String callCid;

  DateTime createdAt;

  String hlsPlaylistUrl;

  /// The type of event: \"call.broadcasting_started\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CallBroadcastingStartedEvent &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.hlsPlaylistUrl == hlsPlaylistUrl &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (hlsPlaylistUrl.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'CallBroadcastingStartedEvent[callCid=$callCid, createdAt=$createdAt, hlsPlaylistUrl=$hlsPlaylistUrl, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'hls_playlist_url'] = this.hlsPlaylistUrl;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [CallBroadcastingStartedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CallBroadcastingStartedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "CallBroadcastingStartedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "CallBroadcastingStartedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return CallBroadcastingStartedEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<CallBroadcastingStartedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CallBroadcastingStartedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CallBroadcastingStartedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CallBroadcastingStartedEvent> mapFromJson(dynamic json) {
    final map = <String, CallBroadcastingStartedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CallBroadcastingStartedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CallBroadcastingStartedEvent-objects as value to a dart map
  static Map<String, List<CallBroadcastingStartedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CallBroadcastingStartedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CallBroadcastingStartedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'hls_playlist_url',
    'type',
  };
}

