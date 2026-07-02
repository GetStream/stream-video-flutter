import '../../open_api/video/coordinator/api.dart';
import '../errors/video_error.dart';
import '../token/token_manager.dart';
import '../utils/result.dart';
import 'retry_policy.dart';

typedef Delegate<T> = Future<Result<T>> Function();
typedef OnFailure<T> =
    Future<void> Function(
      VideoError error,
      Duration nextAttemptDelay,
    );

class RpcRetryManager {
  const RpcRetryManager(
    this.policy, {
    this.tokenManager,
  });

  final RetryPolicy policy;
  final TokenManager? tokenManager;

  Future<Result<T>> execute<T>(
    Delegate<T> delegate, [
    OnFailure<T>? onFailure,
  ]) async {
    late Result<T> result;
    var retryAttempt = 0;
    var authRefreshed = false;

    do {
      final delay = policy.backoff(retryAttempt);
      if (retryAttempt > 0 && result is Failure) {
        await onFailure?.call(result.videoError, delay);
      }
      result = await Future.delayed(
        delay,
        delegate,
      );

      // On 401, refresh the token once and retry immediately.
      if (result.isFailure && !authRefreshed && _isAuthError(result)) {
        if (tokenManager != null) {
          authRefreshed = true;
          final refreshResult = await tokenManager!.refreshToken();
          if (refreshResult.isSuccess) {
            // Prevent infinite loop of retries if the token refresh provides invalid token.
            continue;
          }
        }
      }

      retryAttempt++;
    } while (result.isFailure &&
        retryAttempt < policy.config.rpcMaxRetries &&
        _isRetryable(result));

    return result;
  }

  bool _isAuthError(Result<dynamic> result) {
    return _apiError(result)?.statusCode == 401;
  }

  /// Returns false for permanent client errors (4xx except 401/408/429)
  /// that should not be retried.
  /// 401 (Unauthorized) is retryable because the auth-retry logic above handles it with a token refresh.
  /// 408 (Request Timeout) and 429 (Too Many Requests) are retryable because they are temporary errors.
  bool _isRetryable(Result<dynamic> result) {
    final apiError = _apiError(result);
    // Transport-level failures (timeouts, connection errors) carry no typed
    // [StreamApiError]; treat them as retryable.
    if (apiError == null) return true;

    final statusCode = apiError.statusCode;
    if (statusCode >= 400 && statusCode < 500) {
      return statusCode == 401 || statusCode == 408 || statusCode == 429;
    }

    return true;
  }

  /// Unwraps the typed [StreamApiError] cause from a failed [result], or `null`
  /// when the failure is not a server-side API error (e.g. a transport error).
  StreamApiError? _apiError(Result<dynamic> result) {
    if (result is! Failure) return null;

    final error = result.error;
    if (error is! VideoErrorWithCause) return null;

    final cause = error.cause;
    return cause is StreamApiError ? cause : null;
  }
}
