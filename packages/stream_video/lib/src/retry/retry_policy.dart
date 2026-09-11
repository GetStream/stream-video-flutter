import 'dart:math';

import 'package:equatable/equatable.dart';

const _maxJitterMs = 500;
const _minDelay = Duration(milliseconds: 200);
const _defaultRpcMaxRetries = 5;
const _defaultMaxBackoff = Duration(seconds: 3);
const _defaultMaxTotalRetryDelay = Duration(seconds: 30);
const _defaultSfuRpcMaxRetries = 3;
const _defaultSfuRpcTimeout = Duration(seconds: 10);

final Random _rnd = Random();

typedef Backoff = Duration Function(RetryConfig config, int retryAttempt);

class RetryPolicy {
  const RetryPolicy({
    this.config = const RetryConfig(),
    Backoff backoff = _defaultBackoff,
  }) : _backoff = backoff;

  final RetryConfig config;
  final Backoff _backoff;

  /// The delay before the attempt following [retryAttempt] failures.
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

class RetryConfig extends Equatable {
  const RetryConfig({
    this.rpcMaxRetries = _defaultRpcMaxRetries,
    this.maxBackoff = _defaultMaxBackoff,
    this.maxTotalRetryDelay = _defaultMaxTotalRetryDelay,
    this.sfuRpcMaxRetries = _defaultSfuRpcMaxRetries,
    this.sfuRpcTimeout = _defaultSfuRpcTimeout,
  });

  /// How many attempts a coordinator HTTP request gets in total, the first one
  /// included.
  final int rpcMaxRetries;

  /// The ceiling on the computed backoff between attempts.
  final Duration maxBackoff;

  /// The total time retrying may add to a single coordinator HTTP request. Not applied to SFU signalling retries.
  final Duration maxTotalRetryDelay;

  /// How many attempts an SFU signalling RPC gets in total, the first one
  /// included.
  final int sfuRpcMaxRetries;

  /// How long one SFU signalling attempt may take before it is abandoned.
  final Duration sfuRpcTimeout;

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [
    rpcMaxRetries,
    maxBackoff,
    maxTotalRetryDelay,
    sfuRpcMaxRetries,
    sfuRpcTimeout,
  ];
}
