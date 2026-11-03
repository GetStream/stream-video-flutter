import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_client_open_api.dart';
import 'package:stream_video/src/latency/latency_service.dart';
import 'package:stream_video/src/latency/latency_settings.dart';
import 'package:stream_video/src/location/location_service.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/token/token_source.dart';

class _FixedLocationService extends LocationService {
  @override
  Future<String> getLocation({
    Duration timeout = const Duration(milliseconds: 2000),
    int maxAttempts = 3,
  }) async => 'AMS';
}

Duration _noBackoff(RetryConfig config, int retryAttempt) => Duration.zero;

/// The coordinator client against a server that accepts every request and
/// never answers.
void main() {
  const policy = RetryPolicy(
    config: RetryConfig(rpcTimeout: Duration(milliseconds: 100)),
    backoff: _noBackoff,
  );

  late HttpServer server;
  late List<HttpRequest> unanswered;
  late CoordinatorClientOpenApi client;

  setUp(() async {
    // The test binding answers every request itself; these need real sockets.
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    addTearDown(() => HttpOverrides.global = overrides);

    unanswered = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen(unanswered.add);

    client = CoordinatorClientOpenApi(
      rpcUrl: 'http://${server.address.host}:${server.port}',
      wsUrl: 'ws://${server.address.host}:${server.port}',
      apiKey: 'test-key',
      tokenSource: TokenSource(
        TokenManager(
          userId: User.anonymousUserId,
          tokenProvider: TokenProvider.static(UserToken.anonymous()),
        ),
      ),
      latencyService: const LatencyService(settings: LatencySettings()),
      retryPolicy: policy,
      isAnonymous: true,
      locationService: _FixedLocationService(),
    );
  });

  tearDown(() => server.close(force: true));

  test('a join the server never answers fails once, unrepeated', () async {
    final stopwatch = Stopwatch()..start();

    final result = await client.joinCall(
      callCid: StreamCallCid(cid: 'default:test'),
    );

    expect(result, isA<Failure>());
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
    expect(unanswered, hasLength(1));
  });

  test('a guest the server never answers fails once, unrepeated', () async {
    final stopwatch = Stopwatch()..start();

    final result = await client.loadGuest(id: 'guest-1');

    expect(result, isA<Failure>());
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 2)));
    expect(unanswered, hasLength(1));
  });
}
