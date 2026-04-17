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
        await onFailure?.call(result.error, delay);
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
    if (result is! Failure) return false;

    final error = result.error;
    if (error is! VideoErrorWithCause) return false;

    final cause = error.cause;
    if (cause is! ApiException) return false;

    return cause.code == 401;
  }

  /// Returns false for permanent client errors (4xx except 401/408/429)
  /// that should not be retried.
  /// 401 (Unauthorized) is retryable because the auth-retry logic above handles it with a token refresh.
  /// 408 (Request Timeout) and 429 (Too Many Requests) are retryable because they are temporary errors.
  bool _isRetryable(Result<dynamic> result) {
    if (result is! Failure) return true;

    final error = result.error;
    if (error is! VideoErrorWithCause) return true;

    final cause = error.cause;
    if (cause is! ApiException) return true;

    final statusCode = cause.code;
    if (statusCode >= 400 && statusCode < 500) {
      return statusCode == 401 || statusCode == 408 || statusCode == 429;
    }

    return true;
  }
}
