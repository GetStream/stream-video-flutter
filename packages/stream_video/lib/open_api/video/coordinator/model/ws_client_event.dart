//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSClientEvent {
  /// Returns a new [WSClientEvent] instance.
  WSClientEvent({
    this.connectionId,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? connectionId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WSClientEvent &&
     other.connectionId == connectionId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectionId == null ? 0 : connectionId!.hashCode);

  @override
  String toString() => 'WSClientEvent[connectionId=$connectionId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.connectionId != null) {
      json[r'connection_id'] = this.connectionId;
    } else {
      json[r'connection_id'] = null;
    }
    return json;
  }

  /// Returns a new [WSClientEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WSClientEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WSClientEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WSClientEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WSClientEvent(
        connectionId: mapValueOfType<String>(json, r'connection_id'),
      );
    }
    return null;
  }

  static List<WSClientEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WSClientEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSClientEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WSClientEvent> mapFromJson(dynamic json) {
    final map = <String, WSClientEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSClientEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WSClientEvent-objects as value to a dart map
  static Map<String, List<WSClientEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WSClientEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WSClientEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

