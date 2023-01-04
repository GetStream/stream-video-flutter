/// Represents an SDK error that contains a message and the cause.
class VideoError {
  VideoError({this.message = null, this.cause = null});

  /// The message that represents the error.
  final String? message;

  /// Cause of the error, either a BE exception or an SDK based one.
  final Exception? cause;

  static VideoError from(Object? exception) {
    if (exception is String) {
      return VideoError(message: exception);
    } else if (exception is Exception) {
      return VideoError(cause: exception);
    } else {
      return VideoError(message: exception?.toString());
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          cause == other.cause;

  @override
  int get hashCode => message.hashCode ^ cause.hashCode;

  @override
  String toString() {
    return 'VideoError{message: $message, exception: $cause}';
  }
}
