import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_metadata.dart';
import '../../../models/call_participant_state.dart';
import '../../../models/call_reaction.dart';
import '../../../models/call_status.dart';
import '../../../models/disconnect_reason.dart';
import '../../call_events.dart';
import '../../call_reject_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateCoordinatorMixin on StateNotifier<CallState> {
  void callMetadataChanged(
    CallMetadata callMetadata, {
    Map<String, List<String>>? capabilitiesByRole,
  }) {
    state = state.copyFromMetadata(
      callMetadata,
      capabilitiesByRole: capabilitiesByRole,
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

    state = state
        .copyFromMetadata(
          event.metadata,
        )
        .copyWith(
          status: CallStatus.outgoing(acceptedByCallee: true),
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

    final rejectedBy = event.metadata.session.rejectedBy;

    if (state.createdByMe) {
      final everyoneElseRejected = state.callMembers
          .where((m) => m.userId != state.currentUserId)
          .every((m) => rejectedBy.keys.contains(m.userId));

      if (everyoneElseRejected) {
        _logger.d(
            () => '[coordinatorCallRejected] everyone rejected, disconnecting');
        state = state.copyFromMetadata(event.metadata).copyWith(
          status: CallStatus.disconnected(
            DisconnectReason.rejected(
              byUserId: event.rejectedByUserId,
              reason: CallRejectReason.custom('ring: everyone rejected'),
            ),
          ),
          sessionId: '',
          callParticipants: const [],
        );
        return;
      }
    } else {
      if (rejectedBy.keys.contains(state.createdByUserId)) {
        _logger.d(
            () => '[coordinatorCallRejected] creator rejected, disconnecting');
        state = state.copyFromMetadata(event.metadata).copyWith(
          status: CallStatus.disconnected(
            DisconnectReason.rejected(
              byUserId: event.rejectedByUserId,
              reason: CallRejectReason.custom('ring: creator rejected'),
            ),
          ),
          sessionId: '',
          callParticipants: const [],
        );
        return;
      }
    }

    state = state.copyFromMetadata(
      event.metadata,
    );
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
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () =>
            '[coordinatorCallPermissionsUpdated] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      ownCapabilities: List.unmodifiable(
        event.ownCapabilities,
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
        return CallParticipantState(
          userId: e.userId,
          roles: e.roles,
          name: e.name,
          custom: e.custom,
          sessionId: e.sessionId,
          trackIdPrefix: e.trackIdPrefix,
          image: e.image,
          publishedTracks: e.publishedTracks,
          isLocal: e.isLocal,
          connectionQuality: e.connectionQuality,
          isOnline: e.isOnline,
          audioLevel: e.audioLevel,
          isSpeaking: e.isSpeaking,
          isDominantSpeaker: e.isDominantSpeaker,
          viewportVisibility: e.viewportVisibility,
          pin: e.pin,
        );
      } else {
        return e;
      }
    }).toList();

    state = state.copyWith(
      callParticipants: newParticipants,
    );
  }
}

extension on List<CallParticipantState> {
  bool hasSingle(String userId) {
    return length == 1 && firstOrNull?.userId == userId;
  }
}
