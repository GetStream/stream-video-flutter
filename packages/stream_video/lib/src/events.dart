import 'types/other.dart';

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
