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
    required this.digit,
    required this.durationMs,
    required this.seqNumber,
    required this.timestamp,
    required this.reason,
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
    required this.recordingType,
    required this.callRecording,
    required this.video,
    required this.name,
    required this.anonymousParticipantCount,
    this.participantsCountByRole = const {},
    required this.participant,
    required this.durationSeconds,
    this.isTrimmed,
    this.participantsOverview = const [],
    required this.error,
    required this.callTranscription,
    required this.rating,
    this.sdk,
    this.sdkVersion,
    required this.fromUserId,
    this.mutedUserIds = const [],
    required this.closedCaption,
    required this.connectionId,
    required this.me,
    this.cid,
    this.code,
    required this.ingressStreamId,
    this.clientIp,
    this.clientName,
    required this.publisherType,
    this.version,
    this.kickedByUser,
    this.permissions = const [],
    this.ownCapabilities = const [],
    this.channelCustom = const {},
    this.channelId,
    this.channelMemberCount,
    this.channelMessageCount,
    this.channelType,
    this.createdBy,
    this.expiration,
    this.shadow,
    this.team,
    this.totalBans,
    required this.deleteConversation,
    required this.deleteConversationChannels,
    required this.deleteMessages,
    required this.deleteUser,
    required this.hardDelete,
    required this.markMessagesDeleted,
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

  /// The DTMF digit (0-9, *, #, A-D)
  String digit;

  /// Duration of the digit press in milliseconds
  int durationMs;

  /// Monotonically increasing sequence number for ordering DTMF events within a session
  int seqNumber;

  /// When the digit press ended and was detected
  DateTime timestamp;

  /// The reason for the ban
  String reason;

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

  /// User who was streaming
  String userId;

  /// The warning message
  String message;

  VideoReactionResponse reaction;

  /// The type of recording
  VideoEventRecordingTypeEnum recordingType;

  CallRecording callRecording;

  bool video;

  /// Name of the given RTMP broadcast
  String name;

  int anonymousParticipantCount;

  Map<String, int> participantsCountByRole;

  CallParticipantResponse participant;

  /// The duration participant was in the session in seconds
  int durationSeconds;

  /// Whether participants_overview is truncated by the server-side limit
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isTrimmed;

  /// Top participant sessions overview
  List<CallStatsParticipant> participantsOverview;

  /// Human-readable error message
  String error;

  CallTranscription callTranscription;

  /// The rating given by the user (1-5)
  int rating;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdk;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? sdkVersion;

  String fromUserId;

  List<String> mutedUserIds;

  CallClosedCaption closedCaption;

  String connectionId;

  OwnUserResponse me;

  /// The CID of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cid;

  /// Error code
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? code;

  /// Unique identifier for the stream
  String ingressStreamId;

  /// Client IP address
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientIp;

  /// Streaming client software name (e.g., 'OBS Studio')
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? clientName;

  /// Streaming protocol (e.g., 'rtmps', 'srt', 'rtmp', 'rtsp')
  String publisherType;

  /// Client software version
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? version;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponse? kickedByUser;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  Map<String, Object> channelCustom;

  /// The ID of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? channelMemberCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? channelMessageCount;

  /// The type of the channel where the target user was unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? channelType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  UserResponseCommonFields? createdBy;

  /// The expiration date of the ban
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiration;

  /// Whether the target user was shadow unbanned
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? shadow;

  /// The team of the channel where the target user was unbanned
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
  int? totalBans;

  /// The type of deletion that was used for the user's conversations. One of: hard, soft, pruning, (empty string)
  String deleteConversation;

  /// Whether the user's conversation channels were deleted
  bool deleteConversationChannels;

  /// The type of deletion that was used for the user's messages. One of: hard, soft, pruning, (empty string)
  String deleteMessages;

  /// The type of deletion that was used for the user. One of: hard, soft, pruning, (empty string)
  String deleteUser;

  /// Whether the user was hard deleted
  bool hardDelete;

  /// Whether the user's messages were marked as deleted
  bool markMessagesDeleted;

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
          other.digit == digit &&
          other.durationMs == durationMs &&
          other.seqNumber == seqNumber &&
          other.timestamp == timestamp &&
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
          other.recordingType == recordingType &&
          other.callRecording == callRecording &&
          other.video == video &&
          other.name == name &&
          other.anonymousParticipantCount == anonymousParticipantCount &&
          _deepEquality.equals(
              other.participantsCountByRole, participantsCountByRole) &&
          other.participant == participant &&
          other.durationSeconds == durationSeconds &&
          other.isTrimmed == isTrimmed &&
          _deepEquality.equals(
              other.participantsOverview, participantsOverview) &&
          other.error == error &&
          other.callTranscription == callTranscription &&
          other.rating == rating &&
          other.sdk == sdk &&
          other.sdkVersion == sdkVersion &&
          other.fromUserId == fromUserId &&
          _deepEquality.equals(other.mutedUserIds, mutedUserIds) &&
          other.closedCaption == closedCaption &&
          other.connectionId == connectionId &&
          other.me == me &&
          other.cid == cid &&
          other.code == code &&
          other.ingressStreamId == ingressStreamId &&
          other.clientIp == clientIp &&
          other.clientName == clientName &&
          other.publisherType == publisherType &&
          other.version == version &&
          other.kickedByUser == kickedByUser &&
          _deepEquality.equals(other.permissions, permissions) &&
          _deepEquality.equals(other.ownCapabilities, ownCapabilities) &&
          _deepEquality.equals(other.channelCustom, channelCustom) &&
          other.channelId == channelId &&
          other.channelMemberCount == channelMemberCount &&
          other.channelMessageCount == channelMessageCount &&
          other.channelType == channelType &&
          other.createdBy == createdBy &&
          other.expiration == expiration &&
          other.shadow == shadow &&
          other.team == team &&
          other.totalBans == totalBans &&
          other.deleteConversation == deleteConversation &&
          other.deleteConversationChannels == deleteConversationChannels &&
          other.deleteMessages == deleteMessages &&
          other.deleteUser == deleteUser &&
          other.hardDelete == hardDelete &&
          other.markMessagesDeleted == markMessagesDeleted;

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
      (digit.hashCode) +
      (durationMs.hashCode) +
      (seqNumber.hashCode) +
      (timestamp.hashCode) +
      (reason.hashCode) +
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
      (recordingType.hashCode) +
      (callRecording.hashCode) +
      (video.hashCode) +
      (name.hashCode) +
      (anonymousParticipantCount.hashCode) +
      (participantsCountByRole.hashCode) +
      (participant.hashCode) +
      (durationSeconds.hashCode) +
      (isTrimmed == null ? 0 : isTrimmed!.hashCode) +
      (participantsOverview.hashCode) +
      (error.hashCode) +
      (callTranscription.hashCode) +
      (rating.hashCode) +
      (sdk == null ? 0 : sdk!.hashCode) +
      (sdkVersion == null ? 0 : sdkVersion!.hashCode) +
      (fromUserId.hashCode) +
      (mutedUserIds.hashCode) +
      (closedCaption.hashCode) +
      (connectionId.hashCode) +
      (me.hashCode) +
      (cid == null ? 0 : cid!.hashCode) +
      (code == null ? 0 : code!.hashCode) +
      (ingressStreamId.hashCode) +
      (clientIp == null ? 0 : clientIp!.hashCode) +
      (clientName == null ? 0 : clientName!.hashCode) +
      (publisherType.hashCode) +
      (version == null ? 0 : version!.hashCode) +
      (kickedByUser == null ? 0 : kickedByUser!.hashCode) +
      (permissions.hashCode) +
      (ownCapabilities.hashCode) +
      (channelCustom.hashCode) +
      (channelId == null ? 0 : channelId!.hashCode) +
      (channelMemberCount == null ? 0 : channelMemberCount!.hashCode) +
      (channelMessageCount == null ? 0 : channelMessageCount!.hashCode) +
      (channelType == null ? 0 : channelType!.hashCode) +
      (createdBy == null ? 0 : createdBy!.hashCode) +
      (expiration == null ? 0 : expiration!.hashCode) +
      (shadow == null ? 0 : shadow!.hashCode) +
      (team == null ? 0 : team!.hashCode) +
      (totalBans == null ? 0 : totalBans!.hashCode) +
      (deleteConversation.hashCode) +
      (deleteConversationChannels.hashCode) +
      (deleteMessages.hashCode) +
      (deleteUser.hashCode) +
      (hardDelete.hashCode) +
      (markMessagesDeleted.hashCode);

  @override
  String toString() =>
      'VideoEvent[app=$app, createdAt=$createdAt, custom=$custom, receivedAt=$receivedAt, type=$type, blockedByUser=$blockedByUser, callCid=$callCid, user=$user, call=$call, members=$members, digit=$digit, durationMs=$durationMs, seqNumber=$seqNumber, timestamp=$timestamp, reason=$reason, egressId=$egressId, capturedAt=$capturedAt, sessionId=$sessionId, trackType=$trackType, url=$url, users=$users, hlsPlaylistUrl=$hlsPlaylistUrl, capabilitiesByRole=$capabilitiesByRole, notifyUser=$notifyUser, userId=$userId, message=$message, reaction=$reaction, recordingType=$recordingType, callRecording=$callRecording, video=$video, name=$name, anonymousParticipantCount=$anonymousParticipantCount, participantsCountByRole=$participantsCountByRole, participant=$participant, durationSeconds=$durationSeconds, isTrimmed=$isTrimmed, participantsOverview=$participantsOverview, error=$error, callTranscription=$callTranscription, rating=$rating, sdk=$sdk, sdkVersion=$sdkVersion, fromUserId=$fromUserId, mutedUserIds=$mutedUserIds, closedCaption=$closedCaption, connectionId=$connectionId, me=$me, cid=$cid, code=$code, ingressStreamId=$ingressStreamId, clientIp=$clientIp, clientName=$clientName, publisherType=$publisherType, version=$version, kickedByUser=$kickedByUser, permissions=$permissions, ownCapabilities=$ownCapabilities, channelCustom=$channelCustom, channelId=$channelId, channelMemberCount=$channelMemberCount, channelMessageCount=$channelMessageCount, channelType=$channelType, createdBy=$createdBy, expiration=$expiration, shadow=$shadow, team=$team, totalBans=$totalBans, deleteConversation=$deleteConversation, deleteConversationChannels=$deleteConversationChannels, deleteMessages=$deleteMessages, deleteUser=$deleteUser, hardDelete=$hardDelete, markMessagesDeleted=$markMessagesDeleted]';

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
    json[r'digit'] = this.digit;
    json[r'duration_ms'] = this.durationMs;
    json[r'seq_number'] = this.seqNumber;
    json[r'timestamp'] = this.timestamp.toUtc().toIso8601String();
    json[r'reason'] = this.reason;
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
    json[r'recording_type'] = this.recordingType;
    json[r'call_recording'] = this.callRecording;
    json[r'video'] = this.video;
    json[r'name'] = this.name;
    json[r'anonymous_participant_count'] = this.anonymousParticipantCount;
    json[r'participants_count_by_role'] = this.participantsCountByRole;
    json[r'participant'] = this.participant;
    json[r'duration_seconds'] = this.durationSeconds;
    if (this.isTrimmed != null) {
      json[r'is_trimmed'] = this.isTrimmed;
    } else {
      json[r'is_trimmed'] = null;
    }
    json[r'participants_overview'] = this.participantsOverview;
    json[r'error'] = this.error;
    json[r'call_transcription'] = this.callTranscription;
    json[r'rating'] = this.rating;
    if (this.sdk != null) {
      json[r'sdk'] = this.sdk;
    } else {
      json[r'sdk'] = null;
    }
    if (this.sdkVersion != null) {
      json[r'sdk_version'] = this.sdkVersion;
    } else {
      json[r'sdk_version'] = null;
    }
    json[r'from_user_id'] = this.fromUserId;
    json[r'muted_user_ids'] = this.mutedUserIds;
    json[r'closed_caption'] = this.closedCaption;
    json[r'connection_id'] = this.connectionId;
    json[r'me'] = this.me;
    if (this.cid != null) {
      json[r'cid'] = this.cid;
    } else {
      json[r'cid'] = null;
    }
    if (this.code != null) {
      json[r'code'] = this.code;
    } else {
      json[r'code'] = null;
    }
    json[r'ingress_stream_id'] = this.ingressStreamId;
    if (this.clientIp != null) {
      json[r'client_ip'] = this.clientIp;
    } else {
      json[r'client_ip'] = null;
    }
    if (this.clientName != null) {
      json[r'client_name'] = this.clientName;
    } else {
      json[r'client_name'] = null;
    }
    json[r'publisher_type'] = this.publisherType;
    if (this.version != null) {
      json[r'version'] = this.version;
    } else {
      json[r'version'] = null;
    }
    if (this.kickedByUser != null) {
      json[r'kicked_by_user'] = this.kickedByUser;
    } else {
      json[r'kicked_by_user'] = null;
    }
    json[r'permissions'] = this.permissions;
    json[r'own_capabilities'] = this.ownCapabilities;
    json[r'channel_custom'] = this.channelCustom;
    if (this.channelId != null) {
      json[r'channel_id'] = this.channelId;
    } else {
      json[r'channel_id'] = null;
    }
    if (this.channelMemberCount != null) {
      json[r'channel_member_count'] = this.channelMemberCount;
    } else {
      json[r'channel_member_count'] = null;
    }
    if (this.channelMessageCount != null) {
      json[r'channel_message_count'] = this.channelMessageCount;
    } else {
      json[r'channel_message_count'] = null;
    }
    if (this.channelType != null) {
      json[r'channel_type'] = this.channelType;
    } else {
      json[r'channel_type'] = null;
    }
    if (this.createdBy != null) {
      json[r'created_by'] = this.createdBy;
    } else {
      json[r'created_by'] = null;
    }
    if (this.expiration != null) {
      json[r'expiration'] = this.expiration!.toUtc().toIso8601String();
    } else {
      json[r'expiration'] = null;
    }
    if (this.shadow != null) {
      json[r'shadow'] = this.shadow;
    } else {
      json[r'shadow'] = null;
    }
    if (this.team != null) {
      json[r'team'] = this.team;
    } else {
      json[r'team'] = null;
    }
    if (this.totalBans != null) {
      json[r'total_bans'] = this.totalBans;
    } else {
      json[r'total_bans'] = null;
    }
    json[r'delete_conversation'] = this.deleteConversation;
    json[r'delete_conversation_channels'] = this.deleteConversationChannels;
    json[r'delete_messages'] = this.deleteMessages;
    json[r'delete_user'] = this.deleteUser;
    json[r'hard_delete'] = this.hardDelete;
    json[r'mark_messages_deleted'] = this.markMessagesDeleted;
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
        assert(json.containsKey(r'app'),
            'Required key "VideoEvent[app]" is missing from JSON.');
        assert(json[r'app'] != null,
            'Required key "VideoEvent[app]" has a null value in JSON.');
        assert(json.containsKey(r'created_at'),
            'Required key "VideoEvent[created_at]" is missing from JSON.');
        assert(json[r'created_at'] != null,
            'Required key "VideoEvent[created_at]" has a null value in JSON.');
        assert(json.containsKey(r'custom'),
            'Required key "VideoEvent[custom]" is missing from JSON.');
        assert(json[r'custom'] != null,
            'Required key "VideoEvent[custom]" has a null value in JSON.');
        assert(json.containsKey(r'type'),
            'Required key "VideoEvent[type]" is missing from JSON.');
        assert(json[r'type'] != null,
            'Required key "VideoEvent[type]" has a null value in JSON.');
        assert(json.containsKey(r'call_cid'),
            'Required key "VideoEvent[call_cid]" is missing from JSON.');
        assert(json[r'call_cid'] != null,
            'Required key "VideoEvent[call_cid]" has a null value in JSON.');
        assert(json.containsKey(r'user'),
            'Required key "VideoEvent[user]" is missing from JSON.');
        assert(json[r'user'] != null,
            'Required key "VideoEvent[user]" has a null value in JSON.');
        assert(json.containsKey(r'call'),
            'Required key "VideoEvent[call]" is missing from JSON.');
        assert(json[r'call'] != null,
            'Required key "VideoEvent[call]" has a null value in JSON.');
        assert(json.containsKey(r'members'),
            'Required key "VideoEvent[members]" is missing from JSON.');
        assert(json[r'members'] != null,
            'Required key "VideoEvent[members]" has a null value in JSON.');
        assert(json.containsKey(r'digit'),
            'Required key "VideoEvent[digit]" is missing from JSON.');
        assert(json[r'digit'] != null,
            'Required key "VideoEvent[digit]" has a null value in JSON.');
        assert(json.containsKey(r'duration_ms'),
            'Required key "VideoEvent[duration_ms]" is missing from JSON.');
        assert(json[r'duration_ms'] != null,
            'Required key "VideoEvent[duration_ms]" has a null value in JSON.');
        assert(json.containsKey(r'seq_number'),
            'Required key "VideoEvent[seq_number]" is missing from JSON.');
        assert(json[r'seq_number'] != null,
            'Required key "VideoEvent[seq_number]" has a null value in JSON.');
        assert(json.containsKey(r'timestamp'),
            'Required key "VideoEvent[timestamp]" is missing from JSON.');
        assert(json[r'timestamp'] != null,
            'Required key "VideoEvent[timestamp]" has a null value in JSON.');
        assert(json.containsKey(r'reason'),
            'Required key "VideoEvent[reason]" is missing from JSON.');
        assert(json[r'reason'] != null,
            'Required key "VideoEvent[reason]" has a null value in JSON.');
        assert(json.containsKey(r'egress_id'),
            'Required key "VideoEvent[egress_id]" is missing from JSON.');
        assert(json[r'egress_id'] != null,
            'Required key "VideoEvent[egress_id]" has a null value in JSON.');
        assert(json.containsKey(r'captured_at'),
            'Required key "VideoEvent[captured_at]" is missing from JSON.');
        assert(json[r'captured_at'] != null,
            'Required key "VideoEvent[captured_at]" has a null value in JSON.');
        assert(json.containsKey(r'session_id'),
            'Required key "VideoEvent[session_id]" is missing from JSON.');
        assert(json[r'session_id'] != null,
            'Required key "VideoEvent[session_id]" has a null value in JSON.');
        assert(json.containsKey(r'track_type'),
            'Required key "VideoEvent[track_type]" is missing from JSON.');
        assert(json[r'track_type'] != null,
            'Required key "VideoEvent[track_type]" has a null value in JSON.');
        assert(json.containsKey(r'url'),
            'Required key "VideoEvent[url]" is missing from JSON.');
        assert(json[r'url'] != null,
            'Required key "VideoEvent[url]" has a null value in JSON.');
        assert(json.containsKey(r'users'),
            'Required key "VideoEvent[users]" is missing from JSON.');
        assert(json[r'users'] != null,
            'Required key "VideoEvent[users]" has a null value in JSON.');
        assert(json.containsKey(r'hls_playlist_url'),
            'Required key "VideoEvent[hls_playlist_url]" is missing from JSON.');
        assert(json[r'hls_playlist_url'] != null,
            'Required key "VideoEvent[hls_playlist_url]" has a null value in JSON.');
        assert(json.containsKey(r'capabilities_by_role'),
            'Required key "VideoEvent[capabilities_by_role]" is missing from JSON.');
        assert(json[r'capabilities_by_role'] != null,
            'Required key "VideoEvent[capabilities_by_role]" has a null value in JSON.');
        assert(json.containsKey(r'notify_user'),
            'Required key "VideoEvent[notify_user]" is missing from JSON.');
        assert(json[r'notify_user'] != null,
            'Required key "VideoEvent[notify_user]" has a null value in JSON.');
        assert(json.containsKey(r'user_id'),
            'Required key "VideoEvent[user_id]" is missing from JSON.');
        assert(json[r'user_id'] != null,
            'Required key "VideoEvent[user_id]" has a null value in JSON.');
        assert(json.containsKey(r'message'),
            'Required key "VideoEvent[message]" is missing from JSON.');
        assert(json[r'message'] != null,
            'Required key "VideoEvent[message]" has a null value in JSON.');
        assert(json.containsKey(r'reaction'),
            'Required key "VideoEvent[reaction]" is missing from JSON.');
        assert(json[r'reaction'] != null,
            'Required key "VideoEvent[reaction]" has a null value in JSON.');
        assert(json.containsKey(r'recording_type'),
            'Required key "VideoEvent[recording_type]" is missing from JSON.');
        assert(json[r'recording_type'] != null,
            'Required key "VideoEvent[recording_type]" has a null value in JSON.');
        assert(json.containsKey(r'call_recording'),
            'Required key "VideoEvent[call_recording]" is missing from JSON.');
        assert(json[r'call_recording'] != null,
            'Required key "VideoEvent[call_recording]" has a null value in JSON.');
        assert(json.containsKey(r'video'),
            'Required key "VideoEvent[video]" is missing from JSON.');
        assert(json[r'video'] != null,
            'Required key "VideoEvent[video]" has a null value in JSON.');
        assert(json.containsKey(r'name'),
            'Required key "VideoEvent[name]" is missing from JSON.');
        assert(json[r'name'] != null,
            'Required key "VideoEvent[name]" has a null value in JSON.');
        assert(json.containsKey(r'anonymous_participant_count'),
            'Required key "VideoEvent[anonymous_participant_count]" is missing from JSON.');
        assert(json[r'anonymous_participant_count'] != null,
            'Required key "VideoEvent[anonymous_participant_count]" has a null value in JSON.');
        assert(json.containsKey(r'participants_count_by_role'),
            'Required key "VideoEvent[participants_count_by_role]" is missing from JSON.');
        assert(json[r'participants_count_by_role'] != null,
            'Required key "VideoEvent[participants_count_by_role]" has a null value in JSON.');
        assert(json.containsKey(r'participant'),
            'Required key "VideoEvent[participant]" is missing from JSON.');
        assert(json[r'participant'] != null,
            'Required key "VideoEvent[participant]" has a null value in JSON.');
        assert(json.containsKey(r'duration_seconds'),
            'Required key "VideoEvent[duration_seconds]" is missing from JSON.');
        assert(json[r'duration_seconds'] != null,
            'Required key "VideoEvent[duration_seconds]" has a null value in JSON.');
        assert(json.containsKey(r'error'),
            'Required key "VideoEvent[error]" is missing from JSON.');
        assert(json[r'error'] != null,
            'Required key "VideoEvent[error]" has a null value in JSON.');
        assert(json.containsKey(r'call_transcription'),
            'Required key "VideoEvent[call_transcription]" is missing from JSON.');
        assert(json[r'call_transcription'] != null,
            'Required key "VideoEvent[call_transcription]" has a null value in JSON.');
        assert(json.containsKey(r'rating'),
            'Required key "VideoEvent[rating]" is missing from JSON.');
        assert(json[r'rating'] != null,
            'Required key "VideoEvent[rating]" has a null value in JSON.');
        assert(json.containsKey(r'from_user_id'),
            'Required key "VideoEvent[from_user_id]" is missing from JSON.');
        assert(json[r'from_user_id'] != null,
            'Required key "VideoEvent[from_user_id]" has a null value in JSON.');
        assert(json.containsKey(r'muted_user_ids'),
            'Required key "VideoEvent[muted_user_ids]" is missing from JSON.');
        assert(json[r'muted_user_ids'] != null,
            'Required key "VideoEvent[muted_user_ids]" has a null value in JSON.');
        assert(json.containsKey(r'closed_caption'),
            'Required key "VideoEvent[closed_caption]" is missing from JSON.');
        assert(json[r'closed_caption'] != null,
            'Required key "VideoEvent[closed_caption]" has a null value in JSON.');
        assert(json.containsKey(r'connection_id'),
            'Required key "VideoEvent[connection_id]" is missing from JSON.');
        assert(json[r'connection_id'] != null,
            'Required key "VideoEvent[connection_id]" has a null value in JSON.');
        assert(json.containsKey(r'me'),
            'Required key "VideoEvent[me]" is missing from JSON.');
        assert(json[r'me'] != null,
            'Required key "VideoEvent[me]" has a null value in JSON.');
        assert(json.containsKey(r'ingress_stream_id'),
            'Required key "VideoEvent[ingress_stream_id]" is missing from JSON.');
        assert(json[r'ingress_stream_id'] != null,
            'Required key "VideoEvent[ingress_stream_id]" has a null value in JSON.');
        assert(json.containsKey(r'publisher_type'),
            'Required key "VideoEvent[publisher_type]" is missing from JSON.');
        assert(json[r'publisher_type'] != null,
            'Required key "VideoEvent[publisher_type]" has a null value in JSON.');
        assert(json.containsKey(r'permissions'),
            'Required key "VideoEvent[permissions]" is missing from JSON.');
        assert(json[r'permissions'] != null,
            'Required key "VideoEvent[permissions]" has a null value in JSON.');
        assert(json.containsKey(r'own_capabilities'),
            'Required key "VideoEvent[own_capabilities]" is missing from JSON.');
        assert(json[r'own_capabilities'] != null,
            'Required key "VideoEvent[own_capabilities]" has a null value in JSON.');
        assert(json.containsKey(r'delete_conversation'),
            'Required key "VideoEvent[delete_conversation]" is missing from JSON.');
        assert(json[r'delete_conversation'] != null,
            'Required key "VideoEvent[delete_conversation]" has a null value in JSON.');
        assert(json.containsKey(r'delete_conversation_channels'),
            'Required key "VideoEvent[delete_conversation_channels]" is missing from JSON.');
        assert(json[r'delete_conversation_channels'] != null,
            'Required key "VideoEvent[delete_conversation_channels]" has a null value in JSON.');
        assert(json.containsKey(r'delete_messages'),
            'Required key "VideoEvent[delete_messages]" is missing from JSON.');
        assert(json[r'delete_messages'] != null,
            'Required key "VideoEvent[delete_messages]" has a null value in JSON.');
        assert(json.containsKey(r'delete_user'),
            'Required key "VideoEvent[delete_user]" is missing from JSON.');
        assert(json[r'delete_user'] != null,
            'Required key "VideoEvent[delete_user]" has a null value in JSON.');
        assert(json.containsKey(r'hard_delete'),
            'Required key "VideoEvent[hard_delete]" is missing from JSON.');
        assert(json[r'hard_delete'] != null,
            'Required key "VideoEvent[hard_delete]" has a null value in JSON.');
        assert(json.containsKey(r'mark_messages_deleted'),
            'Required key "VideoEvent[mark_messages_deleted]" is missing from JSON.');
        assert(json[r'mark_messages_deleted'] != null,
            'Required key "VideoEvent[mark_messages_deleted]" has a null value in JSON.');
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
        digit: mapValueOfType<String>(json, r'digit')!,
        durationMs: mapValueOfType<int>(json, r'duration_ms')!,
        seqNumber: mapValueOfType<int>(json, r'seq_number')!,
        timestamp: mapDateTime(json, r'timestamp', r'')!,
        reason: mapValueOfType<String>(json, r'reason')!,
        egressId: mapValueOfType<String>(json, r'egress_id')!,
        capturedAt: mapDateTime(json, r'captured_at', r'')!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        trackType: mapValueOfType<String>(json, r'track_type')!,
        url: mapValueOfType<String>(json, r'url')!,
        users: UserResponse.mapFromJson(json[r'users']),
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        capabilitiesByRole: json[r'capabilities_by_role'] == null
            ? const {}
            : (json[r'capabilities_by_role'] as Map<String, dynamic>).map(
                (k, v) => MapEntry(k,
                    v == null ? const <String>[] : (v as List).cast<String>())),
        notifyUser: mapValueOfType<bool>(json, r'notify_user')!,
        userId: mapValueOfType<String>(json, r'user_id')!,
        message: mapValueOfType<String>(json, r'message')!,
        reaction: VideoReactionResponse.fromJson(json[r'reaction'])!,
        recordingType:
            VideoEventRecordingTypeEnum.fromJson(json[r'recording_type'])!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        video: mapValueOfType<bool>(json, r'video')!,
        name: mapValueOfType<String>(json, r'name')!,
        anonymousParticipantCount:
            mapValueOfType<int>(json, r'anonymous_participant_count')!,
        participantsCountByRole:
            mapCastOfType<String, int>(json, r'participants_count_by_role')!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        durationSeconds: mapValueOfType<int>(json, r'duration_seconds')!,
        isTrimmed: mapValueOfType<bool>(json, r'is_trimmed'),
        participantsOverview:
            CallStatsParticipant.listFromJson(json[r'participants_overview']),
        error: mapValueOfType<String>(json, r'error')!,
        callTranscription:
            CallTranscription.fromJson(json[r'call_transcription'])!,
        rating: mapValueOfType<int>(json, r'rating')!,
        sdk: mapValueOfType<String>(json, r'sdk'),
        sdkVersion: mapValueOfType<String>(json, r'sdk_version'),
        fromUserId: mapValueOfType<String>(json, r'from_user_id')!,
        mutedUserIds: json[r'muted_user_ids'] is Iterable
            ? (json[r'muted_user_ids'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        closedCaption: CallClosedCaption.fromJson(json[r'closed_caption'])!,
        connectionId: mapValueOfType<String>(json, r'connection_id')!,
        me: OwnUserResponse.fromJson(json[r'me'])!,
        cid: mapValueOfType<String>(json, r'cid'),
        code: mapValueOfType<String>(json, r'code'),
        ingressStreamId: mapValueOfType<String>(json, r'ingress_stream_id')!,
        clientIp: mapValueOfType<String>(json, r'client_ip'),
        clientName: mapValueOfType<String>(json, r'client_name'),
        publisherType: mapValueOfType<String>(json, r'publisher_type')!,
        version: mapValueOfType<String>(json, r'version'),
        kickedByUser: UserResponse.fromJson(json[r'kicked_by_user']),
        permissions: json[r'permissions'] is Iterable
            ? (json[r'permissions'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
        channelCustom:
            mapCastOfType<String, Object>(json, r'channel_custom') ?? const {},
        channelId: mapValueOfType<String>(json, r'channel_id'),
        channelMemberCount: mapValueOfType<int>(json, r'channel_member_count'),
        channelMessageCount:
            mapValueOfType<int>(json, r'channel_message_count'),
        channelType: mapValueOfType<String>(json, r'channel_type'),
        createdBy: UserResponseCommonFields.fromJson(json[r'created_by']),
        expiration: mapDateTime(json, r'expiration', r''),
        shadow: mapValueOfType<bool>(json, r'shadow'),
        team: mapValueOfType<String>(json, r'team'),
        totalBans: mapValueOfType<int>(json, r'total_bans'),
        deleteConversation:
            mapValueOfType<String>(json, r'delete_conversation')!,
        deleteConversationChannels:
            mapValueOfType<bool>(json, r'delete_conversation_channels')!,
        deleteMessages: mapValueOfType<String>(json, r'delete_messages')!,
        deleteUser: mapValueOfType<String>(json, r'delete_user')!,
        hardDelete: mapValueOfType<bool>(json, r'hard_delete')!,
        markMessagesDeleted:
            mapValueOfType<bool>(json, r'mark_messages_deleted')!,
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
    'digit',
    'duration_ms',
    'seq_number',
    'timestamp',
    'reason',
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
    'recording_type',
    'call_recording',
    'video',
    'name',
    'anonymous_participant_count',
    'participants_count_by_role',
    'participant',
    'duration_seconds',
    'error',
    'call_transcription',
    'rating',
    'from_user_id',
    'muted_user_ids',
    'closed_caption',
    'connection_id',
    'me',
    'ingress_stream_id',
    'publisher_type',
    'permissions',
    'own_capabilities',
    'delete_conversation',
    'delete_conversation_channels',
    'delete_messages',
    'delete_user',
    'hard_delete',
    'mark_messages_deleted',
  };
}

/// The type of recording
class VideoEventRecordingTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const VideoEventRecordingTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const composite = VideoEventRecordingTypeEnum._(r'composite');
  static const individual = VideoEventRecordingTypeEnum._(r'individual');
  static const raw = VideoEventRecordingTypeEnum._(r'raw');

  /// List of all possible values in this [enum][VideoEventRecordingTypeEnum].
  static const values = <VideoEventRecordingTypeEnum>[
    composite,
    individual,
    raw,
  ];

  static VideoEventRecordingTypeEnum? fromJson(dynamic value) =>
      VideoEventRecordingTypeEnumTypeTransformer().decode(value);

  static List<VideoEventRecordingTypeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <VideoEventRecordingTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = VideoEventRecordingTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [VideoEventRecordingTypeEnum] to String,
/// and [decode] dynamic data back to [VideoEventRecordingTypeEnum].
class VideoEventRecordingTypeEnumTypeTransformer {
  factory VideoEventRecordingTypeEnumTypeTransformer() =>
      _instance ??= const VideoEventRecordingTypeEnumTypeTransformer._();

  const VideoEventRecordingTypeEnumTypeTransformer._();

  String encode(VideoEventRecordingTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a VideoEventRecordingTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  VideoEventRecordingTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'composite':
          return VideoEventRecordingTypeEnum.composite;
        case r'individual':
          return VideoEventRecordingTypeEnum.individual;
        case r'raw':
          return VideoEventRecordingTypeEnum.raw;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [VideoEventRecordingTypeEnumTypeTransformer] instance.
  static VideoEventRecordingTypeEnumTypeTransformer? _instance;
}
