//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdatedCallPermissionsEvent {
  /// Returns a new [UpdatedCallPermissionsEvent] instance.
  UpdatedCallPermissionsEvent({
    required this.callCid,
    required this.createdAt,
    this.ownCapabilities = const [],
    this.type = 'call.permissions_updated',
    required this.user,
  });

  String callCid;

  DateTime createdAt;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  /// The type of event: \"call.permissions_updated\" in this case
  String type;

  UserResponse user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdatedCallPermissionsEvent &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.ownCapabilities == ownCapabilities &&
     other.type == type &&
     other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (ownCapabilities.hashCode) +
    (type.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'UpdatedCallPermissionsEvent[callCid=$callCid, createdAt=$createdAt, ownCapabilities=$ownCapabilities, type=$type, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'own_capabilities'] = this.ownCapabilities;
      json[r'type'] = this.type;
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [UpdatedCallPermissionsEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdatedCallPermissionsEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UpdatedCallPermissionsEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UpdatedCallPermissionsEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UpdatedCallPermissionsEvent(
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<UpdatedCallPermissionsEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdatedCallPermissionsEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdatedCallPermissionsEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdatedCallPermissionsEvent> mapFromJson(dynamic json) {
    final map = <String, UpdatedCallPermissionsEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdatedCallPermissionsEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdatedCallPermissionsEvent-objects as value to a dart map
  static Map<String, List<UpdatedCallPermissionsEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdatedCallPermissionsEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdatedCallPermissionsEvent.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'own_capabilities',
    'type',
    'user',
  };
}

