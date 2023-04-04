import 'dart:math';

import 'package:equatable/equatable.dart';

const _maxJitterMs = 500;
const _minDelay = Duration(milliseconds: 200);
const _defaultRpcMaxRetries = 5;
const _defaultMaxBackoff = Duration(seconds: 3);
const _defaultRejoinTimeout = Duration(seconds: 15);

final Random _rnd = Random();

typedef Backoff = Duration Function(RetryConfig config, int retryAttempt);

class RetryPolicy {
  const RetryPolicy({
    this.config = const RetryConfig(),
    Backoff backoff = _defaultBackoff,
  }) : _backoff = backoff;

  final RetryConfig config;
  final Backoff _backoff;

  Duration backoff(int retryAttempt) {
    return _backoff.call(config, retryAttempt);
  }
}

Duration _defaultBackoff(RetryConfig config, int retryAttempt) {
  if (retryAttempt == 0) {
    return Duration.zero;
  }
  final jitter = Duration(milliseconds: _rnd.nextInt(_maxJitterMs));
  final calculated = _minDelay * retryAttempt + jitter;
  if (calculated < config.maxBackoff) {
    return calculated;
  }
  return config.maxBackoff;
}

class RetryConfig with EquatableMixin {
  const RetryConfig({
    this.rpcMaxRetries = _defaultRpcMaxRetries,
    this.maxBackoff = _defaultMaxBackoff,
    this.callRejoinTimeout = _defaultRejoinTimeout,
  });

  final int rpcMaxRetries;

  final Duration maxBackoff;

  final Duration callRejoinTimeout;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [rpcMaxRetries, maxBackoff];
}
