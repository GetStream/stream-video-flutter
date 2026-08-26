import 'package:equatable/equatable.dart';
import 'package:stream_core/stream_core.dart' show StreamApiError;

sealed class CoordinatorConnectionState extends Equatable {
  const CoordinatorConnectionState();

  factory CoordinatorConnectionState.connected({
    required String userId,
    required String connectionId,
  }) {
    return CoordinatorConnected(userId: userId, connectionId: connectionId);
  }

  factory CoordinatorConnectionState.connecting({required String userId}) {
    return CoordinatorConnecting(userId: userId);
  }

  factory CoordinatorConnectionState.disconnected({
    String? userId,
    String? connectionId,
    int? closeCode,
    String? closeReason,
    StreamApiError? apiError,
  }) {
    return CoordinatorDisconnected(
      userId: userId,
      connectionId: connectionId,
      closeCode: closeCode,
      closeReason: closeReason,
      apiError: apiError,
    );
  }

  bool get isConnecting => this is CoordinatorConnecting;

  bool get isConnected => this is CoordinatorConnected;

  bool get isDisconnected => this is CoordinatorDisconnected;
}

class CoordinatorConnected extends CoordinatorConnectionState {
  const CoordinatorConnected({
    required this.userId,
    required this.connectionId,
  });

  final String userId;
  final String connectionId;

  @override
  List<Object?> get props => [userId, connectionId];

  @override
  String toString() => 'Connected{userId: $userId}';
}

class CoordinatorConnecting extends CoordinatorConnectionState {
  const CoordinatorConnecting({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Connecting{userId: $userId}';
}

class CoordinatorDisconnected extends CoordinatorConnectionState {
  const CoordinatorDisconnected({
    this.userId,
    this.connectionId,
    this.closeCode,
    this.closeReason,
    this.apiError,
  });

  final String? userId;
  final String? connectionId;
  final int? closeCode;
  final String? closeReason;

  /// The error the server reported before closing, when it sent one.
  final StreamApiError? apiError;

  @override
  List<Object?> get props => [
    userId,
    connectionId,
    closeCode,
    closeReason,
    apiError,
  ];

  @override
  String toString() => 'Disconnected{userId: $userId}';
}
