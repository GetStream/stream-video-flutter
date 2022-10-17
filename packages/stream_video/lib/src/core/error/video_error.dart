import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StreamVideoError with EquatableMixin implements Exception {
  const StreamVideoError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamVideoError(message: $message)';
}

class StreamVideoWebSocketError extends StreamVideoError {
  const StreamVideoWebSocketError(super.message);

  factory StreamVideoWebSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? '';
    return StreamVideoWebSocketError(message);
  }
}
