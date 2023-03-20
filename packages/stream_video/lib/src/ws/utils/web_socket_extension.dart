import '../base_ws.dart';
import '../socket_connection_state.dart';

/// Extends [AbstractWebSocket] class.
extension WebSocketExtension on AbstractWebSocket {
  /// Returns True if the connection state is [SocketConnectionState.connecting].
  bool get isConnecting => connectionState == SocketConnectionState.connecting;

  /// Returns True if the connection state is [SocketConnectionState.connected].
  bool get isConnected => connectionState == SocketConnectionState.connected;

  /// Returns True if the connection state is [SocketConnectionState.reconnecting].
  bool get isReconnecting =>
      connectionState == SocketConnectionState.reconnecting;

  /// Returns True if the connection state is [SocketConnectionState.disconnected].
  bool get isDisconnected =>
      connectionState == SocketConnectionState.disconnected;
}
