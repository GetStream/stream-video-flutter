//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class VideoEvent {
  /// Returns a new [VideoEvent] instance.
  VideoEvent({
    required this.app,
    required this.createdAt,
    this.custom = const {},
    this.receivedAt,
    this.type = 'user.updated',
    this.blockedByUser,
    required this.callCid,
    required this.user,
    required this.call,
    this.members = const [],
    this.reason,
    required this.egressId,
    required this.capturedAt,
    required this.sessionId,
    required this.trackType,
    required this.url,
    this.users = const {},
    required this.hlsPlaylistUrl,
    this.capabilitiesByRole = const {},
    required this.notifyUser,
    required this.userId,
    required this.message,
    required this.reaction,
    required this.callRecording,
    required this.video,
    required this.name,
    required this.anonymousParticipantCount,
    this.participantsCountByRole = const {},
    required this.participant,
    required this.durationSeconds,
    required this.error,
    required this.callTranscription,
    required this.fromUserId,
    this.mutedUserIds = const [],
    required this.closedCaption,
    required this.connectionId,
    required this.me,
    required this.cid,
    this.permissions = const [],
    this.ownCapabilities = const [],
    required this.channelId,
    required this.channelType,
    required this.createdBy,
    this.expiration,
    required this.shadow,
    this.team,
    this.targetUser,
    this.targetUsers = const [],
  });

  AppEventResponse app;

  /// Date/time of creation
  DateTime createdAt;

  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  /// The type of event: \"user.updated\" in this case
  String type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponse? blockedByUser;

  String callCid;

  UserResponsePrivacyFields user;

  CallResponse call;

  /// Call members
  List<MemberResponse> members;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  String egressId;

  /// The time the frame was captured
  DateTime capturedAt;

  /// Call session ID
  String sessionId;

  /// The type of the track frame was captured from (TRACK_TYPE_VIDEO|TRACK_TYPE_SCREEN_SHARE)
  String trackType;

  /// The URL of the frame
  String url;

  /// The users in the frame
  Map<String, UserResponse> users;

  String hlsPlaylistUrl;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  bool notifyUser;

  String userId;

  String message;

  ReactionResponse reaction;

  CallRecording callRecording;

  bool video;

  /// Name of the given RTMP broadcast
  String name;

  int anonymousParticipantCount;

  Map<String, int> participantsCountByRole;

  CallParticipantResponse participant;

  /// The duration participant was in the session in seconds
  int durationSeconds;

  APIError error;

  CallTranscription callTranscription;

  String fromUserId;

  List<String> mutedUserIds;

  CallClosedCaption closedCaption;

  String connectionId;

  OwnUserResponse me;

  String cid;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  String channelId;

  String channelType;

  User createdBy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiration;

  bool shadow;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? team;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? targetUser;

  List<String> targetUsers;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoEvent &&
          other.app == app &&
          other.createdAt == createdAt &&
          _deepEquality.equals(other.custom, custom) &&
          other.receivedAt == receivedAt &&
          other.type == type &&
          other.blockedByUser == blockedByUser &&
          other.callCid == callCid &&
          other.user == user &&
          other.call == call &&
          _deepEquality.equals(other.members, members) &&
          other.reason == reason &&
          other.egressId == egressId &&
          other.capturedAt == capturedAt &&
          other.sessionId == sessionId &&
          other.trackType == trackType &&
          other.url == url &&
          _deepEquality.equals(other.users, users) &&
          other.hlsPlaylistUrl == hlsPlaylistUrl &&
          _deepEquality.equals(other.capabilitiesByRole, capabilitiesByRole) &&
          other.notifyUser == notifyUser &&
          other.userId == userId &&
          other.message == message &&
          other.reaction == reaction &&
          other.callRecording == callRecording &&
          other.video == video &&
          other.name == name &&
          other.anonymousParticipantCount == anonymousParticipantCount &&
          _deepEquality.equals(
              other.participantsCountByRole, participantsCountByRole) &&
          other.participant == participant &&
          other.durationSeconds == durationSeconds &&
          other.error == error &&
          other.callTranscription == callTranscription &&
          other.fromUserId == fromUserId &&
          _deepEquality.equals(other.mutedUserIds, mutedUserIds) &&
          other.closedCaption == closedCaption &&
          other.connectionId == connectionId &&
          other.me == me &&
          other.cid == cid &&
          _deepEquality.equals(other.permissions, permissions) &&
          _deepEquality.equals(other.ownCapabilities, ownCapabilities) &&
          other.channelId == channelId &&
          other.channelType == channelType &&
          other.createdBy == createdBy &&
          other.expiration == expiration &&
          other.shadow == shadow &&
          other.team == team &&
          other.targetUser == targetUser &&
          _deepEquality.equals(other.targetUsers, targetUsers);

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (app.hashCode) +
      (createdAt.hashCode) +
      (custom.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (type.hashCode) +
      (blockedByUser == null ? 0 : blockedByUser!.hashCode) +
      (callCid.hashCode) +
      (user.hashCode) +
      (call.hashCode) +
      (members.hashCode) +
      (reason == null ? 0 : reason!.hashCode) +
      (egressId.hashCode) +
      (capturedAt.hashCode) +
      (sessionId.hashCode) +
      (trackType.hashCode) +
      (url.hashCode) +
      (users.hashCode) +
      (hlsPlaylistUrl.hashCode) +
      (capabilitiesByRole.hashCode) +
      (notifyUser.hashCode) +
      (userId.hashCode) +
      (message.hashCode) +
      (reaction.hashCode) +
      (callRecording.hashCode) +
      (video.hashCode) +
      (name.hashCode) +
      (anonymousParticipantCount.hashCode) +
      (participantsCountByRole.hashCode) +
      (participant.hashCode) +
      (durationSeconds.hashCode) +
      (error.hashCode) +
      (callTranscription.hashCode) +
      (fromUserId.hashCode) +
      (mutedUserIds.hashCode) +
      (closedCaption.hashCode) +
      (connectionId.hashCode) +
      (me.hashCode) +
      (cid.hashCode) +
      (permissions.hashCode) +
      (ownCapabilities.hashCode) +
      (channelId.hashCode) +
      (channelType.hashCode) +
      (createdBy.hashCode) +
      (expiration == null ? 0 : expiration!.hashCode) +
      (shadow.hashCode) +
      (team == null ? 0 : team!.hashCode) +
      (targetUser == null ? 0 : targetUser!.hashCode) +
      (targetUsers.hashCode);

  @override
  String toString() =>
      'VideoEvent[app=$app, createdAt=$createdAt, custom=$custom, receivedAt=$receivedAt, type=$type, blockedByUser=$blockedByUser, callCid=$callCid, user=$user, call=$call, members=$members, reason=$reason, egressId=$egressId, capturedAt=$capturedAt, sessionId=$sessionId, trackType=$trackType, url=$url, users=$users, hlsPlaylistUrl=$hlsPlaylistUrl, capabilitiesByRole=$capabilitiesByRole, notifyUser=$notifyUser, userId=$userId, message=$message, reaction=$reaction, callRecording=$callRecording, video=$video, name=$name, anonymousParticipantCount=$anonymousParticipantCount, participantsCountByRole=$participantsCountByRole, participant=$participant, durationSeconds=$durationSeconds, error=$error, callTranscription=$callTranscription, fromUserId=$fromUserId, mutedUserIds=$mutedUserIds, closedCaption=$closedCaption, connectionId=$connectionId, me=$me, cid=$cid, permissions=$permissions, ownCapabilities=$ownCapabilities, channelId=$channelId, channelType=$channelType, createdBy=$createdBy, expiration=$expiration, shadow=$shadow, team=$team, targetUser=$targetUser, targetUsers=$targetUsers]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'app'] = this.app;
    json[r'created_at'] = this.createdAt.toUtc().toIso8601String();
    json[r'custom'] = this.custom;
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
    json[r'type'] = this.type;
    if (this.blockedByUser != null) {
      json[r'blocked_by_user'] = this.blockedByUser;
    } else {
      json[r'blocked_by_user'] = null;
    }
    json[r'call_cid'] = this.callCid;
    json[r'user'] = this.user;
    json[r'call'] = this.call;
    json[r'members'] = this.members;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    json[r'egress_id'] = this.egressId;
    json[r'captured_at'] = this.capturedAt.toUtc().toIso8601String();
    json[r'session_id'] = this.sessionId;
    json[r'track_type'] = this.trackType;
    json[r'url'] = this.url;
    json[r'users'] = this.users;
    json[r'hls_playlist_url'] = this.hlsPlaylistUrl;
    json[r'capabilities_by_role'] = this.capabilitiesByRole;
    json[r'notify_user'] = this.notifyUser;
    json[r'user_id'] = this.userId;
    json[r'message'] = this.message;
    json[r'reaction'] = this.reaction;
    json[r'call_recording'] = this.callRecording;
    json[r'video'] = this.video;
    json[r'name'] = this.name;
    json[r'anonymous_participant_count'] = this.anonymousParticipantCount;
    json[r'participants_count_by_role'] = this.participantsCountByRole;
    json[r'participant'] = this.participant;
    json[r'duration_seconds'] = this.durationSeconds;
    json[r'error'] = this.error;
    json[r'call_transcription'] = this.callTranscription;
    json[r'from_user_id'] = this.fromUserId;
    json[r'muted_user_ids'] = this.mutedUserIds;
    json[r'closed_caption'] = this.closedCaption;
    json[r'connection_id'] = this.connectionId;
    json[r'me'] = this.me;
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
    json[r'shadow'] = this.shadow;
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
    if (this.targetUser != null) {
      json[r'target_user'] = this.targetUser;
    } else {
      json[r'target_user'] = null;
    }
    json[r'target_users'] = this.targetUsers;
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
          assert(json.containsKey(key),
              'Required key "VideoEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "VideoEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoEvent(
        app: AppEventResponse.fromJson(json[r'app'])!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        receivedAt: mapDateTime(json, r'received_at', r''),
        type: mapValueOfType<String>(json, r'type')!,
        blockedByUser: UserResponse.fromJson(json[r'blocked_by_user']),
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        user: UserResponsePrivacyFields.fromJson(json[r'user'])!,
        call: CallResponse.fromJson(json[r'call'])!,
        members: MemberResponse.listFromJson(json[r'members']),
        reason: mapValueOfType<String>(json, r'reason'),
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        capturedAt: mapDateTime(json, r'captured_at', r'')!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        trackType: mapValueOfType<String>(json, r'track_type')!,
        url: mapValueOfType<String>(json, r'url')!,
        users: UserResponse.mapFromJson(json[r'users']),
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        //MANUAL_EDIT mapCast
        capabilitiesByRole: json[r'capabilities_by_role'] == null
            ? const {}
            : mapCastOfType<String, List<String>>(
                    json, r'capabilities_by_role') ??
                const {},
        notifyUser: mapValueOfType<bool>(json, r'notify_user')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
        message: mapValueOfType<String>(json, r'message')!,
        reaction: ReactionResponse.fromJson(json[r'reaction'])!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        video: mapValueOfType<bool>(json, r'video')!,
        name: mapValueOfType<String>(json, r'name')!,
        anonymousParticipantCount:
            mapValueOfType<int>(json, r'anonymous_participant_count')!,
        participantsCountByRole:
            mapCastOfType<String, int>(json, r'participants_count_by_role')!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        durationSeconds: mapValueOfType<int>(json, r'duration_seconds')!,
        error: APIError.fromJson(json[r'error'])!,
        callTranscription:
            CallTranscription.fromJson(json[r'call_transcription'])!,
        fromUserId: mapValueOfType<String>(json, r'from_user_id')!,
        mutedUserIds: json[r'muted_user_ids'] is Iterable
            ? (json[r'muted_user_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        closedCaption: CallClosedCaption.fromJson(json[r'closed_caption'])!,
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        me: OwnUserResponse.fromJson(json[r'me'])!,
        cid: mapValueOfType<String>(json, r'cid')!,
        permissions: json[r'permissions'] is Iterable
            ? (json[r'permissions'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
        channelId: mapValueOfType<String>(json, r'channel_id')!,
        channelType: mapValueOfType<String>(json, r'channel_type')!,
        createdBy: User.fromJson(json[r'created_by'])!,
        expiration: mapDateTime(json, r'expiration', r''),
        shadow: mapValueOfType<bool>(json, r'shadow')!,
        team: mapValueOfType<String>(json, r'team'),
        targetUser: mapValueOfType<String>(json, r'target_user'),
        targetUsers: json[r'target_users'] is Iterable
            ? (json[r'target_users'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<VideoEvent> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
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
  static Map<String, List<VideoEvent>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<VideoEvent>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = VideoEvent.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'app',
    'created_at',
    'custom',
    'type',
    'call_cid',
    'user',
    'call',
    'members',
    'egress_id',
    'captured_at',
    'session_id',
    'track_type',
    'url',
    'users',
    'hls_playlist_url',
    'capabilities_by_role',
    'notify_user',
    'user_id',
    'message',
    'reaction',
    'call_recording',
    'video',
    'name',
    'anonymous_participant_count',
    'participants_count_by_role',
    'participant',
    'duration_seconds',
    'error',
    'call_transcription',
    'from_user_id',
    'muted_user_ids',
    'closed_caption',
    'connection_id',
    'me',
    'cid',
    'permissions',
    'own_capabilities',
    'channel_id',
    'channel_type',
    'created_by',
    'shadow',
  };
}
