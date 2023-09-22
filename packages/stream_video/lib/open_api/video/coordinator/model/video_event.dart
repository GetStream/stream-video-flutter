//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoEvent {
  /// Returns a new [VideoEvent] instance.
  VideoEvent({
    this.blockedByUser,
    required this.callCid,
    required this.createdAt,
    this.type = 'call.permissions_updated',
    required this.user,
    required this.call,
    required this.hlsPlaylistUrl,
    this.members = const [],
    this.capabilitiesByRole = const {},
    required this.sessionId,
    required this.reaction,
    required this.callRecording,
    required this.participant,
    required this.fromUserId,
    this.mutedUserIds = const [],
    required this.connectionId,
    required this.me,
    required this.error,
    this.custom = const {},
    this.permissions = const [],
    this.ownCapabilities = const [],
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

  /// The type of event: \"call.permissions_updated\" in this case
  String type;

  UserResponse user;

  CallResponse call;

  String hlsPlaylistUrl;

  /// Call members
  List<MemberResponse> members;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  /// Call session ID
  String sessionId;

  ReactionResponse reaction;

  CallRecording callRecording;

  CallParticipantResponse participant;

  String fromUserId;

  List<String> mutedUserIds;

  /// The connection_id for this client
  String connectionId;

  OwnUserResponse me;

  APIError? error;

  /// Custom data for this object
  Map<String, Object> custom;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  @override
  bool operator ==(Object other) => identical(this, other) || other is VideoEvent &&
     other.blockedByUser == blockedByUser &&
     other.callCid == callCid &&
     other.createdAt == createdAt &&
     other.type == type &&
     other.user == user &&
     other.call == call &&
     other.hlsPlaylistUrl == hlsPlaylistUrl &&
     other.members == members &&
     other.capabilitiesByRole == capabilitiesByRole &&
     other.sessionId == sessionId &&
     other.reaction == reaction &&
     other.callRecording == callRecording &&
     other.participant == participant &&
     other.fromUserId == fromUserId &&
     other.mutedUserIds == mutedUserIds &&
     other.connectionId == connectionId &&
     other.me == me &&
     other.error == error &&
     other.custom == custom &&
     other.permissions == permissions &&
     other.ownCapabilities == ownCapabilities;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (blockedByUser == null ? 0 : blockedByUser!.hashCode) +
    (callCid.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (user.hashCode) +
    (call.hashCode) +
    (hlsPlaylistUrl.hashCode) +
    (members.hashCode) +
    (capabilitiesByRole.hashCode) +
    (sessionId.hashCode) +
    (reaction.hashCode) +
    (callRecording.hashCode) +
    (participant.hashCode) +
    (fromUserId.hashCode) +
    (mutedUserIds.hashCode) +
    (connectionId.hashCode) +
    (me.hashCode) +
    (error == null ? 0 : error!.hashCode) +
    (custom.hashCode) +
    (permissions.hashCode) +
    (ownCapabilities.hashCode);

  @override
  String toString() => 'VideoEvent[blockedByUser=$blockedByUser, callCid=$callCid, createdAt=$createdAt, type=$type, user=$user, call=$call, hlsPlaylistUrl=$hlsPlaylistUrl, members=$members, capabilitiesByRole=$capabilitiesByRole, sessionId=$sessionId, reaction=$reaction, callRecording=$callRecording, participant=$participant, fromUserId=$fromUserId, mutedUserIds=$mutedUserIds, connectionId=$connectionId, me=$me, error=$error, custom=$custom, permissions=$permissions, ownCapabilities=$ownCapabilities]';

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
      json[r'hls_playlist_url'] = this.hlsPlaylistUrl;
      json[r'members'] = this.members;
      json[r'capabilities_by_role'] = this.capabilitiesByRole;
      json[r'session_id'] = this.sessionId;
      json[r'reaction'] = this.reaction;
      json[r'call_recording'] = this.callRecording;
      json[r'participant'] = this.participant;
      json[r'from_user_id'] = this.fromUserId;
      json[r'muted_user_ids'] = this.mutedUserIds;
      json[r'connection_id'] = this.connectionId;
      json[r'me'] = this.me;
    if (this.error != null) {
      json[r'error'] = this.error;
    } else {
      json[r'error'] = null;
    }
      json[r'custom'] = this.custom;
      json[r'permissions'] = this.permissions;
      json[r'own_capabilities'] = this.ownCapabilities;
    return json;
  }

  /// Returns a new [VideoEvent] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static VideoEvent? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "VideoEvent[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "VideoEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoEvent(
        blockedByUser: UserResponse.fromJson(json[r'blocked_by_user']),
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', '')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserResponse.fromJson(json[r'user'])!,
        call: CallResponse.fromJson(json[r'call'])!,
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        members: MemberResponse.listFromJson(json[r'members']),
        capabilitiesByRole: json[r'capabilities_by_role'] == null
          ? const {}
            : mapCastOfType<String, List<String>>(json, r'capabilities_by_role') ?? const {},
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        reaction: ReactionResponse.fromJson(json[r'reaction'])!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        fromUserId: mapValueOfType<String>(json, r'from_user_id')!,
        mutedUserIds: json[r'muted_user_ids'] is List
            ? (json[r'muted_user_ids'] as List).cast<String>()
            : const [],
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        me: OwnUserResponse.fromJson(json[r'me'])!,
        error: APIError.fromJson(json[r'error']),
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        permissions: json[r'permissions'] is List
            ? (json[r'permissions'] as List).cast<String>()
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
      );
    }
    return null;
  }

  static List<VideoEvent> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <VideoEvent>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoEvent.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, VideoEvent> mapFromJson(dynamic json) {
    final map = <String, VideoEvent>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = VideoEvent.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of VideoEvent-objects as value to a dart map
  static Map<String, List<VideoEvent>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<VideoEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoEvent.listFromJson(entry.value, growable: growable,);
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
    'hls_playlist_url',
    'members',
    'capabilities_by_role',
    'session_id',
    'reaction',
    'call_recording',
    'participant',
    'from_user_id',
    'muted_user_ids',
    'connection_id',
    'me',
    'error',
    'custom',
    'permissions',
    'own_capabilities',
  };
}

