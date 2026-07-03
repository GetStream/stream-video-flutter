import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_transport.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';

void main() {
  final cid = StreamCallCid(cid: 'default:call123');

  late List<Map<String, dynamic>> captured;
  late ClientEventReporter reporter;

  setUp(() {
    captured = [];
    final mockClient = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      for (final event in body['events'] as List) {
        captured.add((event as Map).cast<String, dynamic>());
      }
      return http.Response('', 200);
    });

    reporter = ClientEventReporter(
      transport: ClientEventTransport(
        baseUrl: 'https://example.com',
        apiKey: 'key',
        httpClient: mockClient,
        retryConfig: const ClientEventRetryConfig(maxAttempts: 1),
      ),
      resolveUserId: () => 'user-1',
    );
  });

  // Sends are fire-and-forget; let the microtask/event queue drain.
  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('JoinInitiated is a single unpaired event with common fields', () async {
    reporter
      ..registerCall(cid)
      ..reportEvent(cid, ClientEventStage.joinInitiated);
    await flush();

    expect(captured, hasLength(1));
    final event = captured.single;
    expect(event['stage'], 'JoinInitiated');
    expect(event['event_type'], 'initiated');
    expect(event['user_id'], 'user-1');
    expect(event['type'], 'default');
    expect(event['id'], 'call123');
    expect(event['join_attempt_id'], isNotEmpty);
    expect(event['join_reason'], 'first-attempt');
    expect(event['sdk_version'], isNotEmpty);
    expect(event.containsKey('stage_id'), isFalse);
    // call_cid is not sent — the backend derives it from type + id, matching
    // Swift/Android.
    expect(event.containsKey('call_cid'), isFalse);
  });

  test('begin/complete share a stage_id and record the outcome', () async {
    reporter.registerCall(cid);
    final stageId = reporter.beginStage(cid, ClientEventStage.coordinatorJoin);
    reporter.completeStage(
      stageId,
      outcome: ClientEventOutcome.success,
      retryCount: 2,
    );
    await flush();

    expect(captured, hasLength(2));
    expect(captured[0]['event_type'], 'initiated');
    expect(captured[0]['stage_id'], stageId);
    expect(captured[1]['event_type'], 'completed');
    expect(captured[1]['stage_id'], stageId);
    expect(captured[1]['outcome'], 'success');
    expect(captured[1]['retry_count_attempt'], 2);
    expect(captured[1].containsKey('elapsed_time'), isTrue);
  });

  test('failStage emits a failure completion with code + reason', () async {
    reporter.registerCall(cid);
    final stageId = reporter.beginStage(cid, ClientEventStage.wsJoin);
    reporter.failStage(
      stageId,
      failure: const ClientEventFailure.requestTimeout('Timed out'),
    );
    await flush();

    final completed = captured.firstWhere(
      (e) => e['event_type'] == 'completed',
    );
    expect(completed['outcome'], 'failure');
    expect(completed['retry_failure_code'], 'REQUEST_TIMEOUT');
    expect(completed['retry_failure_reason'], 'Timed out');
  });

  test('abort fails every in-flight stage with the given code', () async {
    reporter.registerCall(cid);
    final stageId = reporter.beginStage(cid, ClientEventStage.wsJoin);
    reporter.abort(cid, ClientEventStandardCode.backendLeave);
    await flush();

    final completed = captured.firstWhere(
      (e) => e['event_type'] == 'completed',
    );
    expect(completed['stage_id'], stageId);
    expect(completed['outcome'], 'failure');
    expect(completed['retry_failure_code'], 'BACKEND_LEAVE');
  });

  test('newJoinAttempt mints a fresh id and updates join_reason', () async {
    reporter
      ..registerCall(cid)
      ..reportEvent(cid, ClientEventStage.joinInitiated);
    await flush();
    final firstId = captured.last['join_attempt_id'];
    expect(captured.last['join_reason'], 'first-attempt');

    reporter
      ..newJoinAttempt(cid, reason: JoinReason.migration)
      ..reportEvent(cid, ClientEventStage.joinInitiated);
    await flush();
    final secondId = captured.last['join_attempt_id'];

    expect(secondId, isNot(firstId));
    expect(captured.last['join_reason'], 'migration');
  });

  test(
    'setCallSessionId + setCoordinatorConnectId stamp later events',
    () async {
      reporter
        ..setCoordinatorConnectId('coord-1')
        ..registerCall(cid)
        ..setCallSessionId(cid, 'session-xyz')
        ..reportEvent(cid, ClientEventStage.joinInitiated);
      await flush();

      final event = captured.single;
      expect(event['coordinator_connect_id'], 'coord-1');
      expect(event['call_session_id'], 'session-xyz');
    },
  );

  test(
    'connection-scoped stage carries coordinator_connect_id, no join id',
    () async {
      // No registerCall — CoordinatorWS is connection-scoped, not call-scoped.
      final stageId = reporter.beginConnectionStage(
        ClientEventStage.coordinatorWs,
        connectId: 'connect-abc',
      );
      reporter.completeStage(stageId, outcome: ClientEventOutcome.success);
      await flush();

      expect(captured, hasLength(2));
      final initiated = captured[0];
      expect(initiated['stage'], 'CoordinatorWS');
      expect(initiated['coordinator_connect_id'], 'connect-abc');
      expect(initiated['stage_id'], stageId);
      expect(initiated.containsKey('join_attempt_id'), isFalse);
      expect(initiated.containsKey('call_cid'), isFalse);

      expect(captured[1]['event_type'], 'completed');
      expect(captured[1]['outcome'], 'success');
      expect(captured[1]['coordinator_connect_id'], 'connect-abc');
    },
  );

  test('completion re-sends the join_attempt_id captured at begin', () async {
    reporter.registerCall(cid);
    final stageId = reporter.beginStage(cid, ClientEventStage.coordinatorJoin);
    // A rejoin mints a new attempt id AFTER this stage began.
    reporter.newJoinAttempt(cid, reason: JoinReason.fullRejoin);
    reporter.completeStage(stageId, outcome: ClientEventOutcome.success);
    await flush();

    expect(captured, hasLength(2));
    expect(
      captured[1]['join_attempt_id'],
      captured[0]['join_attempt_id'],
      reason: 'completion must reuse the begin-time attempt id',
    );
  });

  test('completion picks up call_session_id set after begin', () async {
    // Reproduces the CoordinatorJoin case: session id is only known after the
    // stage's initiated event, but the backend requires it on the success.
    reporter.registerCall(cid);
    final stageId = reporter.beginStage(cid, ClientEventStage.coordinatorJoin);
    reporter.setCallSessionId(cid, 'session-late');
    reporter.completeStage(stageId, outcome: ClientEventOutcome.success);
    await flush();

    expect(captured, hasLength(2));
    // initiated fired before the session id was known.
    expect(captured[0].containsKey('call_session_id'), isFalse);
    // completion must carry it.
    expect(captured[1]['call_session_id'], 'session-late');
  });

  test('stages before registerCall are ignored', () async {
    final stageId = reporter.beginStage(cid, ClientEventStage.coordinatorWs);
    await flush();

    expect(stageId, isEmpty);
    expect(captured, isEmpty);
  });

  test(
    'failStageWithError classifies offline errors as NETWORK_OFFLINE',
    () async {
      reporter.registerCall(cid);
      final offlineStage = reporter.beginStage(
        cid,
        ClientEventStage.coordinatorJoin,
      );
      reporter.failStageWithError(
        offlineStage,
        http.ClientException('Failed host lookup: video.stream-io-api.com'),
      );
      // A server-responded error is NOT offline.
      final serverStage = reporter.beginStage(cid, ClientEventStage.wsJoin);
      reporter.failStageWithError(
        serverStage,
        http.ClientException('Connection reset by peer'),
      );
      await flush();

      final offline = captured.firstWhere(
        (e) => e['stage_id'] == offlineStage && e['event_type'] == 'completed',
      );
      expect(offline['retry_failure_code'], 'NETWORK_OFFLINE');
      final server = captured.firstWhere(
        (e) => e['stage_id'] == serverStage && e['event_type'] == 'completed',
      );
      expect(server['retry_failure_code'], 'SERVER_ERROR');
    },
  );

  test('injected clock + id generator make output deterministic', () async {
    final ids = <String>['id-1', 'id-2', 'id-3'];
    var clockMs = 1000;
    final reporter = ClientEventReporter(
      transport: ClientEventTransport(
        baseUrl: 'https://example.com',
        apiKey: 'key',
        httpClient: MockClient((request) async {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          for (final event in body['events'] as List) {
            captured.add((event as Map).cast<String, dynamic>());
          }
          return http.Response('', 200);
        }),
        retryConfig: const ClientEventRetryConfig(maxAttempts: 1),
      ),
      resolveUserId: () => 'user-1',
      generateId: () => ids.removeAt(0),
      now: () => DateTime.fromMillisecondsSinceEpoch(clockMs, isUtc: true),
    );

    reporter.registerCall(cid); // consumes id-1 for join_attempt_id
    final stageId = reporter.beginStage(cid, ClientEventStage.coordinatorJoin);
    clockMs = 1500; // 500ms elapsed
    reporter.completeStage(stageId, outcome: ClientEventOutcome.success);
    await flush();

    expect(stageId, 'id-2');
    expect(captured[0]['join_attempt_id'], 'id-1');
    expect(captured[1]['elapsed_time'], 500);
  });

  test('no-op reporter emits nothing', () async {
    const noop = ClientEventReporter.noOp();
    expect(noop.beginStage(cid, ClientEventStage.wsJoin), isEmpty);
    noop
      ..registerCall(cid)
      ..reportEvent(cid, ClientEventStage.joinInitiated)
      ..abort(cid, ClientEventStandardCode.clientAborted);
    await flush();

    expect(captured, isEmpty);
  });
}
