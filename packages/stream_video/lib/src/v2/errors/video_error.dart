import 'package:meta/meta.dart';
import 'package:stream_video/src/v2/utils/result.dart';

/// Represents an SDK error that contains a message.
class VideoError {
  /// TODO
  const VideoError({required this.message, this.stackTrace});

  /// The message that represents the error.
  final String message;

  /// Cause of the error, either a BE exception or an SDK based one.
  final StackTrace? stackTrace;

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
    return 'VideoError{message: $message, stackTrace: $stackTrace}';
  }
}

/// Represents an SDK error that contains a message and the cause.
class VideoErrorWithCause extends VideoError {
  /// TODO
  const VideoErrorWithCause({
    super.message = '',
    super.stackTrace,
    required this.cause,
  });

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
    return 'VideoErrorWithCause{message: $message, '
        'exception: $cause, stackTrace: $stackTrace}';
  }
}
