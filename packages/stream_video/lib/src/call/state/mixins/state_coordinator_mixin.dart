import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_egress.dart';
import '../../../models/call_member_state.dart';
import '../../../models/call_metadata.dart';
import '../../../models/call_reaction.dart';
import '../../../models/call_status.dart';
import '../../../models/disconnect_reason.dart';
import '../../../utils/collection_changes.dart';
import '../../call_events.dart';
import '../../call_reject_reason.dart';
import '../../call_ringing_state.dart';

final _logger = taggedLogger(tag: 'SV:CallState:Coordinator');

mixin StateCoordinatorMixin on StateNotifier<CallState> {
  void callMetadataChanged(
    CallMetadata callMetadata, {
    Map<String, List<String>>? capabilitiesByRole,
    bool updateMembers = true,
  }) {
    state = state.copyFromMetadata(
      callMetadata,
      capabilitiesByRole: capabilitiesByRole,
      updateMembers: updateMembers,
    );
  }

  void coordinatorCallAccepted(
    StreamCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(
        () =>
            '[coordinatorUpdateCallAccepted] rejected (status is not Outgoing)',
      );
      return;
    }

    final member = state.callMembers.firstWhereOrNull((member) {
      return member.userId == event.acceptedByUserId;
    });

    if (member == null) {
      _logger.w(
        () =>
            '[coordinatorUpdateCallAccepted] rejected (accepted by non-Member)',
      );

      return;
    }

    final members = state.callMembers.map((m) {
      if (m.userId == event.acceptedByUserId) {
        return m.copyWith(
          callAcceptedAt: event.createdAt,
        );
      } else {
        return m;
      }
    }).toList();

    state = state.copyWith(
      status: CallStatus.outgoing(acceptedByCallee: true),
      callMembers: members,
    );
  }

  void coordinatorCallRejected(
    StreamCallRejectedEvent event,
  ) {
    final status = state.status;
    _logger.d(() => '[coordinatorCallRejected] state: $state');
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRejected] rejected (status is not Active): $status',
      );
      return;
    }

    final members = state.callMembers.map((m) {
      if (m.userId == event.rejectedByUserId) {
        return m.copyWith(
          callRejectedAt: event.createdAt,
        );
      } else {
        return m;
      }
    }).toList();

    // Auto-disconnect on rejection only applies to the ringing flow (call
    // created with `ringing: true`).
    if (!state.isRingingFlow) {
      state = state.copyWith(callMembers: members);
      return;
    }

    final session = event.metadata.session;
    final snapshot = RingingSnapshot(
      creatorId: state.createdByUserId,
      memberIds: state.callMembers.map((m) => m.userId),
      acceptedBy: session.acceptedBy,
      rejectedBy: session.rejectedBy,
      missedBy: session.missedBy,
      // `ended` is left out on purpose. `resolveFor` checks it first, so a
      // cancel that also ended the call would resolve as ended, which this
      // handler leaves to [coordinatorCallEnded], instead of being settled
      // by the rejection that carried it.
    );

    final ringingState = snapshot.resolveFor(state.currentUserId);

    if (ringingState == CallRingingState.rejected &&
        _disconnectRejectedRing(
          byUserId: event.rejectedByUserId,
          reason: _ringRejectReason(snapshot),
          members: members,
        )) {
      return;
    }

    state = state.copyWith(callMembers: members);
  }

  /// Why a ring [RingingSnapshot.resolveFor] reported rejected was rejected.
  CallRejectReason _ringRejectReason(RingingSnapshot snapshot) {
    if (state.createdByMe) {
      return CallRejectReason.allOtherParticipantsRejected();
    }

    if (snapshot.rejectedBy.containsKey(snapshot.creatorId)) {
      return CallRejectReason.creatorRejected();
    }

    final currentUserId = state.currentUserId;
    if (snapshot.rejectedBy.containsKey(currentUserId)) {
      return CallRejectReason.userRespondedElsewhere();
    }

    // The server already timed the ring out for this callee.
    if (snapshot.missedBy.containsKey(currentUserId)) {
      return CallRejectReason.timeout();
    }

    return CallRejectReason.allOtherParticipantsRejected();
  }

  /// Disconnects a ring that resolved as rejected, returning whether it did.
  ///
  /// Shared by the `call.rejected` event and the ring state poller, so both
  /// settle a rejected ring the same way.
  bool _disconnectRejectedRing({
    required String byUserId,
    required CallRejectReason reason,
    required List<CallMemberState> members,
  }) {
    // The caller never tears down a call somebody else is already in.
    if (state.createdByMe && state.otherParticipants.isNotEmpty) {
      _logger.d(
        () =>
            '[disconnectRejectedRing] rejected '
            '(others already in the call): $reason',
      );
      return false;
    }

    _logger.d(() => '[disconnectRejectedRing] reason: $reason');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.rejected(byUserId: byUserId, reason: reason),
      ),
      sessionId: '',
      callParticipants: const [],
      callMembers: members,
    );
    return true;
  }

  /// Applies the outcome of an outgoing ring that was read from the ring state
  /// rather than delivered by a `call.accepted` or `call.rejected` event.
  void coordinatorOutgoingRingResolved(
    CallRingingState ringingState,
    RingingSnapshot snapshot,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing || status.acceptedByCallee) {
      _logger.w(
        () =>
            '[coordinatorOutgoingRingResolved] rejected '
            '(status is not a ringing Outgoing): $status',
      );
      return;
    }

    _logger.d(
      () => '[coordinatorOutgoingRingResolved] ringingState: $ringingState',
    );

    final members = state.callMembers.map((m) {
      return m.copyWith(
        callAcceptedAt: snapshot.acceptedBy[m.userId],
        callRejectedAt: snapshot.rejectedBy[m.userId],
      );
    }).toList();

    switch (ringingState) {
      case CallRingingState.ringing:
        state = state.copyWith(callMembers: members);
      case CallRingingState.accepted:
        state = state.copyWith(
          status: CallStatus.outgoing(acceptedByCallee: true),
          callMembers: members,
        );
      case CallRingingState.rejected:
        final lastRejection = maxBy(
          snapshot.rejectedBy.entries,
          (entry) => entry.value,
        );
        final disconnected = _disconnectRejectedRing(
          byUserId: lastRejection?.key ?? '',
          reason: _ringRejectReason(snapshot),
          members: members,
        );
        if (!disconnected) state = state.copyWith(callMembers: members);
      case CallRingingState.ended:
        state = state.copyWith(
          status: CallStatus.disconnected(DisconnectReason.ended()),
          callParticipants: const [],
          callMembers: members,
        );
    }
  }

  void coordinatorCallEnded(
    StreamCallEndedEvent event,
  ) {
    _logger.i(() => '[coordinatorCallEnded] state: $state');
    final status = state.status;

    if (status is! CallStatusActive) {
      _logger.w(() => '[coordinatorCallEnded] rejected (status is not Active)');
      return;
    }

    if (state.callCid != event.callCid) {
      _logger.w(() => '[coordinatorCallEnded] rejected (invalid cid): $event');
      return;
    }

    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      callParticipants: const [],
    );
  }

  void coordinatorCallPermissionsUpdated(
    StreamCallPermissionsUpdatedEvent event,
  ) {
    if (event.user.id != state.currentUserId) {
      _logger.i(
        () => '[coordinatorCallPermissionsUpdated] rejected (not current user)',
      );
      return;
    }

    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallPermissionsUpdated] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      ownCapabilities: changedOrNull(
        state.ownCapabilities,
        List.unmodifiable(event.ownCapabilities),
      ),
    );
  }

  void coordinatorCallRecordingStarted(
    StreamCallRecordingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRecordingStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: true,
    );
  }

  void coordinatorCallRecordingStopped(
    StreamCallRecordingStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRecordingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: false,
    );
  }

  void coordinatorCallRecordingFailed(
    StreamCallRecordingFailedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRecordingFailed] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: false,
    );
  }

  void coordinatorCallTranscriptionStarted(
    StreamCallTranscriptionStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallTranscriptionStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isTranscribing: true,
    );
  }

  void coordinatorCallTranscriptionStopped(
    StreamCallTranscriptionStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallTranscriptionStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isTranscribing: false,
    );
  }

  void coordinatorCallTranscriptionFailed(
    StreamCallTranscriptionFailedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallTranscriptionFailed] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isTranscribing: false,
    );
  }

  void coordinatorCallClosedCaptionsStarted(
    StreamCallClosedCaptionsStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallClosedCaptionsStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isCaptioning: true,
    );
  }

  void coordinatorCallClosedCaptionsStopped(
    StreamCallClosedCaptionsStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallClosedCaptionsStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isCaptioning: false,
    );
  }

  void coordinatorCallClosedCaptionsFailed(
    StreamCallClosedCaptionsFailedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallClosedCaptionsFailed] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isCaptioning: false,
    );
  }

  void coordinatorCallBroadcastingStarted(
    StreamCallBroadcastingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallBroadcastingStarted] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: true,
    );
  }

  void coordinatorCallBroadcastingStopped(
    StreamCallBroadcastingStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallBroadcastingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: false,
    );
  }

  void coordinatorCallBroadcastingFailed(
    StreamCallBroadcastingFailedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallBroadcastingFailed] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: false,
    );
  }

  void coordinatorCallRtmpBroadcastStarted(
    StreamCallRtmpBroadcastStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRtmpBroadcastStarted] rejected (status is not Active)',
      );
      return;
    }

    final currentRtmps = state.egress.rtmps;
    if (currentRtmps.any((it) => it.name == event.name)) {
      // Already tracked — nothing to do.
      return;
    }

    state = state.copyWith(
      egress: state.egress.copyWith(
        rtmps: [
          ...currentRtmps,
          CallEgressRtmp(name: event.name),
        ],
      ),
    );
  }

  void coordinatorCallRtmpBroadcastStopped(
    StreamCallRtmpBroadcastStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRtmpBroadcastStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      egress: state.egress.copyWith(
        rtmps: state.egress.rtmps.where((it) => it.name != event.name).toList(),
      ),
    );
  }

  void coordinatorCallRtmpBroadcastFailed(
    StreamCallRtmpBroadcastFailedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallRtmpBroadcastFailed] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      egress: state.egress.copyWith(
        rtmps: state.egress.rtmps.where((it) => it.name != event.name).toList(),
      ),
    );
  }

  void coordinatorCallDeleted(
    StreamCallDeletedEvent event,
  ) {
    _logger.i(() => '[coordinatorCallDeleted] state: $state');
    if (state.callCid != event.callCid) {
      _logger.w(
        () => '[coordinatorCallDeleted] rejected (invalid cid): $event',
      );
      return;
    }

    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      callParticipants: const [],
    );
  }

  void coordinatorCallReaction(
    StreamCallReactionEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[coordinatorCallReaction] rejected (status is not Active)',
      );
      return;
    }

    final newParticipants = state.callParticipants.map((e) {
      if (event.user.id == e.userId) {
        return e.copyWith(
          reaction: CallReaction(
            type: event.reactionType,
            user: event.user,
            emojiCode: event.emojiCode,
          ),
        );
      } else {
        return e;
      }
    }).toList();

    state = state.copyWith(
      callParticipants: newParticipants,
    );
  }

  void resetCallReaction(
    String userId,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[resetCallReaction] rejected (status is not Active)',
      );
      return;
    }

    final newParticipants = state.callParticipants.map((e) {
      if (userId == e.userId) {
        return e.copyWithReaction(reaction: null);
      } else {
        return e;
      }
    }).toList();

    state = state.copyWith(
      callParticipants: newParticipants,
    );
  }

  void coordinatorCallMemberAdded(
    StreamCallMemberAddedEvent event,
  ) {
    state = state.copyWith(
      callMembers: [
        ...state.callMembers,
        ...event.members.map(
          (member) {
            final user = event.metadata.users.values.firstWhereOrNull((user) {
              return user.id == member.userId;
            });
            return CallMemberState.fromCallMember(member, user);
          },
        ),
      ],
    );
  }

  void coordinatorCallMemberRemoved(
    StreamCallMemberRemovedEvent event,
  ) {
    state = state.copyWith(
      callMembers: state.callMembers
          .where((member) => !event.removedMemberIds.contains(member.userId))
          .toList(),
    );
  }

  void coordinatorCallMemberUpdated(
    List<CallMember> members, {
    Map<String, List<String>>? capabilitiesByRole,
  }) {
    final callMembers = state.callMembers.map((member) {
      final updatedMember = members.firstWhereOrNull(
        (m) => m.userId == member.userId,
      );
      if (updatedMember != null) {
        return member.copyWith(
          roles: updatedMember.roles,
          custom: updatedMember.custom,
        );
      } else {
        return member;
      }
    }).toList();

    state = state.copyWith(
      callMembers: changedOrNull(state.callMembers, callMembers),
      capabilitiesByRole: changedCapabilitiesByRoleOrNull(
        state.capabilitiesByRole,
        capabilitiesByRole,
      ),
    );
  }

  void coordinatorCallUserBlocked(StreamCallUserBlockedEvent event) {
    state = state.copyWith(
      status: event.user.id == state.currentUserId
          ? CallStatus.disconnected(
              const DisconnectReason.blocked(),
            )
          : null,
      blockedUserIds: [
        ...state.blockedUserIds,
        event.user.id,
      ],
    );
  }

  void coordinatorCallUserUnblocked(StreamCallUserUnblockedEvent event) {
    state = state.copyWith(
      blockedUserIds: state.blockedUserIds
          .where((userId) => userId != event.user.id)
          .toList(),
    );
  }

  void coordinatorCallModerationBlur(
    String userId,
  ) {
    if (userId != state.currentUserId) {
      _logger.i(
        () => '[coordinatorCallModeration] rejected (not current user)',
      );
      return;
    }

    state = state.copyWith(
      isVideoModerated: true,
    );
  }

  void clearModerationBlur() {
    _logger.i(() => '[clearModerationBlur]');
    state = state.copyWith(
      isVideoModerated: false,
    );
  }
}
