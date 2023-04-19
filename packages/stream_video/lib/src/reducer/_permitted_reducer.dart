import '../action/internal/permitted_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_status.dart';
import '../models/disconnect_reason.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Permitted');

class PermittedReducer {
  const PermittedReducer();

  CallState reduce(
    CallState state,
    PermittedAction action,
  ) {
    if (action is CallEnded) {
      return _reduceCallEnded(state, action);
    }
    return state;
  }

  CallState _reduceCallEnded(
    CallState state,
    CallEnded action,
  ) {
    _logger.i(() => '[reduceCallEnded] action: $action, state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      sessionId: '',
    );
  }
}
