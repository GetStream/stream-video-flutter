import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/stats_reporter.dart';
import 'package:stream_video/src/models/call_stats.dart';
import 'package:stream_video/src/webrtc/model/stats/rtc_stats_snapshot.dart';
import 'package:stream_video/src/webrtc/peer_type.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';

class _MockRtcManager extends Mock implements RtcManager {}

/// Counts how often the peer connection is actually asked for stats.
class _CountingPeerConnection extends Fake
    implements TracedStreamPeerConnection {
  int calls = 0;

  @override
  Future<RtcStatsSnapshot> getStats() async {
    calls++;
    return RtcStatsSnapshot(const [
      {'id': 'RTCCodec_1', 'type': 'codec', 'mimeType': 'video/H264'},
    ]);
  }
}

void main() {
  late _MockRtcManager rtcManager;
  late _CountingPeerConnection subscriber;

  setUp(() {
    rtcManager = _MockRtcManager();
    subscriber = _CountingPeerConnection();
    when(() => rtcManager.subscriber).thenReturn(subscriber);
    when(() => rtcManager.publisher).thenReturn(null);
  });

  StatsReporter buildReporter() => StatsReporter(
    rtcManager: rtcManager,
    clientEnvironment: ClientEnvironment.empty(),
  );

  group('RtcStatsSnapshot', () {
    test('derives the typed and printable views from the raw reports', () {
      final snapshot = RtcStatsSnapshot(const [
        {'id': 'RTCCodec_1', 'type': 'codec', 'mimeType': 'video/H264'},
      ]);

      expect(snapshot.rawStats, hasLength(1));
      expect(snapshot.rtcStats, hasLength(1));
      expect(snapshot.printable, isNotNull);
    });

    test('caches each derived view so repeat reads do not re-parse', () {
      final snapshot = RtcStatsSnapshot(const [
        {'id': 'RTCCodec_1', 'type': 'codec', 'mimeType': 'video/H264'},
      ]);

      expect(identical(snapshot.rtcStats, snapshot.rtcStats), isTrue);
      expect(identical(snapshot.printable, snapshot.printable), isTrue);
    });

    test('an empty snapshot derives empty views', () {
      final snapshot = RtcStatsSnapshot.empty();

      expect(snapshot.rawStats, isEmpty);
      expect(snapshot.rtcStats, isEmpty);
      expect(snapshot.printable.local, isEmpty);
      expect(snapshot.printable.remote, isEmpty);
    });
  });

  group('StatsReporter.run', () {
    test('a non-positive interval disables collection entirely', () async {
      final reporter = buildReporter();
      addTearDown(reporter.dispose);

      final events = await reporter
          .run(interval: Duration.zero)
          .toList()
          .timeout(const Duration(seconds: 1));

      expect(events, isEmpty);
      expect(subscriber.calls, 0);
    });

    test('skips collection while nothing observes the result', () async {
      final reporter = buildReporter();
      addTearDown(reporter.dispose);

      final subscription = reporter
          .run(
            interval: const Duration(milliseconds: 10),
            shouldCollect: () => false,
          )
          .listen((_) {});
      addTearDown(subscription.cancel);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(subscriber.calls, 0);
    });

    test('collects while something observes the result', () async {
      final reporter = buildReporter();
      addTearDown(reporter.dispose);

      final subscription = reporter
          .run(
            interval: const Duration(milliseconds: 10),
            shouldCollect: () => true,
          )
          .listen((_) {});
      addTearDown(subscription.cancel);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(subscriber.calls, greaterThan(0));
    });

    test('collects when the reporter itself has listeners', () async {
      final reporter = buildReporter();
      addTearDown(reporter.dispose);

      // A listener on the StateNotifier is enough to keep collection alive,
      // even when the caller says nothing else needs it.
      final removeListener = reporter.addListener((_) {});
      addTearDown(removeListener);

      final subscription = reporter
          .run(
            interval: const Duration(milliseconds: 10),
            shouldCollect: () => false,
          )
          .listen((_) {});
      addTearDown(subscription.cancel);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(subscriber.calls, greaterThan(0));
    });
  });

  group('PeerConnectionStatsBundle', () {
    test('exposes the snapshot views', () {
      final bundle = PeerConnectionStatsBundle(
        peerType: StreamPeerType.publisher,
        snapshot: RtcStatsSnapshot(const [
          {'id': 'RTCCodec_1', 'type': 'codec', 'mimeType': 'video/H264'},
        ]),
      );

      expect(bundle.raw, hasLength(1));
      expect(bundle.stats, hasLength(1));
      expect(bundle.printable, isNotNull);
    });

    test('an empty bundle has no reports', () {
      final bundle = PeerConnectionStatsBundle.empty(
        StreamPeerType.publisher,
      );

      expect(bundle.raw, isEmpty);
      expect(bundle.stats, isEmpty);
    });
  });
}
