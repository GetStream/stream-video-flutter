import 'package:equatable/equatable.dart';

import '../../stream_video.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_audio_level.dart';
import '../sfu/data/models/sfu_call_grants.dart';
import '../sfu/data/models/sfu_connection_info.dart';
import '../sfu/sfu_extensions.dart';
import '../shared_emitter.dart';

abstract class CallEvent extends Equatable {
  const CallEvent(this.callCid);

  final StreamCallCid callCid;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [callCid];
}

abstract class SfuCallEvent extends CallEvent {
  const SfuCallEvent(super.callCid);
}

/// Event that is triggered when the call is joined.
class CallJoinedEvent extends SfuCallEvent {
  const CallJoinedEvent(
    super.callCid, {
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
  List<Object?> get props => [
        ...super.props,
        participants,
        participantCount,
        anonymousCount,
        startedAt,
      ];
}

/// Event that is triggered when the connection quality changes for participants
class CallConnectionQualityChangedEvent extends SfuCallEvent {
  const CallConnectionQualityChangedEvent(
    super.callCid, {
    required this.connectionQualityUpdates,
  });

  final List<SfuConnectionQualityInfo> connectionQualityUpdates;

  @override
  List<Object?> get props => [
        ...super.props,
        connectionQualityUpdates,
      ];
}

/// Event that is triggered when the audio levels change for participants
class CallAudioLevelChangedEvent extends SfuCallEvent {
  const CallAudioLevelChangedEvent(
    super.callCid, {
    required this.audioLevels,
  });

  final List<SfuAudioLevel> audioLevels;

  @override
  List<Object?> get props => [
        ...super.props,
        audioLevels,
      ];
}

/// Event that is triggered when a participant joins the call
class CallParticipantJoinedEvent extends SfuCallEvent {
  const CallParticipantJoinedEvent(
    super.callCid, {
    required this.participant,
  });

  final CallParticipantState participant;

  @override
  List<Object?> get props => [
        ...super.props,
        callCid,
        participant,
      ];
}

/// Event that is triggered when a participant leaves the call
class CallParticipantLeftEvent extends SfuCallEvent {
  const CallParticipantLeftEvent(
    super.callCid, {
    required this.participant,
  });

  final CallParticipantState participant;

  @override
  List<Object?> get props => [
        ...super.props,
        callCid,
        participant,
      ];
}

/// Event that is triggered when the dominant speaker changes
class CallDominantSpeakerChangedEvent extends SfuCallEvent {
  const CallDominantSpeakerChangedEvent(
    super.callCid, {
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        sessionId,
      ];
}

class CallSfuTrackPublishedEvent extends SfuCallEvent {
  const CallSfuTrackPublishedEvent(
    super.callCid, {
    required this.userId,
    required this.sessionId,
    required this.trackType,
    required this.participant,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
  final CallParticipantState participant;

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        sessionId,
        trackType,
        participant,
      ];
}

class CallSfuTrackUnpublishedEvent extends SfuCallEvent {
  const CallSfuTrackUnpublishedEvent(
    super.callCid, {
    required this.userId,
    required this.sessionId,
    required this.trackType,
    required this.participant,
  });

  final String userId;
  final String sessionId;
  final SfuTrackType trackType;
  final CallParticipantState participant;

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        sessionId,
        trackType,
        participant,
      ];
}

class CallGrantsUpdated extends SfuCallEvent {
  const CallGrantsUpdated(
    super.callCid, {
    required this.currentGrants,
    required this.message,
  });

  final SfuCallGrants currentGrants;
  final String message;

  @override
  List<Object?> get props => [
        ...super.props,
        currentGrants,
        message,
      ];
}

/// Event that is triggered when the call is connected
class CallConnectedEvent extends CallEvent {
  const CallConnectedEvent(
    super.callCid, {
    required this.connectionId,
    required this.userId,
  });

  final String connectionId;
  final String userId;

  @override
  List<Object?> get props => [
        ...super.props,
        connectionId,
        userId,
      ];
}

/// Event that is triggered when the call is disconnected
class CallDisconnectedEvent extends CallEvent {
  const CallDisconnectedEvent(
    super.callCid, {
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
  List<Object?> get props => [
        ...super.props,
        connectionId,
        userId,
        closeCode,
        closeReason,
      ];
}

/// Event that is triggered when the call is created and another person is invited to participate.
class CallCreatedEvent extends CallEvent {
  const CallCreatedEvent(
    super.callCid, {
    required this.metadata,
    required this.createdAt,
  });

  final CallMetadata metadata;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        metadata,
      ];
}

/// Event that is triggered when the call is ringing.
class CallRingingEvent extends CallEvent {
  const CallRingingEvent(
    super.callCid, {
    required this.ringing,
    required this.metadata,
    required this.sessionId,
    required this.createdAt,
  });

  final bool ringing;
  final CallMetadata metadata;
  final String sessionId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        ringing,
        sessionId,
        createdAt,
        metadata,
      ];
}

/// Event that is triggered when the call is updated.
class CallUpdatedEvent extends CallEvent {
  const CallUpdatedEvent(
    super.callCid, {
    required this.metadata,
    required this.capabilitiesByRole,
    required this.createdAt,
  });

  final CallMetadata metadata;
  final Map<String, List<String>> capabilitiesByRole;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        metadata,
        capabilitiesByRole,
        createdAt,
      ];
}

/// Event that is triggered when the call is ended.
class CallEndedEvent extends CallEvent {
  const CallEndedEvent(
    super.callCid, {
    required this.endedBy,
    required this.createdAt,
  });

  final CallUser? endedBy;
  final DateTime createdAt;

  String? get endedByUserId => endedBy?.id;

  @override
  List<Object?> get props => [
        ...super.props,
        endedBy,
        createdAt,
      ];
}

/// Event that is triggered when the call is accepted.
class CallAcceptedEvent extends CallEvent {
  const CallAcceptedEvent(
    super.callCid, {
    required this.acceptedBy,
    required this.createdAt,
  });

  final CallUser acceptedBy;
  final DateTime createdAt;

  String get acceptedByUserId => acceptedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        acceptedBy,
        createdAt,
      ];
}

/// Event that is triggered when the call is rejected.
class CallRejectedEvent extends CallEvent {
  const CallRejectedEvent(
    super.callCid, {
    required this.rejectedBy,
    required this.createdAt,
  });

  final CallUser rejectedBy;
  final DateTime createdAt;

  String get rejectedByUserId => rejectedBy.id;

  @override
  List<Object?> get props => [
        ...super.props,
        rejectedBy,
        createdAt,
      ];
}

/// Event that is triggered when there is a permission request for a call.
class CallPermissionRequestEvent extends CallEvent {
  const CallPermissionRequestEvent(
    super.callCid, {
    required this.createdAt,
    required this.permissions,
    required this.user,
  });

  final DateTime createdAt;
  final List<CallPermission> permissions;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        permissions,
        user,
      ];
}

/// Event that is triggered when the permissions are updated for a call.
class CallPermissionsUpdatedEvent extends CallEvent {
  const CallPermissionsUpdatedEvent(
    super.callCid, {
    required this.createdAt,
    required this.ownCapabilities,
    required this.user,
  });

  final DateTime createdAt;
  final Iterable<CallPermission> ownCapabilities;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        ownCapabilities,
        user,
      ];
}

/// Event that is triggered when the recording is started for a call.
class CallRecordingStartedEvent extends CallEvent {
  const CallRecordingStartedEvent(
    super.callCid, {
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

/// Event that is triggered when the recording is stopped for a call.
class CallRecordingStoppedEvent extends CallEvent {
  const CallRecordingStoppedEvent(
    super.callCid, {
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

/// Event that is triggered when the broadcasting is started for a call.
class CallBroadcastingStartedEvent extends CallEvent {
  const CallBroadcastingStartedEvent(
    super.callCid, {
    required this.hlsPlaylistUrl,
    required this.createdAt,
  });

  final String hlsPlaylistUrl;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        hlsPlaylistUrl,
        createdAt,
      ];
}

/// Event that is triggered when the broadcasting is stopped for a call.
class CallBroadcastingStoppedEvent extends CallEvent {
  const CallBroadcastingStoppedEvent(
    super.callCid, {
    required this.createdAt,
  });

  final DateTime createdAt;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
      ];
}

/// Event that is triggered when the user is blocked in a call.
class CallUserBlockedEvent extends CallEvent {
  const CallUserBlockedEvent(
    super.callCid, {
    required this.createdAt,
    required this.user,
  });

  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        user,
      ];
}

/// Event that is triggered when the user is unblocked in a call.
class CallUserUnblockedEvent extends CallEvent {
  const CallUserUnblockedEvent(
    super.callCid, {
    required this.createdAt,
    required this.user,
  });

  final DateTime createdAt;
  final CallUser user;

  @override
  List<Object?> get props => [
        ...super.props,
        callCid,
        createdAt,
        user,
      ];
}

/// Event that is triggered when someone sends a reaction during a call
class CallReactionEvent extends CallEvent {
  const CallReactionEvent(
    super.callCid, {
    required this.createdAt,
    required this.reactionType,
    required this.user,
    this.emojiCode,
    this.custom = const {},
  });

  final DateTime createdAt;
  final String reactionType;
  final String? emojiCode;
  final CallUser user;
  final Map<String, Object>? custom;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        emojiCode,
        custom,
      ];
}

class CallCustomEvent extends CallEvent {
  const CallCustomEvent(
    super.callCid, {
    required this.senderUserId,
    required this.createdAt,
    required this.eventType,
    required this.users,
    required this.custom,
  });

  final String senderUserId;
  final DateTime createdAt;
  final String eventType;
  final Map<String, Object>? custom;
  final Map<String, CallUser> users;

  @override
  List<Object?> get props => [
        ...super.props,
        senderUserId,
        createdAt,
        eventType,
        custom,
        users,
      ];
}

/// Event that is triggered when the new session is started for a call
class CallSessionStartedEvent extends CallEvent {
  const CallSessionStartedEvent(
    super.callCid, {
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        sessionId,
        metadata,
      ];
}

/// Event that is triggered when the session is ended for a call
class CallSessionEndedEvent extends CallEvent {
  const CallSessionEndedEvent(
    super.callCid, {
    required this.createdAt,
    required this.sessionId,
    required this.metadata,
  });

  final DateTime createdAt;
  final String sessionId;
  final CallMetadata metadata;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        sessionId,
        metadata,
      ];
}

/// Event that is triggered when participant joins the call session
class CallSessionParticipantJoinedEvent extends CallEvent {
  const CallSessionParticipantJoinedEvent(
    super.callCid, {
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        ...super.props,
        createdAt,
        sessionId,
        participant,
        user,
      ];
}

/// Event that is triggered when participant leaves the call session
class CallSessionParticipantLeftEvent extends CallEvent {
  const CallSessionParticipantLeftEvent(
    super.callCid, {
    required this.createdAt,
    required this.sessionId,
    required this.user,
    required this.participant,
  });

  final DateTime createdAt;
  final String sessionId;
  final CallUser user;
  final CallParticipant participant;

  @override
  List<Object?> get props => [
        ...super.props,
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
          StreamCallCid(cid: state.callId),
          participants: event.callState.participants
              .map((sfuParticipant) => sfuParticipant.toParticipantState(state))
              .toList(),
          participantCount: event.callState.participantCount.total,
          anonymousCount: event.callState.participantCount.anonymous,
          startedAt: event.callState.startedAt,
        ),
      final SfuConnectionQualityChangedEvent event =>
        CallConnectionQualityChangedEvent(
          StreamCallCid(cid: state.callId),
          connectionQualityUpdates: event.connectionQualityUpdates,
        ),
      final SfuAudioLevelChangedEvent event => CallAudioLevelChangedEvent(
          StreamCallCid(cid: state.callId),
          audioLevels: event.audioLevels,
        ),
      final SfuParticipantJoinedEvent event => CallParticipantJoinedEvent(
          StreamCallCid(cid: state.callId),
          participant: event.participant.toParticipantState(state),
        ),
      final SfuParticipantLeftEvent event => CallParticipantLeftEvent(
          StreamCallCid(cid: state.callId),
          participant: event.participant.toParticipantState(state),
        ),
      final SfuDominantSpeakerChangedEvent event =>
        CallDominantSpeakerChangedEvent(
          StreamCallCid(cid: state.callId),
          userId: event.userId,
          sessionId: event.sessionId,
        ),
      final SfuTrackPublishedEvent event => CallSfuTrackPublishedEvent(
          StreamCallCid(cid: state.callId),
          userId: event.userId,
          sessionId: event.sessionId,
          trackType: event.trackType,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuTrackUnpublishedEvent event => CallSfuTrackUnpublishedEvent(
          StreamCallCid(cid: state.callId),
          userId: event.userId,
          sessionId: event.sessionId,
          trackType: event.trackType,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuCallGrantsUpdated event => CallGrantsUpdated(
          StreamCallCid(cid: state.callId),
          currentGrants: event.currentGrants,
          message: event.message,
        ),
      // Ignore other events as they are internal to SFU logic
      _ => null,
    };
  }
}

extension CoordinatorCallEventX on CoordinatorCallEvent {
  CallEvent? mapToCallEvent(CallState state) {
    return switch (this) {
      final CoordinatorConnectedEvent event => CallConnectedEvent(
          StreamCallCid(cid: state.callId),
          connectionId: event.connectionId,
          userId: event.userId,
        ),
      final CoordinatorDisconnectedEvent event => CallDisconnectedEvent(
          StreamCallCid(cid: state.callId),
          connectionId: event.connectionId,
          userId: event.userId,
          closeCode: event.closeCode,
          closeReason: event.closeReason,
        ),
      final CoordinatorCallCreatedEvent event => CallCreatedEvent(
          event.callCid,
          metadata: event.metadata,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRingingEvent event => CallRingingEvent(
          event.callCid,
          ringing: event.ringing,
          metadata: event.metadata,
          sessionId: event.sessionId,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUpdatedEvent event => CallUpdatedEvent(
          event.callCid,
          metadata: event.metadata,
          capabilitiesByRole: event.capabilitiesByRole,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallEndedEvent event => CallEndedEvent(
          event.callCid,
          endedBy: event.endedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallAcceptedEvent event => CallAcceptedEvent(
          event.callCid,
          acceptedBy: event.acceptedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRejectedEvent event => CallRejectedEvent(
          event.callCid,
          rejectedBy: event.rejectedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallPermissionRequestEvent event =>
        CallPermissionRequestEvent(
          event.callCid,
          createdAt: event.createdAt,
          permissions: event.permissions,
          user: event.user,
        ),
      final CoordinatorCallPermissionsUpdatedEvent event =>
        CallPermissionsUpdatedEvent(
          event.callCid,
          createdAt: event.createdAt,
          ownCapabilities: event.ownCapabilities,
          user: event.user,
        ),
      final CoordinatorCallRecordingStartedEvent event =>
        CallRecordingStartedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRecordingStoppedEvent event =>
        CallRecordingStoppedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStartedEvent event =>
        CallBroadcastingStartedEvent(
          event.callCid,
          hlsPlaylistUrl: event.hlsPlaylistUrl,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStoppedEvent event =>
        CallBroadcastingStoppedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUserBlockedEvent event => CallUserBlockedEvent(
          event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallUserUnblockedEvent event => CallUserUnblockedEvent(
          event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallReactionEvent event => CallReactionEvent(
          event.callCid,
          createdAt: event.createdAt,
          reactionType: event.reactionType,
          user: event.user,
          emojiCode: event.emojiCode,
          custom: event.custom,
        ),
      final CoordinatorCallCustomEvent event => CallCustomEvent(
          event.callCid,
          senderUserId: event.senderUserId,
          createdAt: event.createdAt,
          eventType: event.eventType,
          users: event.users,
          custom: event.custom,
        ),
      final CoordinatorCallSessionStartedEvent event => CallSessionStartedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionEndedEvent event => CallSessionEndedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionParticipantJoinedEvent event =>
        CallSessionParticipantJoinedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.user,
          participant: event.participant,
        ),
      final CoordinatorCallSessionParticipantLeftEvent event =>
        CallSessionParticipantLeftEvent(
          event.callCid,
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
