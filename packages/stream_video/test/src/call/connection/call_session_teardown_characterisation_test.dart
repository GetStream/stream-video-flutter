import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
        // Nothing reads the peer connections of a session that never started,
        // except the stats reporter it was given anyway: flushing it on the
        // next attempt asks for publisher and subscriber stats.
        verify(() => first.rtcManager).called(2);
      },
    );
  });
}
