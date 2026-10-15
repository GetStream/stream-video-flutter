import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../../logger/impl/test_logger.dart';
import '../fixtures/connection_harness.dart';

/// Pins the wait for a ring to be answered: it ends with the call, not with
/// its own timer.
void main() {
  const timeout = Duration(milliseconds: 100);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() {
    harness = ConnectionHarness();
    // An unanswered ring is rejected on the way out.
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  });
  tearDown(() => harness.dispose());

  Call ringingCall(CallStatus status) {
    final call = harness.buildCall(status: status);
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      settings: const CallSettings(
        ring: StreamRingSettings(
          autoRejectTimeout: timeout,
          autoCancelTimeout: timeout,
        ),
      ),
    );
    return call;
  }

  for (final (name, status) in [
    ('an incoming', CallStatus.incoming()),
    ('an outgoing', CallStatus.outgoing()),
  ]) {
    test('the wait for $name ring stops when the call is left', () async {
      final logger = installRecordingLogger();
      final call = ringingCall(status);

      final joining = call.join();
      await pumpEventQueue();
      await call.leave();

      expect((await joining).isFailure, isTrue);
      await Future<void>.delayed(timeout * 3);
      expect(
        logger.errors.where((message) => message.contains('ToBeAccepted')),
        isEmpty,
      );
    });

    test('the wait for $name ring fails the join when unanswered', () async {
      final logger = installRecordingLogger();
      final call = ringingCall(status);

      final result = await call.join();

      expect(result.isFailure, isTrue);
      expect(
        logger.errors.where((message) => message.contains('ToBeAccepted')),
        hasLength(1),
      );
      harness.verifyJoinCallCount(0);
    });
  }

  test('an incoming ring accepted during the wait joins', () async {
    final call = ringingCall(CallStatus.incoming());

    final joining = call.join();
    await pumpEventQueue();
    harness.stateManager.lifecycleCallAccepted();

    expect((await joining).isSuccess, isTrue);
  });
}
