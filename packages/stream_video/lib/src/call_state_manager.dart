import 'action/action.dart';
import 'action/internal/coordinator_action.dart';
import 'action/internal/sfu_action.dart';
import 'call_state.dart';
import 'coordinator/coordinator_socket_listener.dart';
import 'coordinator/models/coordinator_events.dart';
import 'logger/impl/tagged_logger.dart';
import 'logger/stream_log.dart';
import 'middleware/middleware.dart';
import 'middleware/root_middleware.dart';
import 'models/call_metadata.dart';
import 'models/queried_members.dart';
import 'reducer/root_reducer.dart';
import 'sfu/data/events/sfu_events.dart';
import 'state_emitter.dart';
import 'stream_video.dart';
import 'utils/result.dart';

const _tag = 'SV:StateManager';
int _stateSeq = 1;
bool _verbose = false;

abstract class CoordinatorCallEventListener extends CoordinatorEventListener {
  @override
  Future<void> onCoordinatorEvent(CoordinatorCallEvent event);
}

abstract class CallStateManager {
  const CallStateManager();

  StateEmitter<CallState> get state;

  void dispatch(StreamAction action);
}

class CallStateManagerImpl extends CallStateManager {
  CallStateManagerImpl({
    required CallState initialState,
    required List<Middleware> middlewares,
  })  : _state = MutableStateEmitterImpl(initialState),
        _rootReducer = RootReducer() {
    streamLog.i(_tag, () => '<init> initialState: $initialState');
    _rootMiddleware = RootMiddleware(
      getState: () => state.value,
      reduce: _reduce,
      middlewares: middlewares,
    );
  }

  late final _logger = taggedLogger(tag: '$_tag-$_stateSeq');

  final RootReducer _rootReducer;
  final MutableStateEmitter<CallState> _state;
  late final Middleware _rootMiddleware;

  @override
  StateEmitter<CallState> get state => _state;

  @override
  void dispatch(StreamAction action) {
    _logger.d(() => '[dispatch] action: $action');
    _rootMiddleware.dispatch(action);
  }

  void _reduce(StreamAction action) {
    if (_verbose) _logger.v(() => '[reduce] state: ${_state.value}');
    final reduced = _rootReducer.reduce(_state.value, action);
    if (_verbose) _logger.v(() => '[reduce] reduced: $reduced');
    _postState(state: reduced);
  }

  void _postState({required CallState state}) {
    if (state != _state.value) {
      _logger.v(() => '[postState] state: $state');
      _state.value = state;
    }
  }
}

extension on List<CallUser> {
  Map<String, CallUser> toUnmodifiableMap() {
    return Map.unmodifiable(
      <String, CallUser>{
        for (var it in this) it.id: it,
      },
    );
  }
}
