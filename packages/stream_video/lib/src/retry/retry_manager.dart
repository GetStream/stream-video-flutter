import '../errors/video_error.dart';
import '../utils/result.dart';
import 'retry_policy.dart';

typedef Delegate<T> = Future<Result<T>> Function();
typedef OnFailure<T> = Future<void> Function(
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
    } while (result.isFailure && retryAttempt < policy.config.rpcMaxRetries);

    return result;
  }
}
