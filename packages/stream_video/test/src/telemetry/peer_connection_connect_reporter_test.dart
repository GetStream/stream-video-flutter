import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stream_video/src/models/call_cid.dart';
import 'package:stream_video/src/telemetry/client_event_reporter.dart';
import 'package:stream_video/src/telemetry/client_event_transport.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/src/telemetry/peer_connection_connect_reporter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

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
    reporter.registerCall(cid);
  });

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  PeerConnectionConnectReporter tracker({
    ClientEventPeerConnectionRole role =
        ClientEventPeerConnectionRole.subscribe,
  }) {
    return PeerConnectionConnectReporter(
      reporter: reporter,
      callCid: cid,
      role: role,
      sfuId: 'sfu-1',
    );
  }

  test(
    'checking then connected emits a success pair with role + sfu',
    () async {
      tracker(role: ClientEventPeerConnectionRole.publish)
        ..onIceConnectionState(
          rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
        )
        ..onConnectionState(
          rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
      await flush();

      expect(captured, hasLength(2));
      final initiated = captured[0];
      final completed = captured[1];
      expect(initiated['stage'], 'PeerConnectionConnect');
      expect(initiated['event_type'], 'initiated');
      expect(initiated['peer_connection'], 'publish');
      expect(initiated['sfu_id'], 'sfu-1');
      expect(initiated['was_previously_connected'], false);
      // Non-standard field must NOT be sent (Swift has no such field).
      expect(initiated.containsKey('user_session_id'), isFalse);

      expect(completed['event_type'], 'completed');
      expect(completed['outcome'], 'success');
      // A connected PC implies ICE connected, even though the test only drove
      // ICE to `checking` — success must report CONNECTED, not NOT_CONNECTED.
      expect(completed['ice_state'], 'CONNECTED');
      expect(completed['stage_id'], initiated['stage_id']);
      expect(completed['was_previously_connected'], false);
      // ice_state is now sent on success completions too (not just failures).
      expect(completed.containsKey('ice_state'), isTrue);
    },
  );

  test('ICE failure reports ICE_CONNECTIVITY_FAILED with ice_state', () async {
    tracker()
      ..onIceConnectionState(
        rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
      )
      ..onIceConnectionState(
        rtc.RTCIceConnectionState.RTCIceConnectionStateFailed,
      );
    await flush();

    final completed = captured.firstWhere(
      (e) => e['event_type'] == 'completed',
    );
    expect(completed['outcome'], 'failure');
    expect(completed['retry_failure_code'], 'ICE_CONNECTIVITY_FAILED');
    expect(completed['ice_state'], 'FAILED');
  });

  test('PC failure reports DTLS_CONNECTIVITY_FAILED', () async {
    tracker()
      ..onConnectionState(
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
      )
      ..onConnectionState(
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed,
      );
    await flush();

    final completed = captured.firstWhere(
      (e) => e['event_type'] == 'completed',
    );
    expect(completed['outcome'], 'failure');
    expect(completed['retry_failure_code'], 'DTLS_CONNECTIVITY_FAILED');
  });

  test(
    'a reconnect marks was_previously_connected on the next attempt',
    () async {
      final t = tracker()
        ..onIceConnectionState(
          rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
        )
        ..onConnectionState(
          rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
      // Second attempt (reconnect on the same PC instance).
      t
        ..onIceConnectionState(
          rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
        )
        ..onConnectionState(
          rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        );
      await flush();

      final initiateds = captured
          .where((e) => e['event_type'] == 'initiated')
          .toList();
      expect(initiateds, hasLength(2));
      expect(initiateds[0]['was_previously_connected'], false);
      expect(initiateds[1]['was_previously_connected'], true);
      expect(initiateds[1]['previously_connected_timestamp'], isNotNull);
    },
  );

  test('abortInFlight fails an in-progress attempt only', () async {
    final t = tracker()
      ..onIceConnectionState(
        rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
      )
      ..abortInFlight();
    await flush();

    final completed = captured.firstWhere(
      (e) => e['event_type'] == 'completed',
    );
    expect(completed['outcome'], 'failure');

    // A second abort with nothing in flight emits nothing more.
    captured.clear();
    t.abortInFlight();
    await flush();
    expect(captured, isEmpty);
  });
}
