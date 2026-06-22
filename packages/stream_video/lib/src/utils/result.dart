import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../errors/video_error.dart';

export 'package:stream_core/stream_core.dart'
    show Failure, PatternMatching, Result, Success, runSafely, runSafelySync;

/// Attempts to map an error [Object] to a [VideoError] if it is already
/// of that type; otherwise, creates a new [VideoError] using the object's
/// string representation as the message.
extension ObjectToVideoError on Object {
  VideoError toVideoError([StackTrace? stackTrace]) {
    final self = this;
    if (self is VideoError) return self;
    return VideoError(message: self.toString(), stackTrace: stackTrace);
  }
}

/// Backwards-compatible accessors that existed on the previous `stream_video`
/// [Result] but are not part of the `stream_core` one.
/// Added to minimize the impact of the breaking changes.
extension VideoResult<T> on Result<T> {
  T? getDataOrNull() => getOrNull();

  VideoError? getErrorOrNull() =>
      exceptionOrNull()?.toVideoError(stackTraceOrNull());

  /// Pattern-matches the result, mirroring the previous `fold` which received
  /// the [Success]/[Failure] instances directly.
  R foldResult<R>({
    required R Function(Success<T> success) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      final Success<T> s => success(s),
      final Failure f => failure(f),
    };
  }

  /// Equivalent to the previous `when`, exposing the failure as a [VideoError].
  R when<R>({
    required R Function(T data) success,
    required R Function(VideoError error) failure,
  }) {
    return fold(
      onSuccess: success,
      onFailure: (error, stackTrace) => failure(error.toVideoError(stackTrace)),
    );
  }
}

/// A typed [VideoError] view of a [Failure]'s error.
extension VideoFailure on Failure {
  VideoError get videoError => error.toVideoError(stackTrace);
}

/// Creates a [Failure] with a [VideoError] or [VideoErrorWithCause] based on the presence of a [cause].
Result<T> failureWithError<T>(
  String message, {
  Object? cause,
  StackTrace? stackTrace,
}) {
  return Result.failure(
    cause == null
        ? VideoError(message: message, stackTrace: stackTrace)
        : VideoErrorWithCause(
            message: message,
            cause: cause,
            stackTrace: stackTrace,
          ),
    stackTrace,
  );
}

/// Runs [fn] (which itself returns a [Result]) and converts any thrown error
/// into a [VideoErrorWithCause] failure.
Future<Result<T>> runCatchingResult<T>(
  FutureOr<Result<T>> Function() fn,
) async {
  try {
    return await fn();
  } catch (e, stackTrace) {
    return failureWithError<T>(e.toString(), cause: e, stackTrace: stackTrace);
  }
}
