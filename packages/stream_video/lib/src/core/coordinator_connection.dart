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

  /// Runs after a disconnect closed the socket, or found it closed already.
  final Future<void> Function({required bool wasConnected}) _onDisconnected;

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
  /// A connect while the user is connected, or after another connect that is
  /// still running, opens no second socket and answers with the current
  /// token. [includeUserDetails] only applies to the connect that opens the
  /// socket. [registerPushDevice] registers the device once per connection,
  /// so a later connect asking for it registers a device an earlier one
  /// skipped.
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
      return _tokens.getToken();
    }

    _connection = ConnectionState.connecting(_state.currentUser.id);

    // Establishes a guest's server-assigned identity, unless a request that
    // needed a token got there first.
    final tokenResult = await _tokens.getToken();
    if (tokenResult is! Success<UserToken>) {
      _logger.e(() => '[connect] token fetching failed: $tokenResult');
      _connection = ConnectionState.failed(
        _state.currentUser.id,
        error: (tokenResult as Failure).videoError,
      );
      return tokenResult;
    }

    final user = _state.user.value;
    _logger.v(() => '[connect] currentUser.id : ${user.id}');
    try {
      final result = await _client.connectUser(
        user.toUserInfo(),
        includeUserDetails: includeUserDetails,
      );
      _logger.v(() => '[connect] completed: $result');
      if (result is Failure) {
        _connection = ConnectionState.failed(
          _state.currentUser.id,
          error: result.videoError,
        );
        return result;
      }
      _connection = ConnectionState.connected(_state.currentUser.id);
      _onConnected();

      if (registerPushDevice) _registerPushDevice();

      return Result.success(tokenResult.data);
    } catch (e, stk) {
      _logger.e(() => '[connect] failed(${user.id}): $e');
      _connection = ConnectionState.failed(
        _state.currentUser.id,
        error: StreamVideoExceptions.compose(e, stk),
      );
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  void _registerPushDevice() {
    if (_pushDeviceRegistered) return;
    final manager = _pushNotificationManager();
    if (manager == null) return;
    _pushDeviceRegistered = true;
    manager.registerDevice();
  }

  /// Disconnects the user. [unregisterPushDevice] unregisters the push device
  /// first, so the user gets no more pushes on it.
  Future<Result<None>> disconnect({bool unregisterPushDevice = true}) {
    return _lock.synchronized(
      () => _disconnect(unregisterPushDevice: unregisterPushDevice),
    );
  }

  Future<Result<None>> _disconnect({required bool unregisterPushDevice}) async {
    _logger.i(() => '[disconnect] currentUser.id: ${_state.currentUser.id}');
    if (_connection.isDisconnected) {
      _logger.w(() => '[disconnect] rejected (already disconnected)');
      // Reachable with state still held: a dropped websocket marks the client
      // disconnected without coming through here.
      await _onDisconnected(wasConnected: false);
      return const Result.success(none);
    }
    try {
      if (unregisterPushDevice) {
        await _pushNotificationManager()?.unregisterDevice();
      }
      _pushDeviceRegistered = false;

      await _client.disconnectUser();

      await _onDisconnected(wasConnected: true);
      _connection = ConnectionState.disconnected(_state.currentUser.id);
      _logger.v(() => '[disconnect] completed');
      return const Result.success(none);
    } catch (e, stk) {
      _logger.e(() => '[disconnect] failed: $e');
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Disconnects the user without unregistering the push device, and refuses
  /// every later connect.
  Future<void> dispose() {
    return _lock.synchronized(() async {
      _disposed = true;
      await _disconnect(unregisterPushDevice: false);
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
