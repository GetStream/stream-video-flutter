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
    this.blockedByUser,
    required this.callCid,
    required this.createdAt,
    this.type = 'user.updated',
    required this.user,
    required this.call,
    this.members = const [],
    required this.hlsPlaylistUrl,
    this.capabilitiesByRole = const {},
    required this.notifyUser,
    required this.sessionId,
    required this.reaction,
    required this.callRecording,
    this.reason,
    required this.video,
    required this.name,
    required this.anonymousParticipantCount,
    this.participantsCountByRole = const {},
    required this.participant,
    required this.durationSeconds,
    required this.callTranscription,
    required this.fromUserId,
    this.mutedUserIds = const [],
    required this.closedCaption,
    required this.connectionId,
    required this.me,
    required this.error,
    this.custom = const {},
    this.cid,
    this.receivedAt,
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

  String type;

  UserEventPayload user;

  CallResponse call;

  /// Call members
  List<MemberResponse> members;

  String hlsPlaylistUrl;

  /// The capabilities by role for this call
  Map<String, List<String>> capabilitiesByRole;

  bool notifyUser;

  /// Call session ID
  String sessionId;

  ReactionResponse reaction;

  CallRecording callRecording;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? reason;

  bool video;

  /// Name of the given RTMP broadcast
  String name;

  int anonymousParticipantCount;

  Map<String, int> participantsCountByRole;

  CallParticipantResponse participant;

  /// The duration participant was in the session in seconds
  int durationSeconds;

  CallTranscription callTranscription;

  String fromUserId;

  List<String> mutedUserIds;

  CallClosedCaption closedCaption;

  String connectionId;

  OwnUserResponse me;

  APIError error;

  /// Custom data for this object
  Map<String, Object> custom;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? cid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? receivedAt;

  /// The list of permissions requested by the user
  List<String> permissions;

  /// The capabilities of the current user
  List<OwnCapability> ownCapabilities;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoEvent &&
          other.blockedByUser == blockedByUser &&
          other.callCid == callCid &&
          other.createdAt == createdAt &&
          other.type == type &&
          other.user == user &&
          other.call == call &&
          _deepEquality.equals(other.members, members) &&
          other.hlsPlaylistUrl == hlsPlaylistUrl &&
          _deepEquality.equals(other.capabilitiesByRole, capabilitiesByRole) &&
          other.notifyUser == notifyUser &&
          other.sessionId == sessionId &&
          other.reaction == reaction &&
          other.callRecording == callRecording &&
          other.reason == reason &&
          other.video == video &&
          other.name == name &&
          other.anonymousParticipantCount == anonymousParticipantCount &&
          _deepEquality.equals(
              other.participantsCountByRole, participantsCountByRole) &&
          other.participant == participant &&
          other.durationSeconds == durationSeconds &&
          other.callTranscription == callTranscription &&
          other.fromUserId == fromUserId &&
          _deepEquality.equals(other.mutedUserIds, mutedUserIds) &&
          other.closedCaption == closedCaption &&
          other.connectionId == connectionId &&
          other.me == me &&
          other.error == error &&
          _deepEquality.equals(other.custom, custom) &&
          other.cid == cid &&
          other.receivedAt == receivedAt &&
          _deepEquality.equals(other.permissions, permissions) &&
          _deepEquality.equals(other.ownCapabilities, ownCapabilities);

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
      (notifyUser.hashCode) +
      (sessionId.hashCode) +
      (reaction.hashCode) +
      (callRecording.hashCode) +
      (reason == null ? 0 : reason!.hashCode) +
      (video.hashCode) +
      (name.hashCode) +
      (anonymousParticipantCount.hashCode) +
      (participantsCountByRole.hashCode) +
      (participant.hashCode) +
      (durationSeconds.hashCode) +
      (callTranscription.hashCode) +
      (fromUserId.hashCode) +
      (mutedUserIds.hashCode) +
      (closedCaption.hashCode) +
      (connectionId.hashCode) +
      (me.hashCode) +
      (error.hashCode) +
      (custom.hashCode) +
      (cid == null ? 0 : cid!.hashCode) +
      (receivedAt == null ? 0 : receivedAt!.hashCode) +
      (permissions.hashCode) +
      (ownCapabilities.hashCode);

  @override
  String toString() =>
      'VideoEvent[blockedByUser=$blockedByUser, callCid=$callCid, createdAt=$createdAt, type=$type, user=$user, call=$call, members=$members, hlsPlaylistUrl=$hlsPlaylistUrl, capabilitiesByRole=$capabilitiesByRole, notifyUser=$notifyUser, sessionId=$sessionId, reaction=$reaction, callRecording=$callRecording, reason=$reason, video=$video, name=$name, anonymousParticipantCount=$anonymousParticipantCount, participantsCountByRole=$participantsCountByRole, participant=$participant, durationSeconds=$durationSeconds, callTranscription=$callTranscription, fromUserId=$fromUserId, mutedUserIds=$mutedUserIds, closedCaption=$closedCaption, connectionId=$connectionId, me=$me, error=$error, custom=$custom, cid=$cid, receivedAt=$receivedAt, permissions=$permissions, ownCapabilities=$ownCapabilities]';

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
    json[r'notify_user'] = this.notifyUser;
    json[r'session_id'] = this.sessionId;
    json[r'reaction'] = this.reaction;
    json[r'call_recording'] = this.callRecording;
    if (this.reason != null) {
      json[r'reason'] = this.reason;
    } else {
      json[r'reason'] = null;
    }
    json[r'video'] = this.video;
    json[r'name'] = this.name;
    json[r'anonymous_participant_count'] = this.anonymousParticipantCount;
    json[r'participants_count_by_role'] = this.participantsCountByRole;
    json[r'participant'] = this.participant;
    json[r'duration_seconds'] = this.durationSeconds;
    json[r'call_transcription'] = this.callTranscription;
    json[r'from_user_id'] = this.fromUserId;
    json[r'muted_user_ids'] = this.mutedUserIds;
    json[r'closed_caption'] = this.closedCaption;
    json[r'connection_id'] = this.connectionId;
    json[r'me'] = this.me;
    json[r'error'] = this.error;
    json[r'custom'] = this.custom;
    if (this.cid != null) {
      json[r'cid'] = this.cid;
    } else {
      json[r'cid'] = null;
    }
    if (this.receivedAt != null) {
      json[r'received_at'] = this.receivedAt!.toUtc().toIso8601String();
    } else {
      json[r'received_at'] = null;
    }
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
          assert(json.containsKey(key),
              'Required key "VideoEvent[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "VideoEvent[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return VideoEvent(
        blockedByUser: UserResponse.fromJson(json[r'blocked_by_user']),
        callCid: mapValueOfType<String>(json, r'call_cid')!,
        createdAt: mapDateTime(json, r'created_at', r'')!,
        type: mapValueOfType<String>(json, r'type')!,
        user: UserEventPayload.fromJson(json[r'user'])!,
        call: CallResponse.fromJson(json[r'call'])!,
        members: MemberResponse.listFromJson(json[r'members']),
        hlsPlaylistUrl: mapValueOfType<String>(json, r'hls_playlist_url')!,
        //MANUAL_EDIT mapCast
        capabilitiesByRole: json[r'capabilities_by_role'] == null
            ? const {}
            : mapCastOfType<String, List<String>>(
                    json, r'capabilities_by_role') ??
                const {},
        notifyUser: mapValueOfType<bool>(json, r'notify_user')!,
        sessionId: mapValueOfType<String>(json, r'session_id')!,
        reaction: ReactionResponse.fromJson(json[r'reaction'])!,
        callRecording: CallRecording.fromJson(json[r'call_recording'])!,
        reason: mapValueOfType<String>(json, r'reason'),
        video: mapValueOfType<bool>(json, r'video')!,
        name: mapValueOfType<String>(json, r'name')!,
        anonymousParticipantCount:
            mapValueOfType<int>(json, r'anonymous_participant_count')!,
        participantsCountByRole:
            mapCastOfType<String, int>(json, r'participants_count_by_role')!,
        participant: CallParticipantResponse.fromJson(json[r'participant'])!,
        durationSeconds: mapValueOfType<int>(json, r'duration_seconds')!,
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
        error: APIError.fromJson(json[r'error'])!,
        custom: mapCastOfType<String, Object>(json, r'custom')!,
        cid: mapValueOfType<String>(json, r'cid'),
        receivedAt: mapDateTime(json, r'received_at', r''),
        permissions: json[r'permissions'] is Iterable
            ? (json[r'permissions'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        ownCapabilities: OwnCapability.listFromJson(json[r'own_capabilities']),
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
    'call_cid',
    'created_at',
    'type',
    'user',
    'call',
    'members',
    'hls_playlist_url',
    'capabilities_by_role',
    'notify_user',
    'session_id',
    'reaction',
    'call_recording',
    'video',
    'name',
    'anonymous_participant_count',
    'participants_count_by_role',
    'participant',
    'duration_seconds',
    'call_transcription',
    'from_user_id',
    'muted_user_ids',
    'closed_caption',
    'connection_id',
    'me',
    'error',
    'custom',
    'permissions',
    'own_capabilities',
  };
}
