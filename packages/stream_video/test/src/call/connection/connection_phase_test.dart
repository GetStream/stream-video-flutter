import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins the behaviour the connection phase owns: leaving is terminal, a join
/// refused before it starts leaves the call idle, and each reconnect counts
/// its attempts afresh.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  test(
    'a leave whose teardown throws still settles disconnected, and a later '
    'leave does not tear down again',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.leave(), throwsStateError);

      expect(call.state.value.status, isA<CallStatusDisconnected>());

      await call.leave();

      verify(
        () => harness.session.leave(reason: any(named: 'reason')),
      ).called(1);
      final rejoin = await call.join();
      expect(rejoin.getErrorOrNull()?.message, 'call was left');
    },
  );

  test(
    'a teardown that throws early still removes the call from the active '
    'calls',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        harness.streamVideo.isAudioProcessorConfigured,
      ).thenThrow(StateError('teardown failed'));
      clearInteractions(harness.streamVideo.state);

      await expectLater(call.leave(), throwsStateError);

      verify(
        () => harness.streamVideo.state.removeActiveCall(call),
      ).called(greaterThan(0));
    },
  );

  test(
    'an end whose teardown throws still ends the call on the server and '
    'settles disconnected as ended',
    () async {
      when(
        () => harness.permissionsManager.endCall(),
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.end(), throwsStateError);

      verify(() => harness.permissionsManager.endCall()).called(1);
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonEnded>());
    },
  );

  test('a leave during a fast reconnect that then succeeds stays '
      'disconnected', () async {
    final call = harness.buildCall();
    await call.join();
    final reconnectGate = Completer<void>();
    harness.stubFastReconnect(harness.session, () async {
      await reconnectGate.future;
      return sessionStartSuccess();
    });
    await harness.emitSfu(harness.session, sfuSocketDropped);
    expect(call.state.value.status, isA<CallStatusReconnecting>());

    await call.leave();
    reconnectGate.complete();
    await pumpEventQueue();

    expect(call.state.value.status, isA<CallStatusDisconnected>());
  });

  test('a join refused before it starts can be retried', () async {
    final call = harness.buildCall();
    final activeCalls =
        harness.streamVideo.state.activeCalls
            as MutableStateEmitter<List<Call>>;
    activeCalls.value = [harness.buildCall()];

    final refused = await call.join();
    expect(
      refused.getErrorOrNull()?.message,
      'a call with the same cid is in progress',
    );

    activeCalls.value = [];
    final retried = await call.join();

    expect(retried.isSuccess, isTrue);
    expect(call.state.value.status, isA<CallStatusConnected>());
  });

  test('each reconnect counts its attempts from 1', () async {
    final call = harness.buildCall();
    await call.join();
    harness.stubFastReconnect(
      harness.session,
      () async => sessionStartSuccess(),
    );
    final statuses = recordStatuses(call);

    Future<void> dropAndReconnect() async {
      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() => call.state.value.status.isConnected);
    }

    await dropAndReconnect();
    await dropAndReconnect();

    final attempts = statuses
        .whereType<CallStatusReconnecting>()
        .map((status) => status.attempt)
        .toSet();
    expect(attempts, {1});
    // The status recorded on listening, then one per reconnect.
    expect(statuses.whereType<CallStatusConnected>(), hasLength(3));
  });
}
