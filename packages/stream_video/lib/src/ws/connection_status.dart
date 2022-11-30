import 'dart:async';

/// Connection status event emitted by the WS client
/// when the connection status changes.
enum ConnectionStatus {
  /// WS has not yet started the connect process.
  unconnected,

  /// WS is trying to connect.
  connecting,

  /// WS is connected and everything is good.
  connected,

  /// WS is trying to reconnect.
  reconnecting,

  /// WS is disconnected.
  disconnected,
}

mixin ConnectionStatusMixin {
  var _connectionStatus = ConnectionStatus.unconnected;

  var _statusController = StreamController<ConnectionStatus>.broadcast();

  set connectionStatus(ConnectionStatus state) {
    _connectionStatus = state;
    _statusController.add(state);
  }

  ConnectionStatus get connectionStatus => _connectionStatus;

  Stream<ConnectionStatus> get connectionStatusStream =>
      _statusController.stream;

  Future<void> closeConnectionStatusController() => _statusController.close();
}
