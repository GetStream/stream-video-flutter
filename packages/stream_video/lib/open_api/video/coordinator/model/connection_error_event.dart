//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConnectionErrorEvent {
  /// Returns a new [ConnectionErrorEvent] instance.
  ConnectionErrorEvent({
    required this.connectionId,
    required this.createdAt,
    required this.error,
    this.type = 'connection.error',
  });

  String connectionId;

  DateTime createdAt;

  APIError? error;

  /// The type of event: \"connection.ok\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectionErrorEvent &&
     other.connectionId == connectionId &&
     other.createdAt == createdAt &&
     other.error == error &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectionId.hashCode) +
    (createdAt.hashCode) +
    (error == null ? 0 : error!.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'ConnectionErrorEvent[connectionId=$connectionId, createdAt=$createdAt, error=$error, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'connection_id'] = this.connectionId;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.error != null) {
      json[r'error'] = this.error;
    } else {
      json[r'error'] = null;
    }
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [ConnectionErrorEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectionErrorEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectionErrorEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectionErrorEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectionErrorEvent(
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        error: APIError.fromJson(json[r'error']),
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<ConnectionErrorEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectionErrorEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectionErrorEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectionErrorEvent> mapFromJson(dynamic json) {
    final map = <String, ConnectionErrorEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectionErrorEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectionErrorEvent-objects as value to a dart map
  static Map<String, List<ConnectionErrorEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectionErrorEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectionErrorEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connection_id',
    'created_at',
    'error',
    'type',
  };
}

