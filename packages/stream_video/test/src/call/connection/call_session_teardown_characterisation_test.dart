import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins what is left behind by an SFU session that fails to start, so moving
/// the connection code out of `Call` cannot change it unnoticed.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness(sessionCount: 2));
  tearDown(() => harness.dispose());

  group('known hazard', () {
    // Changes with FLU-861: the SFU stats reporter is only wired for a session
    // that started.
    test(
      'a session that fails to start still gets an SFU stats reporter, which '
      'the next attempt flushes',
      () async {
        final first = harness.sessions.first;
        final rtcManager = _MockRtcManager();
        when(() => rtcManager.subscriber).thenReturn(_FakeSubscriber());
        when(() => rtcManager.publisher).thenReturn(null);
        when(() => first.rtcManager).thenReturn(rtcManager);
        harness.stubSessionStart(
          first,
          () async => const Result.failure(
            StreamVideoException(message: 'sfu unreachable'),
          ),
        );
        final call = harness.buildCall();

        final result = await call.join();

        expect(result.isSuccess, isTrue);
        harness.verifyMakeCallSessionCount(2);
        // The next attempt flushes the failed session's stats reporter.
        verify(() => first.sfuClient.sendStats(any())).called(1);
      },
    );
  });
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

/// A subscriber whose stats are empty but present, so a flush sends them.
class _FakeSubscriber extends Fake implements TracedStreamPeerConnection {
  @override
  Future<void> dispose() async {}

  @override
  final Tracer tracer = Tracer('subscriber');

  @override
  Future<
    ({
      List<RtcStats> rtcStats,
      RtcPrintableStats printable,
      List<Map<String, dynamic>> rawStats,
    })
  >
  getStats() async {
    return (
      rtcStats: <RtcStats>[],
      printable: const RtcPrintableStats(local: '', remote: ''),
      rawStats: <Map<String, dynamic>>[],
    );
  }
}
