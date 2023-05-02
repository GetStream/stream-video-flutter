import 'action/action.dart';
import 'call_state.dart';
import 'coordinator/coordinator_socket_listener.dart';
import 'coordinator/models/coordinator_events.dart';
import 'logger/impl/tagged_logger.dart';
import 'models/call_preferences.dart';
import 'reducer/call_state_reducer.dart';
import 'state_emitter.dart';
import 'store/store.dart';

const _tag = 'SV:StateManager';
int _stateSeq = 1;
bool _verbose = false;

abstract class CoordinatorCallEventListener extends CoordinatorEventListener {
  @override
  Future<void> onCoordinatorEvent(CoordinatorCallEvent event);
}

class CallStateManager {
  CallStateManager({
    required CallState initialState,
    required List<Middleware<CallState, StreamAction>> middlewares,
    required CallPreferences callPreferences,
  }) : _store = Store(
          CallStateReducer(callPreferences),
          initialState: initialState,
          middlewares: middlewares,
        );

  late final _logger = taggedLogger(tag: '$_tag-$_stateSeq');

  StateEmitter<CallState> get state => _store.state;
  final Store<CallState, StreamAction> _store;

  void dispatch(StreamAction action) {
    _logger.d(() => '[dispatch] action: $action');
    _store.dispatch(action);
  }
}
