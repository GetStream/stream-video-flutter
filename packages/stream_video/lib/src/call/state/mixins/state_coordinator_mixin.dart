import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../coordinator/models/coordinator_events.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_metadata.dart';
import '../../../models/call_participant_state.dart';
import '../../../models/call_reaction.dart';
import '../../../models/call_status.dart';
import '../../../models/disconnect_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateCoordinatorMixin on StateNotifier<CallState> {
  void callMetadataChanged(CallMetadata callMetadata) {
    state = state.copyFromMetadata(
      callMetadata,
    );
  }

  void coordinatorCallAccepted(
    CoordinatorCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(
        () =>
            '[coordinatorUpdateCallAccepted] rejected (status is not Outgoing)',
      );
      return;
    }

    final participant = state.callParticipants.firstWhereOrNull((participant) {
      return participant.userId == event.acceptedByUserId;
    });
    if (participant == null) {
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
    CoordinatorCallRejectedEvent event,
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

    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.rejectedByUserId;
    });

    if (participantIndex == -1) {
      _logger.w(
        () => '[coordinatorCallRejected] rejected '
            '(by unknown user): ${event.rejectedByUserId}',
      );
      return;
    }

    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);

    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      state = state
          .copyFromMetadata(
            event.metadata,
          )
          .copyWith(
            status: CallStatus.disconnected(
              DisconnectReason.rejected(
                byUserId: removed.userId,
              ),
            ),
            sessionId: '',
            callParticipants: callParticipants,
          );
    }
    state = state
        .copyFromMetadata(
          event.metadata,
        )
        .copyWith(
          callParticipants: callParticipants,
        );
  }

  void coordinatorCallEnded(
    CoordinatorCallEndedEvent event,
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
    CoordinatorCallPermissionsUpdatedEvent event,
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
    CoordinatorCallRecordingStartedEvent event,
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
    CoordinatorCallRecordingStoppedEvent event,
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
    CoordinatorCallRecordingFailedEvent event,
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
    CoordinatorCallTranscriptionStartedEvent event,
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
    CoordinatorCallTranscriptionStoppedEvent event,
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
    CoordinatorCallTranscriptionFailedEvent event,
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

  void coordinatorCallBroadcastingStarted(
    CoordinatorCallBroadcastingStartedEvent event,
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
    CoordinatorCallBroadcastingStoppedEvent event,
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
    CoordinatorCallBroadcastingFailedEvent event,
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
    CoordinatorCallReactionEvent event,
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
          isPinned: e.isPinned,
          viewportVisibility: e.viewportVisibility,
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
