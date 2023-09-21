import 'package:equatable/equatable.dart';

sealed class CoordinatorConnectionState with EquatableMixin {
  const CoordinatorConnectionState();

  factory CoordinatorConnectionState.connected({String? userId}) {
    return CoordinatorConnected(userId: userId);
  }

  factory CoordinatorConnectionState.connecting({String? userId}) {
    return CoordinatorConnecting(userId: userId);
  }

  factory CoordinatorConnectionState.disconnected({
    String? userId,
    String? clientId,
    int? closeCode,
    String? closeReason,
  }) {
    return CoordinatorDisconnected(
      userId: userId,
      clientId: clientId,
      closeCode: closeCode,
      closeReason: closeReason,
    );
  }

  bool get isConnecting => this is CoordinatorConnecting;

  bool get isConnected => this is CoordinatorConnected;

  bool get isDisconnected => this is CoordinatorDisconnected;
}

class CoordinatorConnected extends CoordinatorConnectionState {
  const CoordinatorConnected({this.userId});

  final String? userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Connected{userId: $userId}';
}

class CoordinatorConnecting extends CoordinatorConnectionState {
  const CoordinatorConnecting({this.userId});

  final String? userId;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Connecting{userId: $userId}';
}

class CoordinatorDisconnected extends CoordinatorConnectionState {
  const CoordinatorDisconnected({
    this.userId,
    this.clientId,
    this.closeCode,
    this.closeReason,
  });

  final String? clientId;
  final String? userId;
  final int? closeCode;
  final String? closeReason;

  @override
  List<Object?> get props => [userId];

  @override
  String toString() => 'Disconnected{userId: $userId}';
}
