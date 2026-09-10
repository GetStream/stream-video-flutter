import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart'
    as sfu_models;
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:stream_video/src/utils/result.dart';
import 'package:tart/tart.dart';

/// Builds a client whose transport is [interceptor], so a test can decide what
/// every RPC attempt sees.
SfuClient _client(
  Method<dynamic, dynamic> Function(Method<dynamic, dynamic>) interceptor, {
  int rpcMaxRetries = 2,
}) {
  return SfuClient(
    baseUrl: 'http://localhost:0',
    sfuToken: 'test-token',
    sessionSeq: 0,
    tracer: Tracer(null),
    interceptors: [interceptor],
    rpcTimeout: const Duration(milliseconds: 200),
    rpcMaxRetries: rpcMaxRetries,
    retryPolicy: _noDelayPolicy,
  );
}

Duration _zero(RetryConfig config, int retryAttempt) => Duration.zero;

const _noDelayPolicy = RetryPolicy(backoff: _zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SfuClient retries transport failures', () {
    // The retry loop used to catch only TimeoutException, so anything else a
    // transport can raise — a dropped connection, a DNS failure, a Twirp
    // transport error — escaped the loop on the first attempt and the whole
    // budget went unused. The same failure against the coordinator got five
    // attempts.
    test(
      'retries a thrown transport failure until the budget runs out',
      () async {
        var attempts = 0;

        final client = _client((next) {
          return (Context ctx, dynamic req) {
            attempts++;
            throw const SocketFailure();
          };
        });

        final result = await client.sendAnswer(sfu.SendAnswerRequest());

        expect(result.isFailure, isTrue);
        expect(
          attempts,
          2,
          reason: 'a transport failure is not a verdict, so it is retried',
        );
      },
    );

    test('reports the transport failure it gave up on', () async {
      final client = _client((next) {
        return (Context ctx, dynamic req) => throw const SocketFailure();
      }, rpcMaxRetries: 1);

      final result = await client.sendAnswer(sfu.SendAnswerRequest());

      expect(result.isFailure, isTrue);
      // Not the 'Unexpected error: null' the exhausted path used to produce.
      expect(result.getErrorOrNull()?.message, contains('connection reset'));
    });
  });

  // `rpcMaxRetries`/`rpcTimeout` used to be SfuClient's own defaults, which
  // CallSession never passed — so an integrator raising RetryConfig changed the
  // coordinator's budget and left SFU signalling at 3 attempts of 10s.
  group('SfuClient takes its budget from RetryConfig', () {
    test('reads the SFU attempt count and timeout from the policy', () {
      final client = SfuClient(
        baseUrl: 'http://localhost:0',
        sfuToken: 'test-token',
        sessionSeq: 0,
        tracer: Tracer(null),
        retryPolicy: const RetryPolicy(
          config: RetryConfig(
            sfuRpcMaxRetries: 7,
            sfuRpcTimeout: Duration(seconds: 4),
          ),
        ),
      );

      expect(client.rpcMaxRetries, 7);
      expect(client.rpcTimeout, const Duration(seconds: 4));
    });

    // The coordinator's budget is deliberately not the SFU's: an SFU attempt
    // is waited on inside a join, and nothing above the loop caps its total.
    test('does not read the coordinator attempt count', () {
      final client = SfuClient(
        baseUrl: 'http://localhost:0',
        sfuToken: 'test-token',
        sessionSeq: 0,
        tracer: Tracer(null),
        retryPolicy: const RetryPolicy(config: RetryConfig(rpcMaxRetries: 99)),
      );

      expect(client.rpcMaxRetries, 3);
    });

    test('spends the policy budget on a failing RPC', () async {
      var attempts = 0;

      final client = SfuClient(
        baseUrl: 'http://localhost:0',
        sfuToken: 'test-token',
        sessionSeq: 0,
        tracer: Tracer(null),
        interceptors: [
          (next) => (Context ctx, dynamic req) {
            attempts++;
            throw const SocketFailure();
          },
        ],
        retryPolicy: const RetryPolicy(
          config: RetryConfig(sfuRpcMaxRetries: 4),
          backoff: _zero,
        ),
      );

      final result = await client.sendAnswer(sfu.SendAnswerRequest());

      expect(result.isFailure, isTrue);
      expect(attempts, 4, reason: 'the config bought four attempts');
    });
  });

  group('SfuClient honours the SFU verdict', () {
    test('does not retry an error the SFU did not mark shouldRetry', () async {
      var attempts = 0;

      final client = _client((next) {
        return (Context ctx, dynamic req) async {
          attempts++;
          return sfu.SendAnswerResponse(
            error: sfu_models.Error(
              code: sfu_models.ErrorCode.ERROR_CODE_PERMISSION_DENIED,
              message: 'not allowed',
              shouldRetry: false,
            ),
          );
        };
      });

      final result = await client.sendAnswer(sfu.SendAnswerRequest());

      expect(result.isFailure, isTrue);
      expect(attempts, 1, reason: 'the server settled it on the first answer');
      expect(result.getErrorOrNull()?.message, 'not allowed');
    });

    test('retries an error the SFU marked shouldRetry', () async {
      var attempts = 0;

      final client = _client((next) {
        return (Context ctx, dynamic req) async {
          attempts++;
          return sfu.SendAnswerResponse(
            error: sfu_models.Error(
              code: sfu_models.ErrorCode.ERROR_CODE_INTERNAL_SERVER_ERROR,
              message: 'try again',
              shouldRetry: true,
            ),
          );
        };
      });

      final result = await client.sendAnswer(sfu.SendAnswerRequest());

      expect(result.isFailure, isTrue);
      expect(attempts, 2);
    });

    test('returns the response when the SFU reports no error', () async {
      final client = _client((next) {
        return (Context ctx, dynamic req) async => sfu.SendAnswerResponse();
      });

      final result = await client.sendAnswer(sfu.SendAnswerRequest());

      expect(result.isSuccess, isTrue);
    });
  });
}

/// Stands in for what a transport raises when a connection dies mid-request:
/// an [Exception] that is not a [TimeoutException].
class SocketFailure implements Exception {
  const SocketFailure();

  @override
  String toString() => 'SocketFailure: connection reset by peer';
}
