import 'package:equatable/equatable.dart';

import '../../stream_video.dart';
import '../sfu/data/events/sfu_events.dart';
import '../sfu/data/models/sfu_audio_level.dart';
import '../sfu/data/models/sfu_call_grants.dart';
import '../sfu/data/models/sfu_connection_info.dart';
import '../sfu/sfu_extensions.dart';
import '../shared_emitter.dart';

abstract class StreamCallEvent extends Equatable {
  const StreamCallEvent(this.callCid);

  final StreamCallCid callCid;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [callCid];
}

abstract class StreamSfuCallEvent extends StreamCallEvent {
  const StreamSfuCallEvent(super.callCid);
}

/// Event that is triggered when the call is joined.
class StreamCallJoinedEvent extends StreamSfuCallEvent {
  const StreamCallJoinedEvent(
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
class StreamCallConnectionQualityChangedEvent extends StreamSfuCallEvent {
  const StreamCallConnectionQualityChangedEvent(
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
class StreamCallAudioLevelChangedEvent extends StreamSfuCallEvent {
  const StreamCallAudioLevelChangedEvent(
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
class StreamCallParticipantJoinedEvent extends StreamSfuCallEvent {
  const StreamCallParticipantJoinedEvent(
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
class StreamCallParticipantLeftEvent extends StreamSfuCallEvent {
  const StreamCallParticipantLeftEvent(
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
class StreamCallDominantSpeakerChangedEvent extends StreamSfuCallEvent {
  const StreamCallDominantSpeakerChangedEvent(
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

class StreamCallSfuTrackPublishedEvent extends StreamSfuCallEvent {
  const StreamCallSfuTrackPublishedEvent(
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

class StreamCallSfuTrackUnpublishedEvent extends StreamSfuCallEvent {
  const StreamCallSfuTrackUnpublishedEvent(
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

class StreamCallGrantsUpdated extends StreamSfuCallEvent {
  const StreamCallGrantsUpdated(
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
class StreamCallConnectedEvent extends StreamCallEvent {
  const StreamCallConnectedEvent(
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
class StreamCallDisconnectedEvent extends StreamCallEvent {
  const StreamCallDisconnectedEvent(
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
class StreamCallCreatedEvent extends StreamCallEvent {
  const StreamCallCreatedEvent(
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
class StreamCallRingingEvent extends StreamCallEvent {
  const StreamCallRingingEvent(
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
class StreamCallUpdatedEvent extends StreamCallEvent {
  const StreamCallUpdatedEvent(
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
class StreamCallEndedEvent extends StreamCallEvent {
  const StreamCallEndedEvent(
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
class StreamCallAcceptedEvent extends StreamCallEvent {
  const StreamCallAcceptedEvent(
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
class StreamCallRejectedEvent extends StreamCallEvent {
  const StreamCallRejectedEvent(
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
class StreamCallPermissionRequestEvent extends StreamCallEvent {
  const StreamCallPermissionRequestEvent(
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
class StreamCallPermissionsUpdatedEvent extends StreamCallEvent {
  const StreamCallPermissionsUpdatedEvent(
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
class StreamCallRecordingStartedEvent extends StreamCallEvent {
  const StreamCallRecordingStartedEvent(
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
class StreamCallRecordingStoppedEvent extends StreamCallEvent {
  const StreamCallRecordingStoppedEvent(
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
class StreamCallBroadcastingStartedEvent extends StreamCallEvent {
  const StreamCallBroadcastingStartedEvent(
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
class StreamCallBroadcastingStoppedEvent extends StreamCallEvent {
  const StreamCallBroadcastingStoppedEvent(
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
class StreamCallUserBlockedEvent extends StreamCallEvent {
  const StreamCallUserBlockedEvent(
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
class StreamCallUserUnblockedEvent extends StreamCallEvent {
  const StreamCallUserUnblockedEvent(
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
class StreamCallReactionEvent extends StreamCallEvent {
  const StreamCallReactionEvent(
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

class StreamCallCustomEvent extends StreamCallEvent {
  const StreamCallCustomEvent(
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
class StreamCallSessionStartedEvent extends StreamCallEvent {
  const StreamCallSessionStartedEvent(
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
class StreamCallSessionEndedEvent extends StreamCallEvent {
  const StreamCallSessionEndedEvent(
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
class StreamCallSessionParticipantJoinedEvent extends StreamCallEvent {
  const StreamCallSessionParticipantJoinedEvent(
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
class StreamCallSessionParticipantLeftEvent extends StreamCallEvent {
  const StreamCallSessionParticipantLeftEvent(
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

extension StreamCallEventX on StreamCallEvent? {
  void emitIfNotNull(MutableSharedEmitter<StreamCallEvent> emitter) {
    if (this != null) {
      emitter.emit(this!);
    }
  }
}

extension SfuEventX on SfuEvent {
  StreamCallEvent? mapToCallEvent(CallState state) {
    return switch (this) {
      final SfuJoinResponseEvent event => StreamCallJoinedEvent(
          state.callCid,
          participants: event.callState.participants
              .map((sfuParticipant) => sfuParticipant.toParticipantState(state))
              .toList(),
          participantCount: event.callState.participantCount.total,
          anonymousCount: event.callState.participantCount.anonymous,
          startedAt: event.callState.startedAt,
        ),
      final SfuConnectionQualityChangedEvent event =>
        StreamCallConnectionQualityChangedEvent(
          state.callCid,
          connectionQualityUpdates: event.connectionQualityUpdates,
        ),
      final SfuAudioLevelChangedEvent event => StreamCallAudioLevelChangedEvent(
          state.callCid,
          audioLevels: event.audioLevels,
        ),
      final SfuParticipantJoinedEvent event => StreamCallParticipantJoinedEvent(
          state.callCid,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuParticipantLeftEvent event => StreamCallParticipantLeftEvent(
          state.callCid,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuDominantSpeakerChangedEvent event =>
        StreamCallDominantSpeakerChangedEvent(
          state.callCid,
          userId: event.userId,
          sessionId: event.sessionId,
        ),
      final SfuTrackPublishedEvent event => StreamCallSfuTrackPublishedEvent(
          state.callCid,
          userId: event.userId,
          sessionId: event.sessionId,
          trackType: event.trackType,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuTrackUnpublishedEvent event =>
        StreamCallSfuTrackUnpublishedEvent(
          state.callCid,
          userId: event.userId,
          sessionId: event.sessionId,
          trackType: event.trackType,
          participant: event.participant.toParticipantState(state),
        ),
      final SfuCallGrantsUpdated event => StreamCallGrantsUpdated(
          state.callCid,
          currentGrants: event.currentGrants,
          message: event.message,
        ),
      // Ignore other events as they are internal to SFU logic
      _ => null,
    };
  }
}

extension CoordinatorCallEventX on CoordinatorCallEvent {
  StreamCallEvent? mapToCallEvent(CallState state) {
    return switch (this) {
      final CoordinatorConnectedEvent event => StreamCallConnectedEvent(
          state.callCid,
          connectionId: event.connectionId,
          userId: event.userId,
        ),
      final CoordinatorDisconnectedEvent event => StreamCallDisconnectedEvent(
          state.callCid,
          connectionId: event.connectionId,
          userId: event.userId,
          closeCode: event.closeCode,
          closeReason: event.closeReason,
        ),
      final CoordinatorCallCreatedEvent event => StreamCallCreatedEvent(
          event.callCid,
          metadata: event.metadata,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRingingEvent event => StreamCallRingingEvent(
          event.callCid,
          ringing: event.ringing,
          metadata: event.metadata,
          sessionId: event.sessionId,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUpdatedEvent event => StreamCallUpdatedEvent(
          event.callCid,
          metadata: event.metadata,
          capabilitiesByRole: event.capabilitiesByRole,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallEndedEvent event => StreamCallEndedEvent(
          event.callCid,
          endedBy: event.endedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallAcceptedEvent event => StreamCallAcceptedEvent(
          event.callCid,
          acceptedBy: event.acceptedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRejectedEvent event => StreamCallRejectedEvent(
          event.callCid,
          rejectedBy: event.rejectedBy,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallPermissionRequestEvent event =>
        StreamCallPermissionRequestEvent(
          event.callCid,
          createdAt: event.createdAt,
          permissions: event.permissions,
          user: event.user,
        ),
      final CoordinatorCallPermissionsUpdatedEvent event =>
        StreamCallPermissionsUpdatedEvent(
          event.callCid,
          createdAt: event.createdAt,
          ownCapabilities: event.ownCapabilities,
          user: event.user,
        ),
      final CoordinatorCallRecordingStartedEvent event =>
        StreamCallRecordingStartedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallRecordingStoppedEvent event =>
        StreamCallRecordingStoppedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStartedEvent event =>
        StreamCallBroadcastingStartedEvent(
          event.callCid,
          hlsPlaylistUrl: event.hlsPlaylistUrl,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallBroadcastingStoppedEvent event =>
        StreamCallBroadcastingStoppedEvent(
          event.callCid,
          createdAt: event.createdAt,
        ),
      final CoordinatorCallUserBlockedEvent event => StreamCallUserBlockedEvent(
          event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallUserUnblockedEvent event =>
        StreamCallUserUnblockedEvent(
          event.callCid,
          createdAt: event.createdAt,
          user: event.user,
        ),
      final CoordinatorCallReactionEvent event => StreamCallReactionEvent(
          event.callCid,
          createdAt: event.createdAt,
          reactionType: event.reactionType,
          user: event.user,
          emojiCode: event.emojiCode,
          custom: event.custom,
        ),
      final CoordinatorCallCustomEvent event => StreamCallCustomEvent(
          event.callCid,
          senderUserId: event.senderUserId,
          createdAt: event.createdAt,
          eventType: event.eventType,
          users: event.users,
          custom: event.custom,
        ),
      final CoordinatorCallSessionStartedEvent event =>
        StreamCallSessionStartedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionEndedEvent event =>
        StreamCallSessionEndedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          metadata: event.metadata,
        ),
      final CoordinatorCallSessionParticipantJoinedEvent event =>
        StreamCallSessionParticipantJoinedEvent(
          event.callCid,
          createdAt: event.createdAt,
          sessionId: event.sessionId,
          user: event.user,
          participant: event.participant,
        ),
      final CoordinatorCallSessionParticipantLeftEvent event =>
        StreamCallSessionParticipantLeftEvent(
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
