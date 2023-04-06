//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WSEvent {
  /// Returns a new [WSEvent] instance.
  WSEvent({
    this.blockedByUser,
    required this.callCid,
    required this.createdAt,
    required this.type,
    required this.user,
    required this.call,
    this.members = const [],
    required this.ringing,
    this.capabilitiesByRole = const {},
    required this.reaction,
    this.custom = const {},
    required this.connectionId,
    this.permissions = const [],
    this.ownCapabilities = const [],
    required this.me,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponse? blockedByUser;

  String callCid;

  DateTime createdAt;

  /// The type of event: \"connection.ok\" in this case
  String type;

  UserResponse user;

  CallResponse call;

  /// The list of members that were updated
  List<MemberResponse> members;

  /// true when the call was created with ring enabled
  bool ringing;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  ReactionResponse reaction;

  /// Custom data for this object
  Map<String, Object> custom;

  /// The connection_id for this client
  String connectionId;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  OwnUserResponse me;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WSEvent &&
     other.blockedByUser == blockedByUser &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.type == type &&
     other.user == user &&
     other.call == call &&
     other.members == members &&
     other.ringing == ringing &&
     other.capabilitiesByRole == capabilitiesByRole &&
     other.reaction == reaction &&
     other.custom == custom &&
     other.connectionId == connectionId &&
     other.permissions == permissions &&
     other.ownCapabilities == ownCapabilities &&
     other.me == me;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (blockedByUser == null ? 0 : blockedByUser!.hashCode) +
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (user.hashCode) +
    (call.hashCode) +
    (members.hashCode) +
    (ringing.hashCode) +
    (capabilitiesByRole.hashCode) +
    (reaction.hashCode) +
    (custom.hashCode) +
    (connectionId.hashCode) +
    (permissions.hashCode) +
    (ownCapabilities.hashCode) +
    (me.hashCode);

  @override
  String toString() => 'WSEvent[blockedByUser=$blockedByUser, callCid=$callCid, createdAt=$createdAt, type=$type, user=$user, call=$call, members=$members, ringing=$ringing, capabilitiesByRole=$capabilitiesByRole, reaction=$reaction, custom=$custom, connectionId=$connectionId, permissions=$permissions, ownCapabilities=$ownCapabilities, me=$me]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.blockedByUser != null) {
      json[r'blocked_by_user'] = this.blockedByUser;
    } else {
      json[r'blocked_by_user'] = null;
    }
      json[r'call_cid'] = this.callCid;
      json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
      json[r'type'] = this.type;
      json[r'user'] = this.user;
      json[r'call'] = this.call;
      json[r'members'] = this.members;
      json[r'ringing'] = this.ringing;
      json[r'capabilities_by_role'] = this.capabilitiesByRole;
      json[r'reaction'] = this.reaction;
      json[r'custom'] = this.custom;
      json[r'connection_id'] = this.connectionId;
      json[r'permissions'] = this.permissions;
      json[r'own_capabilities'] = this.ownCapabilities;
      json[r'me'] = this.me;
    return json;
  }

  /// Returns a new [WSEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WSEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WSEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WSEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WSEvent(
        blockedByUser: UserResponse.fromJson(json[r'blocked_by_user']),
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
        call: CallResponse.fromJson(json[r'call'])!,
        members: MemberResponse.listFromJson(json[r'members'])!,
        ringing: mapValueOfType<bool>(json, r'ringing')!,
        capabilitiesByRole: json[r'capabilities_by_role'] == null
          ? const {}
            : mapCastOfType<String, List<String>>(json, r'capabilities_by_role') ?? const {},
        reaction: ReactionResponse.fromJson(json[r'reaction'])!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        permissions: json[r'permissions'] is List
            ? (json[r'permissions'] as List).cast<String>()
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities'])!,
        me: OwnUserResponse.fromJson(json[r'me'])!,
      );
    }
    return null;
  }

  static List<WSEvent>? listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WSEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WSEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WSEvent> mapFromJson(dynamic json) {
    final map = <String, WSEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WSEvent-objects as value to a dart map
  static Map<String, List<WSEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WSEvent>>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WSEvent.listFromJson(entry.value, growable: growable,);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'call_cid',
    'created_at',
    'type',
    'user',
    'call',
    'members',
    'ringing',
    'capabilities_by_role',
    'reaction',
    'custom',
    'connection_id',
    'permissions',
    'own_capabilities',
    'me',
  };
}

