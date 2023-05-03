import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../action/internal/coordinator_action.dart';
import '../../../call_state.dart';
import '../../../coordinator/models/coordinator_events.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_participant_state.dart';
import '../../../models/call_status.dart';
import '../../../models/disconnect_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

mixin StateCoordinatorMixin on StateNotifier<CallState> {
  void coordinatorUpdateUsers(
    UpdateUsers action,
  ) {
    state = state.copyWith(
      callParticipants: state.callParticipants.map(
        (participant) {
          final user = action.users[participant.userId];
          if (user == null) return participant;
          return participant.copyWith(
            role: user.role,
            name: user.name,
            image: user.image,
          );
        },
      ).toList(),
    );
  }

  void coordinatorUpdateCallAccepted(
    CoordinatorCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(() => '[reduceCallAccepted] rejected (status is not Outgoing)');
      return;
    }
    final participant = state.callParticipants.firstWhereOrNull((participant) {
      return participant.userId == event.acceptedByUserId;
    });
    if (participant == null) {
      _logger.w(() => '[reduceCallAccepted] rejected (accepted by non-Member)');
      return;
    }
    state = state.copyWith(
      status: CallStatus.outgoing(acceptedByCallee: true),
    );
  }

  void coordinatorUpdateCallRejected(
    CoordinatorCallRejectedEvent event,
  ) {
    final status = state.status;
    _logger.d(() => '[reduceCallRejected] state: $state');
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRejected] rejected (status is not Active): $status',
      );
      return;
    }
    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.rejectedByUserId;
    });
    if (participantIndex == -1) {
      _logger.w(
        () => '[reduceCallRejected] rejected '
            '(by unknown user): ${event.rejectedByUserId}',
      );
      return;
    }
    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);
    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      state = state.copyWith(
        status: CallStatus.disconnected(
          DisconnectReason.rejected(
            byUserId: removed.userId,
          ),
        ),
        sessionId: '',
        callParticipants: callParticipants,
      );
    }
    state = state.copyWith(
      callParticipants: callParticipants,
    );
  }

  void coordinatorCallEnded(
    CoordinatorCallEndedEvent event,
  ) {
    _logger.i(() => '[reduceCallCancelled] state: $state');
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallEnded] rejected (status is not Active)');
      return;
    }
    if (state.callCid != event.callCid) {
      _logger.w(() => '[reduceCallEnded] rejected (invalid cid): $event');
      return;
    }
    // final participantIndex = state.callParticipants.indexWhere((participant) {
    //   return participant.userId == event.endedByUserId;
    // });
    // if (participantIndex == -1) {
    //   _logger.w(
    //     () => '[reduceCallEnded] rejected '
    //         '(by unknown user): ${event.endedByUserId}',
    //   );
    //   return state;
    // }
    // final callParticipants = [...state.callParticipants];
    // final removed = callParticipants.removeAt(participantIndex);
    // if (removed.userId == state.currentUserId ||
    //     callParticipants.hasSingle(state.currentUserId)) {
    //   return state.copyWith(
    //     status: CallStatus.disconnected(
    //       DisconnectReason.cancelled(
    //         byUserId: removed.userId,
    //       ),
    //     ),
    //     callParticipants: callParticipants,
    //   );
    // }
    // return state.copyWith(
    //   callParticipants: callParticipants,
    // );

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
        () => '[reduceCallPermissionsUpdated] rejected (status is not Active)',
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
        () => '[reduceCallRecordingStarted] rejected (status is not Active)',
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
        () => '[reduceCallRecordingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isRecording: false,
    );
  }

  void coordinatorCallBroadcastingStarted(
    CoordinatorCallBroadcastingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallBroadcastingStarted] rejected (status is not Active)',
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
        () => '[reduceCallBroadcastingStopped] rejected (status is not Active)',
      );
      return;
    }

    state = state.copyWith(
      isBroadcasting: false,
    );
  }
}

extension on List<CallParticipantState> {
  bool hasSingle(String userId) {
    return length == 1 && firstOrNull?.userId == userId;
  }
}
