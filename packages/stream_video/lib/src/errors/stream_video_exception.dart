import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart'
    show StreamApiError, StreamApiException, StreamErrorCode, StreamException;

import '../sfu/data/models/sfu_error.dart';

/// The former name of [StreamVideoException].
@Deprecated('Use StreamVideoException instead.')
typedef VideoError = StreamVideoException;

/// The former name of [StreamVideoExceptionWithCause].
@Deprecated('Use StreamVideoExceptionWithCause instead.')
typedef VideoErrorWithCause = StreamVideoExceptionWithCause;

/// A failure this SDK reports.
class StreamVideoException extends Equatable implements Exception {
  /// Creates a [StreamVideoException].
  const StreamVideoException({required this.message, this.stackTrace});

  /// The message that represents the error.
  final String message;

  /// Where the failure was raised, when a stack trace was captured.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'StreamVideoException{message: $message, stackTrace: $stackTrace}';
  }

  @override
  List<Object?> get props => [message];
}

/// A failure that carries what caused it.
class StreamVideoExceptionWithCause extends StreamVideoException {
  /// Creates a [StreamVideoExceptionWithCause].
  const StreamVideoExceptionWithCause({
    super.message = '',
    super.stackTrace,
    required Object cause,
  }) : _cause = cause;

  final Object _cause;

  /// What caused this failure.
  ///
  /// Read the failure through the accessors instead, which answer from every
  /// shape a verdict arrives in: [apiStatusCode], [apiErrorCode], [apiError],
  /// [isUnrecoverable] and [retryAfter] for a server verdict, and [sfuError]
  /// for one the SFU reported.
  @Deprecated(
    'The runtime type of the cause is not part of this API. Use the accessors '
    'on StreamVideoException instead — apiStatusCode, apiErrorCode, apiError, '
    'isUnrecoverable, retryAfter, or sfuError.',
  )
  Object get cause => _cause;

  @override
  String toString() {
    return 'StreamVideoExceptionWithCause{message: $message, '
        'cause: ${_describeCause(_cause)}, stackTrace: $stackTrace}';
  }

  @override
  List<Object?> get props => [...super.props, _cause];
}

extension StreamVideoExceptionApiDetails on StreamVideoException {
  /// The typed server error behind this failure, or `null` when the failure
  /// carried no parseable payload.
  StreamApiError? get apiError => switch (_rawCause) {
    final StreamApiError it => it,
    StreamApiException(:final apiError) => apiError,
    _ => null,
  };

  /// The HTTP status the server answered with, or `null` when the request never
  /// reached a server verdict.
  int? get apiStatusCode => switch (_rawCause) {
    final StreamApiError it => it.statusCode,
    StreamApiException(:final statusCode) => statusCode,
    _ => null,
  };

  /// Stream's stable error code, or `null` when the failure carried none.
  StreamErrorCode? get apiErrorCode => switch (_rawCause) {
    final StreamApiError it => it.code,
    StreamApiException(:final code) => code,
    _ => null,
  };

  /// Whether the server declared that retrying will not help.
  bool get isUnrecoverable => switch (_rawCause) {
    StreamApiError(:final unrecoverable) => unrecoverable ?? false,
    StreamApiException(:final unrecoverable) => unrecoverable,
    _ => false,
  };

  /// How long the server asked to wait before retrying, when it named a wait.
  Duration? get retryAfter => switch (_rawCause) {
    StreamApiException(:final retryAfter) => retryAfter,
    _ => null,
  };

  /// The `stream_core` exception this failure stands for, or `null` when it
  /// wraps something else.
  ///
  /// Use it when handing a failure back to core — its handlers run
  /// [StreamException.tryFrom], which does not see through a [StreamVideoException], so a
  /// re-raised wrapper arrives as the cause of a cause with its facts buried.
  StreamException? get streamException => switch (_rawCause) {
    final StreamException it => it,
    final StreamApiError it => StreamApiException.fromApiError(it),
    _ => null,
  };

  /// What caused this failure, whatever it is.
  ///
  /// For diagnostics inside this SDK — logging, telemetry classification — and
  /// for the handful of internal types the SDK itself puts here and reads back.
  /// Everything a caller should act on has a typed accessor above; this one is
  /// `@internal` because its runtime type is chosen by whatever mapped the
  /// failure and changes without notice.
  @internal
  Object? get rawCause => _rawCause;

  Object? get _rawCause {
    final self = this;
    return self is StreamVideoExceptionWithCause ? self._cause : null;
  }
}

/// The SFU's verdict behind a [StreamVideoException], for the code that decides how to
/// recover from it.
extension StreamVideoExceptionSfuDetails on StreamVideoException {
  /// The error the SFU reported, or `null` when the failure did not come from
  /// it.
  SfuError? get sfuError => switch (_rawCause) {
    final SfuError it => it,
    _ => null,
  };
}

/// A one-line description of a failure's cause, for logs and traces.
String _describeCause(Object cause) => switch (cause) {
  StreamApiException(:final statusCode, :final code, :final message) =>
    '${cause.runtimeType}(status: $statusCode, code: $code): $message',
  StreamException(:final message) => '${cause.runtimeType}: $message',
  StreamApiError(:final statusCode, :final code, :final message) =>
    'StreamApiError(status: $statusCode, code: $code): $message',
  _ => '$cause',
};
