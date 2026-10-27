import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart';
import 'package:stream_video/src/coordinator/open_api/coordinator_client_open_api.dart';
import 'package:stream_video/src/latency/latency_service.dart';
import 'package:stream_video/src/latency/latency_settings.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/retry/retry_policy.dart';
import 'package:stream_video/src/token/token_source.dart';
import 'package:stream_video/src/utils/result.dart';

/// Pins that both of the coordinator's HTTP clients mark their requests, so a
/// failed one is named in the error it fails with.
void main() {
  late HttpServer server;
  late List<HttpRequest> requests;
  late CoordinatorClientOpenApi client;

  setUp(() async {
    requests = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      requests.add(request);
      request.response
        ..statusCode = HttpStatus.serviceUnavailable
        ..write('<html>Service Unavailable</html>');
      await request.response.close();
    });

    client = CoordinatorClientOpenApi(
      rpcUrl: 'http://127.0.0.1:${server.port}',
      wsUrl: 'ws://127.0.0.1:${server.port}',
      apiKey: 'api-key-secret',
      tokenSource: TokenSource(
        TokenManager(
          userId: 'user-1',
          tokenProvider: TokenProvider.static(
            UserToken(_unsignedJwt('user-1')),
          ),
        ),
      ),
      latencyService: const LatencyService(settings: LatencySettings()),
      // One attempt, so the 503 is the failure rather than a retry's.
      retryPolicy: const RetryPolicy(config: RetryConfig(rpcMaxRetries: 1)),
    );
  });

  tearDown(() => server.close(force: true));

  void expectNamed(Result<Object?> result) {
    final message = (result as Failure).videoError.message;
    final request = requests.single;

    expect(
      message,
      startsWith('HTTP 503 ${request.method} 127.0.0.1${request.uri.path} '),
    );
    expect(message, isNot(contains('api-key-secret')));
  }

  test('names a failed request', () async {
    final result = await client.getCall(
      callCid: StreamCallCid(cid: 'default:x'),
    );

    expectNamed(result);
  });

  // The guest client is built apart from the main one.
  test('names a failed guest request', () async {
    final result = await client.loadGuest(id: 'guest-1');

    expectNamed(result);
  });
}

/// A token for [userId] that is only ever read, never verified.
String _unsignedJwt(String userId) {
  String encode(Map<String, Object> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');

  final header = encode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = encode({'user_id': userId});
  return '$header.$payload.c2lnbmF0dXJl';
}
