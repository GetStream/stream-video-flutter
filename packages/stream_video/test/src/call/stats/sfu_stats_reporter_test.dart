import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/call/stats/sfu_stats_reporter.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../../../test_helpers.dart';

class MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() {
    return Future.value();
  }
}

class FakeSubscriber extends Fake implements TracedStreamPeerConnection {
  @override
  Future<void> dispose() {
    return Future.value();
  }

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

/// A subscriber whose `getStats` never completes.
class UnresponsiveSubscriber extends FakeSubscriber {
  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  Future<
    ({
      List<RtcStats> rtcStats,
      RtcPrintableStats printable,
      List<Map<String, dynamic>> rawStats,
    })
  >
  getStats() {
    return Completer<
          ({
            List<RtcStats> rtcStats,
            RtcPrintableStats printable,
            List<Map<String, dynamic>> rawStats,
          })
        >()
        .future;
  }
}

/// A subscriber whose first `getStats` never completes; later ones do.
class FirstUnresponsiveSubscriber extends FakeSubscriber {
  var _calls = 0;

  @override
  Future<void> dispose() {
    return Future.value();
  }

  @override
  Future<
    ({
      List<RtcStats> rtcStats,
      RtcPrintableStats printable,
      List<Map<String, dynamic>> rawStats,
    })
  >
  getStats() {
    if (_calls++ == 0) {
      return Completer<
            ({
              List<RtcStats> rtcStats,
              RtcPrintableStats printable,
              List<Map<String, dynamic>> rawStats,
            })
          >()
          .future;
    }
    return super.getStats();
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
    statsOptions: const StatsOptions(
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

    test('a getStats that never completes does not hold up reports', () {
      fakeAsync((async) {
        final reporter = _createReporter(
          callSession: callSession,
          sfuClient: sfuClient,
          subscriber: UnresponsiveSubscriber(),
        );

        var firstDone = false;
        var secondDone = false;
        reporter.sendSfuStats().then((_) => firstDone = true);
        reporter.sendSfuStats().then((_) => secondDone = true);

        async.elapse(const Duration(seconds: 6));
        expect(firstDone, isTrue);
        expect(secondDone, isFalse, reason: 'it waits for the lock');

        async.elapse(const Duration(seconds: 5));
        expect(secondDone, isTrue);
      });
    });

    test('sends only the flush once stopped, not a send queued before it', () {
      fakeAsync((async) {
        final reporter = _createReporter(
          callSession: callSession,
          sfuClient: sfuClient,
          subscriber: FirstUnresponsiveSubscriber(),
        );
        // A publisher that answers, so a send whose subscriber stats time
        // out still has something to send.
        final rtcManager = callSession.rtcManager!;
        when(() => rtcManager.publisher).thenReturn(FakeSubscriber());

        // Waits for the subscriber's stats until they time out.
        unawaited(reporter.sendSfuStats());
        async.flushMicrotasks();

        var flushed = false;
        reporter.flush().then((_) => flushed = true);
        async.elapse(const Duration(seconds: 2));
        expect(flushed, isTrue, reason: 'the flush gives up waiting');
        reporter.stop();

        async.elapse(const Duration(seconds: 10));

        verify(() => sfuClient.sendStats(any())).called(1);
      });
    });

    test(
      'does not send once stopped while the battery read is pending',
      () async {
        // A platform the battery saver mode is read on, and the thermal
        // status is not, whatever runs the test.
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;
        addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

        final batteryRead = Completer<bool>();
        var batteryAsked = false;
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/battery'),
          (call) {
            batteryAsked = true;
            return batteryRead.future;
          },
        );
        addTearDown(
          () => messenger.setMockMethodCallHandler(
            const MethodChannel('dev.fluttercommunity.plus/battery'),
            (call) async => false,
          ),
        );

        final reporter = _createReporter(
          callSession: callSession,
          sfuClient: sfuClient,
          subscriber: subscriber,
        );

        final send = reporter.sendSfuStats();
        await pumpEventQueue();
        expect(batteryAsked, isTrue);

        reporter.stop();
        batteryRead.complete(false);
        await send;

        verifyNever(() => sfuClient.sendStats(any()));
      },
    );

    test(
      'still sends a send kept after stop once the battery read is done',
      () async {
        // A platform the battery saver mode is read on, and the thermal
        // status is not, whatever runs the test.
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;
        addTearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

        final batteryRead = Completer<bool>();
        var batteryAsked = false;
        final messenger =
            TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        messenger.setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/battery'),
          (call) {
            batteryAsked = true;
            return batteryRead.future;
          },
        );
        addTearDown(
          () => messenger.setMockMethodCallHandler(
            const MethodChannel('dev.fluttercommunity.plus/battery'),
            (call) async => false,
          ),
        );

        final reporter = _createReporter(
          callSession: callSession,
          sfuClient: sfuClient,
          subscriber: subscriber,
        );

        final send = reporter.sendSfuStats(keepAfterStop: true);
        await pumpEventQueue();
        expect(batteryAsked, isTrue);

        reporter.stop();
        batteryRead.complete(false);
        await send;

        verify(() => sfuClient.sendStats(any())).called(1);
      },
    );
  });
}
