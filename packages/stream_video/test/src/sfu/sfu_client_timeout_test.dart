// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:tart/tart.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SfuClient RPC timeout', () {
    test(
      'returns Result.failure when the SFU HTTP call hangs past rpcTimeout',
      () async {
        // An interceptor that never resolves — simulates a hung upstream.
        // The Completer must carry the concrete response type so tart's
        // return-type check in sendAnswer(...) async { return interceptor...}
        // does not fail before the timeout fires.
        Method<dynamic, dynamic> hangingInterceptor(
          Method<dynamic, dynamic> next,
        ) {
          return (Context ctx, dynamic req) =>
              Completer<sfu.SendAnswerResponse>().future;
        }

        final client = SfuClient(
          baseUrl: 'http://localhost:0',
          sfuToken: 'test-token',
          sessionSeq: 0,
          tracer: Tracer(null),
          interceptors: [hangingInterceptor],
          rpcTimeout: const Duration(milliseconds: 100),
          rpcMaxRetries: 1,
        );

        final stopwatch = Stopwatch()..start();
        final result = await client.sendAnswer(sfu.SendAnswerRequest());
        stopwatch.stop();

        expect(
          result.isFailure,
          isTrue,
          reason: 'hanging call must return failure after timeout',
        );
        expect(
          stopwatch.elapsed,
          lessThan(const Duration(milliseconds: 1000)),
          reason: 'must fail well before the default 10 s timeout',
        );
      },
    );
  });
}
