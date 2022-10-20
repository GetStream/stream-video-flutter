/// Connection status event emitted by the WS client
/// when the connection status changes.
enum ConnectionStatus {
  /// WS is trying to connect.
  connecting,

  /// WS is connected and everything is good.
  connected,

  /// WS is trying to reconnect.
  reconnecting,

  /// WS is disconnected.
  disconnected,
}
