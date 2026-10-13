import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../core/client_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'lifecycle_state.dart';

/// Follows the app's lifecycle for the client: records the state, closes the
/// coordinator connection while the app is in the background, and reopens it
/// when the app comes back.
///
/// The connection stays open in the background while a call is active, or
/// when the options ask to keep it alive. On resume it is reopened when it
/// was closed here or dropped meanwhile. App states are handled one at a
/// time, in order.
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
  final Future<Result<None>> Function() _closeConnection;
  final Future<Result<None>> Function() _openConnection;

  final _logger = taggedLogger(tag: 'SV:AppLifecycle');
  final _lock = Lock();

  /// Whether this closed the connection when the app went to the background.
  bool _closedInBackground = false;

  Future<void> onAppState(LifecycleState state) {
    _logger.d(() => '[onAppState] state: $state');
    _state.appLifecycleState.value = state;

    return _lock.synchronized(() async {
      if (state.isPaused) {
        await _onPaused();
      } else if (state.isResumed) {
        await _onResumed();
      }
    });
  }

  /// Forgets a connection closed in the background, once the user is
  /// disconnected.
  void reset() => _closedInBackground = false;

  Future<void> _onPaused() async {
    if (_state.activeCalls.value.isNotEmpty ||
        _keepConnectionAliveInBackground()) {
      return;
    }

    _logger.i(() => '[onAppState] close connection');
    final result = await _closeConnection();
    if (result case Failure(:final error)) {
      _logger.w(() => '[onAppState] closing the connection failed: $error');
      return;
    }
    _closedInBackground = true;
  }

  Future<void> _onResumed() async {
    // A connection kept open can still have dropped in the background.
    if (!_closedInBackground && _isConnected()) return;

    _logger.i(() => '[onAppState] open connection');
    final result = await _openConnection();
    if (result case Failure(:final error)) {
      _logger.w(() => '[onAppState] opening the connection failed: $error');
    }
    _closedInBackground = false;
  }
}
