//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StartRTMPBroadcastsRequest {
  /// Returns a new [StartRTMPBroadcastsRequest] instance.
  StartRTMPBroadcastsRequest({
    this.broadcasts = const [],
  });

  /// List of broadcasts to start
  List<RTMPBroadcastRequest> broadcasts;

  @override
  bool operator ==(Object other) => identical(this, other) || other is StartRTMPBroadcastsRequest &&
    _deepEquality.equals(other.broadcasts, broadcasts);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (broadcasts.hashCode);

  @override
  String toString() => 'StartRTMPBroadcastsRequest[broadcasts=$broadcasts]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'broadcasts'] = this.broadcasts;
    return json;
  }

  /// Returns a new [StartRTMPBroadcastsRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StartRTMPBroadcastsRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "StartRTMPBroadcastsRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "StartRTMPBroadcastsRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StartRTMPBroadcastsRequest(
        broadcasts: RTMPBroadcastRequest.listFromJson(json[r'broadcasts']),
      );
    }
    return null;
  }

  static List<StartRTMPBroadcastsRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <StartRTMPBroadcastsRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StartRTMPBroadcastsRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StartRTMPBroadcastsRequest> mapFromJson(dynamic json) {
    final map = <String, StartRTMPBroadcastsRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StartRTMPBroadcastsRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StartRTMPBroadcastsRequest-objects as value to a dart map
  static Map<String, List<StartRTMPBroadcastsRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<StartRTMPBroadcastsRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StartRTMPBroadcastsRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'broadcasts',
  };
}

