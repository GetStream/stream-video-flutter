import 'dart:math';

import 'package:equatable/equatable.dart';

import '../errors/video_error.dart';
import '../utils/result.dart';

typedef Delegate<T> = Future<Result<T>> Function();
typedef OnFailure<T> = Future<void> Function(
  VideoError error,
  Duration nextAttemptDelay,
);

const _maxRetries = 5;
const _retryMaxBackoff = Duration(seconds: 3);
const _maxJitter = Duration(milliseconds: 500);
const _defaultDelay = Duration(milliseconds: 200);

final Random _rnd = Random();

class RetryManager {
  RetryManager({
    this.config = const RetryConfig(),
  });

  final RetryConfig config;

  Duration get jitter {
    return Duration(milliseconds: _rnd.nextInt(_maxJitter.inMilliseconds));
  }

  Future<Result<T>> execute<T>(
    Delegate<T> delegate, [
    OnFailure<T>? onFailure,
  ]) async {
    late Result<T> result;
    var retryAttempt = 0;
    do {
      final delay = _calculateDelay(retryAttempt);
      if (retryAttempt > 0 && result is Failure) {
        await onFailure?.call(result.error, delay);
      }
      result = await Future.delayed(
        delay,
        delegate,
      );
      retryAttempt++;
    } while (result.isFailure && retryAttempt < config.maxRetries);

    return result;
  }

  Duration _calculateDelay(int retryAttempt) {
    if (retryAttempt == 0) {
      return Duration.zero;
    }
    final calculated = config.attemptDelay * retryAttempt + jitter;
    if (calculated < config.retryMaxBackoff) {
      return calculated;
    }
    return config.retryMaxBackoff;
  }
}

class RetryConfig with EquatableMixin {
  const RetryConfig({
    this.maxRetries = _maxRetries,
    this.attemptDelay = _defaultDelay,
    this.retryMaxBackoff = _retryMaxBackoff,
  });

  final int maxRetries;
  final Duration attemptDelay;
  final Duration retryMaxBackoff;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [maxRetries, retryMaxBackoff];
}
