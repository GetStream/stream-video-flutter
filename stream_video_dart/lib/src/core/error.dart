
import 'package:equatable/equatable.dart';

class StreamVideoError with EquatableMixin implements Exception {
  const StreamVideoError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamVideoError(message: $message)';
}
