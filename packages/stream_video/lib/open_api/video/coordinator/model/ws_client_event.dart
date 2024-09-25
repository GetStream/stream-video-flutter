//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSClientEvent {
  /// Returns a new [WSClientEvent] instance.
  WSClientEvent({
    this.cid,
    required this.connectionId,
    required this.createdAt,
    this.me,
    this.receivedAt,
    this.type = 'user.updated',
    required this.user,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cid;

  String connectionId;

  DateTime createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  OwnUserResponse? me;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  String type;

  UserEventPayload user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WSClientEvent &&
    other.cid == cid &&
    other.connectionId == connectionId &&
    other.createdAt == createdAt &&
    other.me == me &&
    other.receivedAt == receivedAt &&
    other.type == type &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (cid == null ? 0 : cid!.hashCode) +
    (connectionId.hashCode) +
    (createdAt.hashCode) +
    (me == null ? 0 : me!.hashCode) +
    (receivedAt == null ? 0 : receivedAt!.hashCode) +
    (type.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'WSClientEvent[cid=$cid, connectionId=$connectionId, createdAt=$createdAt, me=$me, receivedAt=$receivedAt, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.cid != null) {
      json[r'cid'] = this.cid;
    } else {
      json[r'cid'] = null;
    }
      json[r'connection_id'] = this.connectionId;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    if (this.me != null) {
      json[r'me'] = this.me;
    } else {
      json[r'me'] = null;
    }
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
      json[r'type'] = this.type;
      json[r'user'] = this.user;
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
        cid: mapValueOfType<String>(json, r'cid'),
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        me: OwnUserResponse.fromJson(json[r'me']),
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserEventPayload.fromJson(json[r'user'])!,
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
    'connection_id',
    'created_at',
    'type',
    'user',
  };
}

