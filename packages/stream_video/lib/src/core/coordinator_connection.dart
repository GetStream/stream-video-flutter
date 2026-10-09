import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';
import 'package:synchronized/synchronized.dart';

import '../coordinator/coordinator_client.dart';
import '../coordinator/models/coordinator_events.dart';
import '../errors/stream_video_exception_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/user.dart';
import '../push_notification/push_notification_manager.dart';
import '../token/token_source.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'client_state.dart';
import 'connection_state.dart';

/// Connects the user to the coordinator and disconnects them again, and is
/// the one writer of [MutableClientState.connection].
///
/// Connects and disconnects run one at a time, in the order they were asked
/// for, so the last one asked for decides where the connection ends up.
@internal
class CoordinatorConnection {
  CoordinatorConnection({
    required this._client,
    required this._state,
    required this._tokens,
    required this._pushNotificationManager,
    required this._onConnected,
    required this._onDisconnected,
  });

  final CoordinatorClient _client;
  final MutableClientState _state;
  final TokenSource _tokens;
  final PushNotificationManager? Function() _pushNotificationManager;

  /// Runs once the socket is up, from the connect that opened it.
  final void Function() _onConnected;

  /// Runs on every disconnect, to drop what the connection held.
  final Future<void> Function() _onDisconnected;

  final _logger = taggedLogger(tag: 'SV:CoordinatorConnection');
  final _lock = Lock();

  /// Whether a connect of the current connection registered the push device.
  bool _pushDeviceRegistered = false;
  bool _disposed = false;

  ConnectionState get _connection => _state.connection.value;

  set _connection(ConnectionState newState) {
    final curState = _connection;
    if (curState != newState) {
      _logger.i(() => '[setConnectionState] #client; $newState <= $curState');
      _state.connection.value = newState;
    }
  }

  /// Connects the user.
  ///
  /// A connect while the user is connected opens no second socket and
  /// answers with the current token. One queued behind a connect that failed
  /// tries again itself, with its own [includeUserDetails], which otherwise
  /// only applies to the connect that opens the socket. [registerPushDevice]
  /// registers the device once per connection, so a later connect asking for
  /// it registers a device an earlier one skipped.
  Future<Result<UserToken>> connect({
    required bool includeUserDetails,
    required bool registerPushDevice,
  }) {
    return _lock.synchronized(
      () => _connect(
        includeUserDetails: includeUserDetails,
        registerPushDevice: registerPushDevice,
      ),
    );
  }

  Future<Result<UserToken>> _connect({
    required bool includeUserDetails,
    required bool registerPushDevice,
  }) async {
    _logger.i(() => '[connect] currentUser.id: ${_state.currentUser.id}');

    if (_disposed) {
      _logger.w(() => '[connect] rejected (disposed)');
      return failureWithError('The client was disposed');
    }

    if (_state.currentUser.type == UserType.anonymous) {
      _logger.w(() => '[connect] rejected (anonymous user)');
      return failureWithError(
        'Cannot connect anonymous user to the WS due to Missing Permissions',
      );
    }

    if (_connection.isConnected) {
      _logger.w(() => '[connect] rejected (already connected)');
      if (registerPushDevice) _registerPushDevice();
      // The cache can be briefly empty while a token refresh is in flight;
      // getToken serves the cached token when present and otherwise waits
      // for the refresh instead of failing.
      try {
        return await _tokens.getToken();
      } catch (e, stk) {
        _logger.e(() => '[connect] token fetching failed: $e');
        return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
      }
    }

    _connection = ConnectionState.connecting(_state.currentUser.id);

    final user = _state.user.value;
    final Result<None> result;
    final UserToken token;
    try {
      // Establishes a guest's server-assigned identity, unless a request
      // that needed a token got there first.
      final tokenResult = await _tokens.getToken();
      if (tokenResult is! Success<UserToken>) {
        _logger.e(() => '[connect] token fetching failed: $tokenResult');
        _connection = ConnectionState.failed(
          _state.currentUser.id,
          error: (tokenResult as Failure).videoError,
        );
        return tokenResult;
      }
      token = tokenResult.data;

      _logger.v(() => '[connect] currentUser.id : ${user.id}');
      result = await _client.connectUser(
        user.toUserInfo(),
        includeUserDetails: includeUserDetails,
      );
    } catch (e, stk) {
      _logger.e(() => '[connect] failed(${user.id}): $e');
      final error = StreamVideoExceptions.compose(e, stk);
      _connection = ConnectionState.failed(_state.currentUser.id, error: error);
      return Result.failure(error, stk);
    }

    _logger.v(() => '[connect] completed: $result');
    if (result is Failure) {
      _connection = ConnectionState.failed(
        _state.currentUser.id,
        error: result.videoError,
      );
      return result;
    }

    // The socket is up, so the connection stays connected whatever the
    // steps after it do.
    _connection = ConnectionState.connected(_state.currentUser.id);
    try {
      _onConnected();
    } catch (e, stk) {
      _logger.e(() => '[connect] setting up the connection failed: $e\n$stk');
    }
    if (registerPushDevice) _registerPushDevice();

    return Result.success(token);
  }

  /// Registers the push device, unless a connect of this connection did.
  /// A failed registration is tried again by the next connect asking for it.
  void _registerPushDevice() {
    if (_pushDeviceRegistered) return;
    final manager = _pushNotificationManager();
    if (manager == null) return;
    try {
      manager.registerDevice();
      _pushDeviceRegistered = true;
    } catch (e, stk) {
      _logger.e(() => '[connect] registering the push device failed: $e\n$stk');
    }
  }

  /// Disconnects the user, and with [unregisterPushDevice] unregisters the
  /// push device first, so the user gets no more pushes on it.
  ///
  /// The user ends up disconnected whatever a step fails with. Also when the
  /// socket dropped earlier and is still reconnecting: that is closed too.
  /// Returns the failure of closing the socket, if it failed.
  Future<Result<None>> disconnect({bool unregisterPushDevice = true}) {
    return _lock.synchronized(
      () => _disconnect(unregisterPushDevice: unregisterPushDevice),
    );
  }

  Future<Result<None>> _disconnect({required bool unregisterPushDevice}) async {
    _logger.i(() => '[disconnect] currentUser.id: ${_state.currentUser.id}');

    if (unregisterPushDevice) {
      try {
        await _pushNotificationManager()?.unregisterDevice();
      } catch (e, stk) {
        _logger.e(
          () => '[disconnect] unregistering the push device failed: $e\n$stk',
        );
      }
    }
    _pushDeviceRegistered = false;

    // Closes a socket that is still reconnecting after a drop as well; with
    // no user connected it does nothing.
    Result<None> result;
    try {
      result = await _client.disconnectUser();
    } catch (e, stk) {
      result = Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
    if (result case Failure(:final error)) {
      _logger.e(() => '[disconnect] closing the socket failed: $error');
    }

    try {
      await _onDisconnected();
    } catch (e, stk) {
      _logger.e(() => '[disconnect] dropping the connection failed: $e\n$stk');
    }

    _connection = ConnectionState.disconnected(_state.currentUser.id);
    _logger.v(() => '[disconnect] completed');
    return result;
  }

  /// Disconnects the user without unregistering the push device, and refuses
  /// every later connect.
  Future<void> dispose() {
    return _lock.synchronized(() async {
      _disposed = true;
      final result = await _disconnect(unregisterPushDevice: false);
      if (result case Failure(:final error)) {
        _logger.w(() => '[dispose] disconnect failed: $error');
      }
    });
  }

  /// Follows the socket's own connected and disconnected events.
  void handleEvent(CoordinatorEvent event) {
    if (event is CoordinatorConnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] connected ${event.userId}');
      _connection = ConnectionState.connected(_state.currentUser.id);
    } else if (event is CoordinatorDisconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] disconnected ${event.userId}');
      _connection = ConnectionState.disconnected(_state.currentUser.id);
    } else if (event is CoordinatorReconnectedEvent) {
      _logger.i(() => '[onCoordinatorEvent] reconnected ${event.userId}');
    }
  }
}
