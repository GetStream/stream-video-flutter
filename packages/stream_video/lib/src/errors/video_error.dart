import 'package:equatable/equatable.dart';

import '../../open_api/video/coordinator/api.dart';

/// Represents an SDK error that contains a message.
class VideoError extends Equatable implements Error {
  /// TODO
  const VideoError({required this.message, this.stackTrace});

  /// The message that represents the error.
  final String message;

  /// Cause of the error, either a BE exception or an SDK based one.
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'VideoError{message: $message, stackTrace: $stackTrace}';
  }

  @override
  List<Object?> get props => [message];
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
  final Object cause;

  @override
  String toString() {
    return 'VideoErrorWithCause{message: $message, '
        'exception: $cause, stackTrace: $stackTrace}';
  }

  @override
  List<Object?> get props => [...super.props, cause];
}

extension VideoErrorApiDetails on VideoError {
  /// The typed server error behind this failure, or `null` when the failure is
  /// not a server-side API error (e.g. a transport error).
  StreamApiError? get apiError {
    final self = this;
    if (self is! VideoErrorWithCause) return null;

    final cause = self.cause;
    return cause is StreamApiError ? cause : null;
  }
}
