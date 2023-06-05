//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ConnectedEvent {
  /// Returns a new [ConnectedEvent] instance.
  ConnectedEvent({
    required this.connectionId,
    required this.createdAt,
    required this.me,
    this.type = 'connection.ok',
  });

  /// The connection_id for this client
  String connectionId;

  DateTime createdAt;

  OwnUserResponse me;

  /// The type of event: \"connection.ok\" in this case
  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConnectedEvent &&
     other.connectionId == connectionId &&
     other.createdAt == createdAt &&
     other.me == me &&
     other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (connectionId.hashCode) +
    (createdAt.hashCode) +
    (me.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'ConnectedEvent[connectionId=$connectionId, createdAt=$createdAt, me=$me, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'connection_id'] = this.connectionId;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'me'] = this.me;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [ConnectedEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConnectedEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ConnectedEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ConnectedEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ConnectedEvent(
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        me: OwnUserResponse.fromJson(json[r'me'])!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<ConnectedEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConnectedEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConnectedEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConnectedEvent> mapFromJson(dynamic json) {
    final map = <String, ConnectedEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConnectedEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConnectedEvent-objects as value to a dart map
  static Map<String, List<ConnectedEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConnectedEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConnectedEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'connection_id',
    'created_at',
    'me',
    'type',
  };
}

