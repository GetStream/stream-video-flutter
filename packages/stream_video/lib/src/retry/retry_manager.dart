import '../../open_api/video/coordinator/api.dart';
import '../errors/video_error.dart';
import '../utils/result.dart';
import 'retry_policy.dart';

typedef Delegate<T> = Future<Result<T>> Function();
typedef OnFailure<T> =
    Future<void> Function(
      VideoError error,
      Duration nextAttemptDelay,
    );

class RpcRetryManager {
  const RpcRetryManager(this.policy);

  final RetryPolicy policy;

  Future<Result<T>> execute<T>(
    Delegate<T> delegate, [
    OnFailure<T>? onFailure,
  ]) async {
    late Result<T> result;
    var retryAttempt = 0;
    do {
      final delay = policy.backoff(retryAttempt);
      if (retryAttempt > 0 && result is Failure) {
        await onFailure?.call(result.error, delay);
      }
      result = await Future.delayed(
        delay,
        delegate,
      );
      retryAttempt++;
    } while (result.isFailure &&
        retryAttempt < policy.config.rpcMaxRetries &&
        _isRetryable(result));

    return result;
  }

  /// Returns false for permanent client errors (4xx except 408/429)
  /// that should not be retried.
  bool _isRetryable(Result<dynamic> result) {
    if (result is! Failure) return true;

    final error = result.error;
    if (error is! VideoErrorWithCause) return true;

    final cause = error.cause;
    if (cause is! ApiException) return true;

    final statusCode = cause.code;
    if (statusCode >= 400 && statusCode < 500) {
      // 408 Request Timeout and 429 Too Many Requests are retryable
      return statusCode == 408 || statusCode == 429;
    }

    return true;
  }
}
