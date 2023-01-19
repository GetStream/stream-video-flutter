import '../action/coordinator_action.dart';
import '../call_state.dart';
import '../coordinator/ws/coordinator_events.dart';
import '../model/call_status.dart';

class CoordinatorReducer {
  CoordinatorReducer(this.currentUserId);

  final String currentUserId;

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

  CallStateV2 _reduceCallRejected(
    CallStateV2 state,
    CoordinatorCallRejectedEvent event,
  ) {
    // TODO implement
    return state;
  }

  CallStateV2 _reduceCallAccepted(
    CallStateV2 state,
    CoordinatorCallAcceptedEvent event,
  ) {
    // TODO implement
    return state.copyWith(status: CallStatus.connecting());
  }

  CallStateV2 _reduceCallCancelled(
    CallStateV2 state,
    CoordinatorCallCancelledEvent event,
  ) {
    return state.copyWith(status: CallStatus.idle());
  }
}
