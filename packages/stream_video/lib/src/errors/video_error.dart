import 'dart:convert';

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
  APIError? get apiError {
    final self = this;
    if (self is! VideoErrorWithCause) return null;

    final cause = self.cause;
    if (cause is! ApiException) return null;

    final body = cause.message;
    if (body == null || body.isEmpty) return null;

    try {
      return APIError.fromJson(jsonDecode(body));
    } catch (_) {
      return null;
    }
  }
}
