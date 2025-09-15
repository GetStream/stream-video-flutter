import '../../logger/logger.dart';

/// Connection state type used throughout the SDK.
enum ConnectionState {
  connected,
  disconnected,
  failed,
  closed,
  connecting,
  reconnecting,
}

/// Model class for connection state updates.
class ConnectionStateUpdatedEvent {
  /// Creates a new instance of [ConnectionStateUpdatedEvent].
  const ConnectionStateUpdatedEvent({
    required this.newState,
    required this.oldState,
    required this.didConnected,
  });

  /// The new connection state.
  final ConnectionState newState;

  /// The old connection state.
  final ConnectionState oldState;

  /// Whether the connection state changed to [ConnectionState.connected].
  final bool didConnected;
}

typedef OnConnectionStateUpdated = void Function(ConnectionStateUpdatedEvent);

/// Connection state mixin used throughout the SDK.
mixin ConnectionStateMixin {
  /// Returns True if the connection state is [ConnectionState.connecting].
  bool get isConnecting => connectionState == ConnectionState.connecting;

  /// Returns True if the connection state is [ConnectionState.connected].
  bool get isConnected => connectionState == ConnectionState.connected;

  /// Returns True if the connection state is [ConnectionState.reconnecting].
  bool get isReconnecting => connectionState == ConnectionState.reconnecting;

  /// Returns True if the connection state is [ConnectionState.disconnected].
  bool get isDisconnected => connectionState == ConnectionState.disconnected;

  /// The current connection state of the client.
  ConnectionState get connectionState => _connectionState;
  ConnectionState _connectionState = ConnectionState.disconnected;

  /// Called when the connection state updates.
  OnConnectionStateUpdated? onConnectionStateUpdated;

  set connectionState(ConnectionState newState) {
    final oldState = _connectionState;
    if (oldState == newState) return;

    streamLog.v(
      'SV:ConnectionStateMixin',
      () => '[setConnectionState] ${oldState.name} -> ${newState.name}',
    );

    _connectionState = newState;

    final didConnected =
        oldState != ConnectionState.connected &&
        newState == ConnectionState.connected;

    final updatedState = ConnectionStateUpdatedEvent(
      oldState: oldState,
      newState: newState,
      didConnected: didConnected,
    );

    return onConnectionStateUpdated?.call(updatedState);
  }
}
