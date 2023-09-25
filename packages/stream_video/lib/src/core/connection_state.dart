import 'package:equatable/equatable.dart';

import '../errors/video_error.dart';

sealed class ConnectionState with EquatableMixin {
  const ConnectionState();

  factory ConnectionState.connected(String userId) {
    return StateConnected(userId);
  }

  factory ConnectionState.connecting(String userId) {
    return StateConnecting(userId: userId);
  }

  factory ConnectionState.reconnecting(String userId) {
    return StateReconnecting(userId: userId);
  }

  factory ConnectionState.disconnected(String userId) {
    return StateDisconnected(userId);
  }

  factory ConnectionState.failed(
    String userId, {
    required VideoError error,
  }) {
    return StateFailed(userId, error: error);
  }

  bool get isConnecting => this is StateConnecting;

  bool get isConnected => this is StateConnected;

  bool get isDisconnected => this is StateDisconnected;

  bool get isFailed => this is StateFailed;
}

class StateConnected extends ConnectionState {
  const StateConnected(
    this.userId,
  );

  final String userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Connected{userId: $userId}';
}

class StateConnecting extends ConnectionState {
  const StateConnecting({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Connecting{userId: $userId}';
}

class StateReconnecting extends ConnectionState {
  const StateReconnecting({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Reconnecting{userId: $userId}';
}

class StateDisconnected extends ConnectionState {
  const StateDisconnected(
    this.userId,
  );

  final String userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Disconnected{userId: $userId}';
}

class StateFailed extends ConnectionState {
  const StateFailed(
    this.userId, {
    required this.error,
  });

  final String userId;
  final VideoError error;

  @override
  List<Object?> get props => [userId, error];

  @override
  String toString() => 'Failed{userId: $userId, error: $error}';
}
