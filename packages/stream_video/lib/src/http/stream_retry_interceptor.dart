import 'package:stream_core/stream_core.dart';

import '../logger/impl/tagged_logger.dart';
import '../retry/retry_policy.dart';

/// Retries a request while the failure it produced says another attempt could
/// succeed.
class StreamRetryInterceptor extends Interceptor {
  /// Creates a [StreamRetryInterceptor] sending its retries through [dio].
  StreamRetryInterceptor({
    required Dio dio,
    required RetryPolicy policy,
    String tag = 'SV:HttpRetry',
  }) : _dio = dio,
       _policy = policy,
       _logger = taggedLogger(tag: tag);

  final Dio _dio;
  final RetryPolicy _policy;
  final TaggedLogger _logger;

  /// How many attempts this request has already spent.
  static const _attemptKey = 'stream_video.retry_attempt';

  /// How long retrying has already delayed this request, in milliseconds.
  static const _spentDelayKey = 'stream_video.retry_delay_ms';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final spent = (options.extra[_attemptKey] as int?) ?? 1;

    if (spent >= _policy.config.rpcMaxRetries) {
      _logger.w(
        () => '[${options.path}] giving up after $spent attempt(s)',
      );
      return handler.next(err);
    }

    final exception = err.toStreamException();
    if (!_isRetryable(exception)) return handler.next(err);

    final delay = _delay(exception, spent);

    // A rate limit can name a long wait, and honouring one per attempt would
    // park the call for minutes. Past the budget the answer is reported rather
    // than waited on: retrying sooner than the server asked only earns the
    // same refusal.
    final spentDelay = Duration(
      milliseconds: (options.extra[_spentDelayKey] as int?) ?? 0,
    );
    final budget = _policy.config.maxTotalRetryDelay;
    if (spentDelay + delay > budget) {
      _logger.w(
        () =>
            '[${options.path}] not retrying: the next wait '
            '(${delay.inMilliseconds}ms) does not fit the remaining budget '
            '(${(budget - spentDelay).inMilliseconds}ms)',
      );
      return handler.next(err);
    }

    _logger.w(
      () =>
          '[${options.path}] attempt $spent failed (${exception.runtimeType}), '
          'retrying in ${delay.inMilliseconds}ms',
    );

    await Future<void>.delayed(delay);

    // The refused attempt already consumed a multipart body's streams.
    final data = options.data;
    final retry = options.copyWith(
      extra: {
        ...options.extra,
        _attemptKey: spent + 1,
        _spentDelayKey: (spentDelay + delay).inMilliseconds,
      },
      data: data is FormData ? data.clone() : data,
    );

    try {
      final response = await _dio.fetch<dynamic>(retry);
      return handler.resolve(response);
    } on DioException catch (exception) {
      return handler.reject(exception);
    }
  }

  /// How long to wait before the attempt following [spent] failures.
  ///
  /// A server that sent `Retry-After` named the wait, and that wins: the
  /// computed backoff is a guess, and against a rate limit it is a guess that
  /// retries too early. The backoff is the floor, so a `Retry-After: 0` cannot
  /// tighten the loop. What keeps a long wait in check is the caller's total
  /// budget, not a ceiling on each one — see [RetryConfig.maxTotalRetryDelay].
  Duration _delay(StreamException exception, int spent) {
    final backoff = _policy.backoff(spent);

    final retryAfter = switch (exception) {
      StreamApiException(:final retryAfter) => retryAfter,
      _ => null,
    };
    if (retryAfter == null || retryAfter <= backoff) return backoff;

    return retryAfter;
  }

  /// Whether [exception] is worth another attempt.
  bool _isRetryable(StreamException exception) => switch (exception) {
    // The server declared that retrying will not help, which settles it.
    StreamApiException(unrecoverable: true) => false,

    // Credentials the server positively refused. A retry reproduces the same
    // configuration, so it cannot land differently.
    StreamApiException(isTokenSignatureInvalid: true) => false,
    StreamApiException(isApiKeyInvalid: true) => false,

    // [StreamAuthInterceptor] already replaced the token and retried once.
    // Asking again would only mint another token for the same refusal.
    StreamApiException(isTokenExpired: true) => false,

    // Clock skew on the token's `nbf`/`iat` claims: a later attempt can get
    // past it, and the delay above is the wait.
    StreamApiException(isTokenNotYetValid: true) => true,

    // A permanent client error will be answered the same way. 401 is kept
    // because a body carrying no Stream code leaves the cause unknown, and 408
    // and 429 are temporary by definition.
    StreamApiException(:final statusCode)
        when statusCode >= 400 && statusCode < 500 =>
      statusCode == 401 || statusCode == 408 || statusCode == 429,

    // 5xx, and anything else the server answered with.
    StreamApiException() => true,

    // The caller asked for this request to stop; sending it again would defeat
    // the cancellation.
    StreamNetworkException(isCancelled: true) => false,

    // Never reached a verdict — a timeout, a dropped connection. Worth another
    // attempt, and the outcome of the last one is unknown either way.
    StreamNetworkException() => true,

    StreamAuthenticationException() => false,

    // A failure inside the SDK — wire data that would not decode, a bug in a
    // mapper. Resending produces the same bytes and the same failure, so the
    // answer is to report it rather than spend the budget rediscovering it.
    StreamClientException() => false,
  };
}
