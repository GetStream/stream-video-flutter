import '../../logger/stream_logger.dart';
import '../action/coordinator_action.dart';
import '../call_state.dart';
import '../coordinator/ws/coordinator_events.dart';
import '../model/call_status.dart';
import '../model/drop_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

class CoordinatorReducer {
  const CoordinatorReducer();

  CallStateV2 reduce(
    CallStateV2 state,
    CoordinatorAction action,
  ) {
    return _reduceCoordinatorEvent(state, action.event);
  }

  CallStateV2 _reduceCoordinatorEvent(
    CallStateV2 state,
    CoordinatorEventV2 event,
  ) {
    if (event is CoordinatorCallRejectedEvent) {
      return _reduceCallRejected(state, event);
    } else if (event is CoordinatorCallAcceptedEvent) {
      return _reduceCallAccepted(state, event);
    } else if (event is CoordinatorCallCancelledEvent) {
      return _reduceCallCancelled(state, event);
    }
    return state;
  }

  CallStateV2 _reduceCallAccepted(
    CallStateV2 state,
    CoordinatorCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(() => '[reduceCallAccepted] rejected (status is not Outgoing)');
      return state;
    }
    if (!state.callParticipants.containsKey(event.sentByUserId)) {
      _logger.w(() => '[reduceCallAccepted] rejected (accepted by non-Member)');
      return state;
    }
    return state.copyWith(
      status: CallStatus.outgoing(acceptedByCallee: true),
    );
  }

  CallStateV2 _reduceCallRejected(
    CallStateV2 state,
    CoordinatorCallRejectedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallRejected] rejected (status is not Active)');
      return state;
    }
    if (!state.callParticipants.containsKey(event.sentByUserId)) {
      _logger.w(() => '[reduceCallAccepted] rejected (accepted by non-Member)');
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.rejected(
          byUserId: event.sentByUserId,
        ),
      ),
    );
  }

  CallStateV2 _reduceCallCancelled(
    CallStateV2 state,
    CoordinatorCallCancelledEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallCancelled] rejected (status is not Active)');
      return state;
    }
    if (!state.callParticipants.containsKey(event.sentByUserId)) {
      _logger.w(
        () => '[reduceCallCancelled] rejected (accepted by non-Member)',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.cancelled(
          byUserId: event.sentByUserId,
        ),
      ),
    );
  }
}
