import 'package:meta/meta.dart';
import 'package:stream_video/src/v2/utils/result.dart';

/// Represents an SDK error that contains a message.
class VideoError {
  VideoError({required this.message});

  /// The message that represents the error.
  final String message;

  static VideoError from(Object? exception) {
    if (exception is String) {
      return VideoError(message: exception);
    } else if (exception is Exception) {
      return VideoErrorWithCause(cause: exception);
    } else {
      return VideoError(message: 'Unknown error: ${exception?.toString()}');
    }
  }

  @internal
  Future<Result<Never>> asFutureFailureResult() {
    return Future.value(Failure(this));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() {
    return 'VideoError{message: $message}';
  }
}

/// Represents an SDK error that contains a message and the cause.
class VideoErrorWithCause extends VideoError {
  VideoErrorWithCause({super.message = "", required this.cause});

  /// Cause of the error, either a BE exception or an SDK based one.
  final Exception cause;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoErrorWithCause &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause;

  @override
  int get hashCode => super.hashCode ^ cause.hashCode;

  @override
  String toString() {
    return 'VideoErrorWithCause{message: $message, exception: $cause}';
  }
}
