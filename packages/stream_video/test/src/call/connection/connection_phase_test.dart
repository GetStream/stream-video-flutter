import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins the behaviour the connection phase owns: leaving is final, and each
/// reconnect counts its attempts afresh.
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
    },
  );

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
