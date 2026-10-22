import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/call.dart' show CallConnectionCoordinator;
import 'package:stream_video/src/coordinator/models/coordinator_models.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_client_open_api.dart';
import 'package:stream_video/src/errors/stream_video_exception_composer.dart';
import 'package:stream_video/src/http/stream_retry_interceptor.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

Duration _noBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

/// A coordinator join whose server accepts the request and never answers.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  const policy = RetryPolicy(
    config: RetryConfig(rpcTimeout: Duration(milliseconds: 100)),
    backoff: _noBackoff,
  );

  late HttpServer server;
  late List<HttpRequest> unanswered;
  late Dio dio;

  setUp(() async {
    // The test binding answers every request itself; these need real sockets.
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = overrides);

    unanswered = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(unanswered.add);

    final rpcUrl = 'http://${server.address.host}:${server.port}';
    dio = Dio(coordinatorHttpOptions(rpcUrl, policy.config));
    dio.interceptors.add(StreamRetryInterceptor(dio: dio, policy: policy));
  });

  tearDown(() async {
    dio.close(force: true);
    await server.close(force: true);
  });

  /// A join sent to the silent server, failing the way the coordinator client
  /// reports it.
  Future<Result<CoordinatorJoined>> hangingJoin() async {
    try {
      await dio.post<Object?>('/video/call/default/test/join');
      fail('the silent server answered');
    } on DioException catch (error, stackTrace) {
      return Result.failure(
        StreamVideoExceptions.compose(error.toStreamException(), stackTrace),
        stackTrace,
      );
    }
  }

  test(
    'a reconnect attempt whose coordinator join hangs ends, and the next '
    'attempt reconnects',
    () async {
      // The rejoin's stability window is not what this test is about.
      final stabilityWindow = CallConnectionCoordinator.rejoinStabilityWindow;
      CallConnectionCoordinator.rejoinStabilityWindow = const Duration(
        milliseconds: 10,
      );
      addTearDown(
        () => CallConnectionCoordinator.rejoinStabilityWindow = stabilityWindow,
      );

      final harness = ConnectionHarness(sessionCount: 2);
      addTearDown(harness.dispose);

      final call = harness.buildCall(retryPolicy: policy);
      await call.join();
      expect(call.state.value.status, isA<CallStatusConnected>());

      // Every join of the first rejoin attempt hangs; the next one answers.
      const hangingJoins = 3;
      var joins = 0;
      harness.stubJoinCall(() async {
        joins++;
        if (joins <= hangingJoins) return hangingJoin();
        return Result.success(SampleCallData.coordinatorJoinedSuccess);
      });
      final statuses = recordStatuses(call);

      harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
      await waitUntil(
        () => call.state.value.status is CallStatusConnected,
        timeout: const Duration(seconds: 20),
      );

      expect(joins, hangingJoins + 1);
      expect(unanswered, hasLength(hangingJoins));
      final attempts = statuses
          .whereType<CallStatusReconnecting>()
          .map((status) => status.attempt)
          .toSet();
      expect(attempts, {1, 2});
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
