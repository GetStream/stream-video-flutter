import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/call/stats/sfu_stats_reporter.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';

class MockRtcManager extends Mock implements RtcManager {}

class FakeSubscriber extends Fake implements TracedStreamPeerConnection {
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
      rawStats: <Map<String, dynamic>>[
        {'type': 'test'},
      ],
    );
  }
}

SfuStatsReporter _createReporter({
  required MockCallSession callSession,
  required MockSfuClient sfuClient,
  required FakeSubscriber subscriber,
}) {
  final rtcManager = MockRtcManager();
  when(() => rtcManager.subscriber).thenReturn(subscriber);
  when(() => rtcManager.publisher).thenReturn(null);
  when(() => callSession.rtcManager).thenReturn(rtcManager);

  when(
    () => sfuClient.sendStats(any()),
  ).thenAnswer(
    (_) async => Result.success(sfu.SendStatsResponse()),
  );

  return SfuStatsReporter(
    callSession: callSession,
    stateManager: CallStateNotifier(createTestCallState()),
    statsOptions: StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(sfu.SendStatsRequest());

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/battery'),
          (call) async {
            if (call.method == 'isInBatterySaveMode') {
              return false;
            }
            return null;
          },
        );
  });

  group('SfuStatsReporter.flush', () {
    late MockCallSession callSession;
    late MockSfuClient sfuClient;
    late FakeSubscriber subscriber;

    setUp(() {
      callSession = MockCallSession();
      sfuClient = MockSfuClient();
      subscriber = FakeSubscriber();

      when(() => callSession.sessionId).thenReturn('test-session-id');
      when(() => callSession.sfuClient).thenReturn(sfuClient);
      when(callSession.getTrace).thenReturn(
        [
          TraceSlice(
            snapshot: [],
            rollback: () {},
          ),
        ],
      );
    });

    test('sends stats on flush before stop', () async {
      final reporter = _createReporter(
        callSession: callSession,
        sfuClient: sfuClient,
        subscriber: subscriber,
      );

      await reporter.flush();
      reporter.stop();

      verify(() => sfuClient.sendStats(any())).called(1);
    });

    test('flush is a no-op after stop', () async {
      final reporter = _createReporter(
        callSession: callSession,
        sfuClient: sfuClient,
        subscriber: subscriber,
      );

      reporter.stop();
      await reporter.flush();

      verifyNever(() => sfuClient.sendStats(any()));
    });
  });
}
