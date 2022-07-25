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

class StreamWebSocketError extends StreamVideoError {
  StreamWebSocketError(String message) : super(message);

  factory StreamWebSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? '';
    return StreamWebSocketError(message);
  }

}
