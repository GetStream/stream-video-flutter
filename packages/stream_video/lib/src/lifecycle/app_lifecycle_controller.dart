import 'package:meta/meta.dart';

import '../core/client_state.dart';
import '../logger/impl/tagged_logger.dart';
import 'lifecycle_state.dart';

/// Follows the app's lifecycle for the client: records the state, and closes
/// the coordinator connection while the app is in the background with no
/// active call.
///
/// Each call mutes and restores its own media in the background.
@internal
class AppLifecycleController {
  AppLifecycleController({
    required this._state,
    required this._keepConnectionAliveInBackground,
    required this._isConnected,
    required this._closeConnection,
    required this._openConnection,
  });

  final MutableClientState _state;
  final bool Function() _keepConnectionAliveInBackground;
  final bool Function() _isConnected;
  final Future<void> Function() _closeConnection;
  final Future<void> Function() _openConnection;

  final _logger = taggedLogger(tag: 'SV:AppLifecycle');

  /// Whether this closed the connection when the app went to the background.
  bool _closedInBackground = false;

  Future<void> onAppState(LifecycleState state) async {
    _logger.d(() => '[onAppState] state: $state');
    _state.appLifecycleState.value = state;

    if (state.isPaused) {
      if (_state.activeCalls.value.isNotEmpty ||
          _keepConnectionAliveInBackground()) {
        return;
      }

      _logger.i(() => '[onAppState] close connection');
      _closedInBackground = true;
      try {
        await _closeConnection();
      } catch (e, stk) {
        _logger.e(() => '[onAppState] closing the connection failed: $e\n$stk');
      }
    } else if (state.isResumed) {
      // A connection kept open can still have dropped in the background.
      if (!_closedInBackground && _isConnected()) return;

      _logger.i(() => '[onAppState] open connection');
      _closedInBackground = false;
      try {
        await _openConnection();
      } catch (e, stk) {
        _logger.e(() => '[onAppState] opening the connection failed: $e\n$stk');
      }
    }
  }
}
