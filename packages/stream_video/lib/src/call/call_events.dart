import 'package:equatable/equatable.dart';

import '../../stream_video.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_audio_level.dart';
import '../sfu/data/models/sfu_connection_info.dart';
import '../sfu/sfu_extensions.dart';
import '../shared_emitter.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}

/// Event that is triggered when the call is joined.
class CallJoinedEvent extends CallEvent {
  const CallJoinedEvent({
    required this.participants,
    required this.participantCount,
    required this.anonymousCount,
    required this.startedAt,
  });

  final List<CallParticipantState> participants;
  final int participantCount;
  final int anonymousCount;
  final DateTime startedAt;

  @override
  List<Object> get props =>
      [participants, participantCount, anonymousCount, startedAt];
}

/// Event that is triggered when the connection quality changes for participants
class CallConnectionQualityChangedEvent extends CallEvent {
  const CallConnectionQualityChangedEvent({
    required this.connectionQualityUpdates,
  });

  final List<SfuConnectionQualityInfo> connectionQualityUpdates;

  @override
  List<Object> get props => [connectionQualityUpdates];
}

/// Event that is triggered when the audio levels change for participants
class CallAudioLevelChangedEvent extends CallEvent {
  const CallAudioLevelChangedEvent({
    required this.audioLevels,
  });

  final List<SfuAudioLevel> audioLevels;

  @override
  List<Object> get props => [audioLevels];
}

/// Event that is triggered when a participant joins the call
class CallParticipantJoinedEvent extends CallEvent {
  const CallParticipantJoinedEvent({
    required this.callCid,
    required this.participant,
  });

  final StreamCallCid callCid;
  final CallParticipantState participant;

  @override
  List<Object> get props => [callCid, participant];
}

/// Event that is triggered when a participant leaves the call
class CallParticipantLeftEvent extends CallEvent {
  const CallParticipantLeftEvent({
    required this.callCid,
    required this.participant,
  });

  final StreamCallCid callCid;
  final CallParticipantState participant;

  @override
  List<Object> get props => [callCid, participant];
}

/// Event that is triggered when the dominant speaker changes
class CallDominantSpeakerChangedEvent extends CallEvent {
  const CallDominantSpeakerChangedEvent({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  List<Object> get props => [userId, sessionId];
}

/// Event that is triggered when the call is connected
class CallConnectedEvent extends CallEvent {
  const CallConnectedEvent({
    required this.connectionId,
    required this.userId,
  });

  final String connectionId;
  final String userId;

  @override
  List<Object?> get props => [connectionId, userId];
}

/// Event that is triggered when the call is disconnected
class CallDisconnectedEvent extends CallEvent {
  const CallDisconnectedEvent({
    this.connectionId,
    this.userId,
    this.closeCode,
    this.closeReason,
  });

  final String? connectionId;
  final String? userId;
  final int? closeCode;
  final String? closeReason;

  @override
  List<Object?> get props => [connectionId, userId, closeCode, closeReason];
}

/// Event that is triggered when the call is created and another person is invited to participate.
class CallCreatedEvent extends CallEvent {
  const CallCreatedEvent({
    required this.cid,
    required this.metadata,
    required this.createdAt,
  });

  final StreamCallCid cid;
  final CallMetadata metadata;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        cid,
        createdAt,
        metadata,
      ];
}

/// Event that is triggered when the call is ringing.
class CallRingingEvent extends CallEvent {
  const CallRingingEvent({
    required this.callCid,
    required this.ringing,
    required this.metadata,
    required this.sessionId,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final bool ringing;
  final CallMetadata metadata;
  final String sessionId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        ringing,
        sessionId,
        createdAt,
        metadata,
      ];
}

/// Event that is triggered when the call is updated.
class CallUpdatedEvent extends CallEvent {
  const CallUpdatedEvent({
    required this.callCid,
    required this.metadata,
    required this.capabilitiesByRole,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final CallMetadata metadata;
  final Map<String, List<String>> capabilitiesByRole;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        metadata,
        capabilitiesByRole,
        createdAt,
      ];
}

/// Event that is triggered when the call is ended.
class CallEndedEvent extends CallEvent {
  const CallEndedEvent({
    required this.callCid,
    required this.endedBy,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final CallUser? endedBy;
  final DateTime createdAt;

  String? get endedByUserId => endedBy?.id;

  @override
  List<Object?> get props => [
        callCid,
        endedBy,
        createdAt,
      ];
}

/// Event that is triggered when the call is accepted.
class CallAcceptedEvent extends CallEvent {
  const CallAcceptedEvent({
    required this.callCid,
    required this.acceptedBy,
    required this.createdAt,
  });

  @override
  final StreamCallCid callCid;
  final CallUser acceptedBy;
  final DateTime createdAt;

  String get acceptedByUserId => acceptedBy.id;

  @override
  List<Object?> get props => [
        callCid,
        acceptedBy,
        createdAt,
      ];
}

/// Event that is triggered when the call is rejected.
class CallRejectedEvent extends CallEvent {
  const CallRejectedEvent({
    required this.callCid,
    required this.rejectedBy,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final CallUser rejectedBy;
  final DateTime createdAt;

  String get rejectedByUserId => rejectedBy.id;

  @override
  List<Object?> get props => [
        callCid,
        rejectedBy,
        createdAt,
      ];
}

/// Event that is triggered when there is a permission request for a call.
class CallPermissionRequestEvent extends CallEvent {
  const CallPermissionRequestEvent({
    required this.callCid,
    required this.createdAt,
    required this.permissions,
    required this.user,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final List<CallPermission> permissions;
  final CallUser user;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
        permissions,
        user,
      ];
}

/// Event that is triggered when the permissions are updated for a call.
class CallPermissionsUpdatedEvent extends CallEvent {
  const CallPermissionsUpdatedEvent({
    required this.callCid,
    required this.createdAt,
    required this.ownCapabilities,
    required this.user,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final Iterable<CallPermission> ownCapabilities;
  final CallUser user;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
        ownCapabilities,
        user,
      ];
}

/// Event that is triggered when the recording is started for a call.
class CallRecordingStartedEvent extends CallEvent {
  const CallRecordingStartedEvent({
    required this.callCid,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
      ];
}

/// Event that is triggered when the recording is stopped for a call.
class CallRecordingStoppedEvent extends CallEvent {
  const CallRecordingStoppedEvent({
    required this.callCid,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
      ];
}

/// Event that is triggered when the broadcasting is started for a call.
class CallBroadcastingStartedEvent extends CallEvent {
  const CallBroadcastingStartedEvent({
    required this.callCid,
    required this.hlsPlaylistUrl,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final String hlsPlaylistUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        hlsPlaylistUrl,
        createdAt,
      ];
}

/// Event that is triggered when the broadcasting is stopped for a call.
class CallBroadcastingStoppedEvent extends CallEvent {
  const CallBroadcastingStoppedEvent({
    required this.callCid,
    required this.createdAt,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
      ];
}

/// Event that is triggered when the user is blocked in a call.
class CallUserBlockedEvent extends CallEvent {
  const CallUserBlockedEvent({
    required this.callCid,
    required this.createdAt,
    required this.user,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [callCid, createdAt, user];
}

/// Event that is triggered when the user is unblocked in a call.
class CallUserUnblockedEvent extends CallEvent {
  const CallUserUnblockedEvent({
    required this.callCid,
    required this.createdAt,
    required this.user,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [callCid, createdAt, user];
}

/// Event that is triggered when someone sends a reaction during a call
class CallReactionEvent extends CallEvent {
  const CallReactionEvent({
    required this.callCid,
    required this.createdAt,
    required this.reactionType,
    required this.user,
    this.emojiCode,
    this.custom = const {},
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final String reactionType;
  final String? emojiCode;
  final CallUser user;
  final Map<String, Object>? custom;

  @override
  List<Object?> get props => [callCid, createdAt, emojiCode, custom];
}

class CallCustomEvent extends CallEvent {
  const CallCustomEvent({
    required this.callCid,
    required this.senderUserId,
    required this.createdAt,
    required this.eventType,
    required this.users,
    required this.custom,
  });

  final StreamCallCid callCid;
  final String senderUserId;
  final DateTime createdAt;
  final String eventType;
  final Map<String, Object>? custom;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        callCid,
        senderUserId,
        createdAt,
        eventType,
        custom,
        users,
      ];
}

/// Event that is triggered when the new session is started for a call
class CallSessionStartedEvent extends CallEvent {
  const CallSessionStartedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [callCid, createdAt, sessionId, metadata];
}

/// Event that is triggered when the session is ended for a call
class CallSessionEndedEvent extends CallEvent {
  const CallSessionEndedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [callCid, createdAt, sessionId, metadata];
}

/// Event that is triggered when participant joins the call session
class CallSessionParticipantJoinedEvent extends CallEvent {
  const CallSessionParticipantJoinedEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
        sessionId,
        participant,
        user,
      ];
}

/// Event that is triggered when participant leaves the call session
class CallSessionParticipantLeftEvent extends CallEvent {
  const CallSessionParticipantLeftEvent({
    required this.callCid,
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  final StreamCallCid callCid;
  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        callCid,
        createdAt,
        sessionId,
        participant,
        user,
      ];
}

extension CallEventX on CallEvent? {
  void emitIfNotNull(MutableSharedEmitter<CallEvent> emitter) {
    if (this != null) {
      emitter.emit(this!);
    }
  }
}

extension SfuEventX on SfuEvent {
  CallEvent? mapToCallEvent(CallState state) {
    return switch (this) {
      final SfuJoinResponseEvent event => CallJoinedEvent(
          participants: event.callState.participants
              .map((sfuParticipant) => sfuParticipant.toParticipantState(state))
              .toList(),
          participantCount: event.callState.participantCount.total,
          anonymousCount: event.callState.participantCount.anonymous,
          startedAt: event.callState.startedAt,
        ),
      final SfuConnectionQualityChangedEvent event =>
        CallConnectionQualityChangedEvent(
          connectionQualityUpdates: event.connectionQualityUpdates,
        ),
      final SfuAudioLevelChangedEvent event => CallAudioLevelChangedEvent(
          audioLevels: event.audioLevels,
        ),
      final SfuParticipantJoinedEvent event => CallParticipantJoinedEvent(
          callCid: StreamCallCid(cid: event.callCid),
          participant: event.participant.toParticipantState(state),
        ),
      final SfuParticipantLeftEvent event => CallParticipantLeftEvent(
          callCid: StreamCallCid(cid: event.callCid),
          participant: event.participant.toParticipantState(state),
        ),
      final SfuDominantSpeakerChangedEvent event =>
        CallDominantSpeakerChangedEvent(
          userId: event.userId,
          sessionId: event.sessionId,
        ),
      // Ignore other events as they are internal to SFU logic
      _ => null,
    };
  }
}

extension CoordinatorCallEventX on CoordinatorCallEvent {
  CallEvent? mapToCallEvent() {
    return switch (this) {
      final CoordinatorConnectedEvent event => CallConnectedEvent(
          connectionId: event.connectionId,
          userId: event.userId,
        ),
      final CoordinatorDisconnectedEvent event => CallDisconnectedEvent(
          connectionId: event.connectionId,
          userId: event.userId,
          closeCode: event.closeCode,
          closeReason: event.closeReason,
        ),
      final CoordinatorCallCreatedEvent event => CallCreatedEvent(
          cid: event.callCid,
          metadata: event.metadata,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRingingEvent event => CallRingingEvent(
          callCid: event.callCid,
          ringing: event.ringing,
          metadata: event.metadata,
          sessionId: event.sessionId,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUpdatedEvent event => CallUpdatedEvent(
          callCid: event.callCid,
          metadata: event.metadata,
          capabilitiesByRole: event.capabilitiesByRole,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallEndedEvent event => CallEndedEvent(
          callCid: event.callCid,
          endedBy: event.endedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallAcceptedEvent event => CallAcceptedEvent(
          callCid: event.callCid,
          acceptedBy: event.acceptedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRejectedEvent event => CallRejectedEvent(
          callCid: event.callCid,
          rejectedBy: event.rejectedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallPermissionRequestEvent event =>
        CallPermissionRequestEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          permissions: event.permissions,
          user: event.user,
        ),
      final CoordinatorCallPermissionsUpdatedEvent event =>
        CallPermissionsUpdatedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          ownCapabilities: event.ownCapabilities,
          user: event.user,
        ),
      final CoordinatorCallRecordingStartedEvent event =>
        CallRecordingStartedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRecordingStoppedEvent event =>
        CallRecordingStoppedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStartedEvent event =>
        CallBroadcastingStartedEvent(
          callCid: event.callCid,
          hlsPlaylistUrl: event.hlsPlaylistUrl,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStoppedEvent event =>
        CallBroadcastingStoppedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUserBlockedEvent event => CallUserBlockedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallUserUnblockedEvent event => CallUserUnblockedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallReactionEvent event => CallReactionEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          reactionType: event.reactionType,
          user: event.user,
          emojiCode: event.emojiCode,
          custom: event.custom,
        ),
      final CoordinatorCallCustomEvent event => CallCustomEvent(
          callCid: event.callCid,
          senderUserId: event.senderUserId,
          createdAt: event.createdAt,
          eventType: event.eventType,
          users: event.users,
          custom: event.custom,
        ),
      final CoordinatorCallSessionStartedEvent event => CallSessionStartedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionEndedEvent event => CallSessionEndedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionParticipantJoinedEvent event =>
        CallSessionParticipantJoinedEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.user,
          participant: event.participant,
        ),
      final CoordinatorCallSessionParticipantLeftEvent event =>
        CallSessionParticipantLeftEvent(
          callCid: event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.user,
          participant: event.participant,
        ),
      // Ignore other events as they are internal to Coordinator logic
      _ => null,
    };
  }
}
