//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

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
    this.type = 'user.updated',
    required this.user,
    required this.call,
    this.members = const [],
    required this.hlsPlaylistUrl,
    this.capabilitiesByRole = const {},
    required this.sessionId,
    required this.reaction,
    required this.callRecording,
    required this.participant,
    required this.callTranscription,
    required this.fromUserId,
    this.mutedUserIds = const [],
    required this.closedCaption,
    required this.connectionId,
    required this.me,
    required this.error,
    this.custom = const {},
    required this.cid,
    this.permissions = const [],
    this.ownCapabilities = const [],
    required this.channelId,
    required this.channelType,
    required this.createdBy,
    this.expiration,
    this.reason,
    required this.shadow,
    this.team,
    required this.deleteConversationChannels,
    required this.hardDelete,
    required this.markMessagesDeleted,
    this.targetUser,
    this.targetUsers = const [],
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

  String type;

  UserObject user;

  CallResponse call;

  /// Call members
  List<MemberResponse> members;

  String hlsPlaylistUrl;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  /// Call session ID
  String sessionId;

  ReactionResponse reaction;

  CallRecording callRecording;

  CallParticipantResponse participant;

  CallTranscription callTranscription;

  String fromUserId;

  List<String> mutedUserIds;

  CallClosedCaption closedCaption;

  String connectionId;

  OwnUser me;

  APIError error;

  /// Custom data for this object
  Map<String, Object> custom;

  String cid;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  String channelId;

  String channelType;

  UserObject createdBy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiration;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  bool shadow;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  bool deleteConversationChannels;

  bool hardDelete;

  bool markMessagesDeleted;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? targetUser;

  List<String> targetUsers;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WSEvent &&
    other.blockedByUser == blockedByUser &&
    other.callCid == callCid &&
    other.createdAt == createdAt &&
    other.type == type &&
    other.user == user &&
    other.call == call &&
    _deepEquality.equals(other.members, members) &&
    other.hlsPlaylistUrl == hlsPlaylistUrl &&
    _deepEquality.equals(other.capabilitiesByRole, capabilitiesByRole) &&
    other.sessionId == sessionId &&
    other.reaction == reaction &&
    other.callRecording == callRecording &&
    other.participant == participant &&
    other.callTranscription == callTranscription &&
    other.fromUserId == fromUserId &&
    _deepEquality.equals(other.mutedUserIds, mutedUserIds) &&
    other.closedCaption == closedCaption &&
    other.connectionId == connectionId &&
    other.me == me &&
    other.error == error &&
    _deepEquality.equals(other.custom, custom) &&
    other.cid == cid &&
    _deepEquality.equals(other.permissions, permissions) &&
    _deepEquality.equals(other.ownCapabilities, ownCapabilities) &&
    other.channelId == channelId &&
    other.channelType == channelType &&
    other.createdBy == createdBy &&
    other.expiration == expiration &&
    other.reason == reason &&
    other.shadow == shadow &&
    other.team == team &&
    other.deleteConversationChannels == deleteConversationChannels &&
    other.hardDelete == hardDelete &&
    other.markMessagesDeleted == markMessagesDeleted &&
    other.targetUser == targetUser &&
    _deepEquality.equals(other.targetUsers, targetUsers);

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
    (hlsPlaylistUrl.hashCode) +
    (capabilitiesByRole.hashCode) +
    (sessionId.hashCode) +
    (reaction.hashCode) +
    (callRecording.hashCode) +
    (participant.hashCode) +
    (callTranscription.hashCode) +
    (fromUserId.hashCode) +
    (mutedUserIds.hashCode) +
    (closedCaption.hashCode) +
    (connectionId.hashCode) +
    (me.hashCode) +
    (error.hashCode) +
    (custom.hashCode) +
    (cid.hashCode) +
    (permissions.hashCode) +
    (ownCapabilities.hashCode) +
    (channelId.hashCode) +
    (channelType.hashCode) +
    (createdBy.hashCode) +
    (expiration == null ? 0 : expiration!.hashCode) +
    (reason == null ? 0 : reason!.hashCode) +
    (shadow.hashCode) +
    (team == null ? 0 : team!.hashCode) +
    (deleteConversationChannels.hashCode) +
    (hardDelete.hashCode) +
    (markMessagesDeleted.hashCode) +
    (targetUser == null ? 0 : targetUser!.hashCode) +
    (targetUsers.hashCode);

  @override
  String toString() => 'WSEvent[blockedByUser=$blockedByUser, callCid=$callCid, createdAt=$createdAt, type=$type, user=$user, call=$call, members=$members, hlsPlaylistUrl=$hlsPlaylistUrl, capabilitiesByRole=$capabilitiesByRole, sessionId=$sessionId, reaction=$reaction, callRecording=$callRecording, participant=$participant, callTranscription=$callTranscription, fromUserId=$fromUserId, mutedUserIds=$mutedUserIds, closedCaption=$closedCaption, connectionId=$connectionId, me=$me, error=$error, custom=$custom, cid=$cid, permissions=$permissions, ownCapabilities=$ownCapabilities, channelId=$channelId, channelType=$channelType, createdBy=$createdBy, expiration=$expiration, reason=$reason, shadow=$shadow, team=$team, deleteConversationChannels=$deleteConversationChannels, hardDelete=$hardDelete, markMessagesDeleted=$markMessagesDeleted, targetUser=$targetUser, targetUsers=$targetUsers]';

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
      json[r'hls_playlist_url'] = this.hlsPlaylistUrl;
      json[r'capabilities_by_role'] = this.capabilitiesByRole;
      json[r'session_id'] = this.sessionId;
      json[r'reaction'] = this.reaction;
      json[r'call_recording'] = this.callRecording;
      json[r'participant'] = this.participant;
      json[r'call_transcription'] = this.callTranscription;
      json[r'from_user_id'] = this.fromUserId;
      json[r'muted_user_ids'] = this.mutedUserIds;
      json[r'closed_caption'] = this.closedCaption;
      json[r'connection_id'] = this.connectionId;
      json[r'me'] = this.me;
      json[r'error'] = this.error;
      json[r'custom'] = this.custom;
      json[r'cid'] = this.cid;
      json[r'permissions'] = this.permissions;
      json[r'own_capabilities'] = this.ownCapabilities;
      json[r'channel_id'] = this.channelId;
      json[r'channel_type'] = this.channelType;
      json[r'created_by'] = this.createdBy;
    if (this.expiration != null) {
      json[r'expiration'] = this.expiration!.toUtc().toIso8601String();
    } else {
      json[r'expiration'] = null;
    }
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
      json[r'shadow'] = this.shadow;
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
      json[r'delete_conversation_channels'] = this.deleteConversationChannels;
      json[r'hard_delete'] = this.hardDelete;
      json[r'mark_messages_deleted'] = this.markMessagesDeleted;
    if (this.targetUser != null) {
      json[r'target_user'] = this.targetUser;
    } else {
      json[r'target_user'] = null;
    }
      json[r'target_users'] = this.targetUsers;
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
        createdAt: mapDateTime(json, r'created_at', r'')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserObject.fromJson(json[r'user'])!,
        call: CallResponse.fromJson(json[r'call'])!,
        members: MemberResponse.listFromJson(json[r'members']),
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        capabilitiesByRole: mapCastOfType<String, List<String>>(json, r'capabilities_by_role') ?? {},
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        reaction: ReactionResponse.fromJson(json[r'reaction'])!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        callTranscription: CallTranscription.fromJson(json[r'call_transcription'])!,
        fromUserId: mapValueOfType<String>(json, r'from_user_id')!,
        mutedUserIds: json[r'muted_user_ids'] is Iterable
            ? (json[r'muted_user_ids'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        closedCaption: CallClosedCaption.fromJson(json[r'closed_caption'])!,
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        me: OwnUser.fromJson(json[r'me'])!,
        error: APIError.fromJson(json[r'error'])!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        cid: mapValueOfType<String>(json, r'cid')!,
        permissions: json[r'permissions'] is Iterable
            ? (json[r'permissions'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
        channelId: mapValueOfType<String>(json, r'channel_id')!,
        channelType: mapValueOfType<String>(json, r'channel_type')!,
        createdBy: UserObject.fromJson(json[r'created_by'])!,
        expiration: mapDateTime(json, r'expiration', r''),
        reason: mapValueOfType<String>(json, r'reason'),
        shadow: mapValueOfType<bool>(json, r'shadow')!,
        team: mapValueOfType<String>(json, r'team'),
        deleteConversationChannels: mapValueOfType<bool>(json, r'delete_conversation_channels')!,
        hardDelete: mapValueOfType<bool>(json, r'hard_delete')!,
        markMessagesDeleted: mapValueOfType<bool>(json, r'mark_messages_deleted')!,
        targetUser: mapValueOfType<String>(json, r'target_user'),
        targetUsers: json[r'target_users'] is Iterable
            ? (json[r'target_users'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<WSEvent> listFromJson(dynamic json, {bool growable = false,}) {
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
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WSEvent.listFromJson(entry.value, growable: growable,);
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
    'hls_playlist_url',
    'capabilities_by_role',
    'session_id',
    'reaction',
    'call_recording',
    'participant',
    'call_transcription',
    'from_user_id',
    'muted_user_ids',
    'closed_caption',
    'connection_id',
    'me',
    'error',
    'custom',
    'cid',
    'permissions',
    'own_capabilities',
    'channel_id',
    'channel_type',
    'created_by',
    'shadow',
    'delete_conversation_channels',
    'hard_delete',
    'mark_messages_deleted',
  };
}

