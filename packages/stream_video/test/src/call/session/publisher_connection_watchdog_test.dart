import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/session/publisher_connection_watchdog.dart';
import 'package:stream_video/src/call/session/publisher_negotiator.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'fixtures/call_session_harness.dart';

class _MockPublisherNegotiator extends Mock implements PublisherNegotiator {}

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late MockTracedPeerConnection publisher;
  late MockRTCPeerConnection pc;
  late _MockPublisherNegotiator negotiator;
  late Tracer tracer;
  late List<
    (StreamPeerConnection, SfuReconnectionStrategy, ReconnectionNeededReason)
  >
  reconnects;
  late bool closed;
  StreamPeerConnection? current;
  late PublisherConnectionWatchdog watchdog;

  setUp(() {
    publisher = MockTracedPeerConnection();
    pc = MockRTCPeerConnection();
    negotiator = _MockPublisherNegotiator();
    tracer = Tracer(null);
    reconnects = [];
    closed = false;
    current = publisher;

    when(() => publisher.pc).thenReturn(pc);
    when(() => pc.iceConnectionState).thenReturn(
      rtc.RTCIceConnectionState.RTCIceConnectionStateConnected,
    );
    when(
      () => pc.signalingState,
    ).thenReturn(rtc.RTCSignalingState.RTCSignalingStateStable);
    when(
      () => negotiator.negotiate(any()),
    ).thenAnswer((_) async => const Result.success(null));

    watchdog = PublisherConnectionWatchdog(
      publisher: () => current,
      negotiator: negotiator,
      onReconnectionNeeded: (pc, strategy, reason) =>
          reconnects.add((pc, strategy, reason)),
      tracer: tracer,
      isClosed: () => closed,
      logTag: 'test',
    );
  });

  List<String> traceTags() => [
    for (final record in tracer.take().snapshot) record.tag,
  ];

  List<Object?> traceData() => [
    for (final record in tracer.take().snapshot) record.data,
  ];

  test('ICE still new after the delay asks for a rejoin', () {
    fakeAsync((async) {
      when(
        () => pc.iceConnectionState,
      ).thenReturn(rtc.RTCIceConnectionState.RTCIceConnectionStateNew);

      watchdog.start();
      async.elapse(const Duration(seconds: 14));
      expect(reconnects, isEmpty);

      async.elapse(const Duration(seconds: 1));
      expect(reconnects, [
        (
          publisher,
          SfuReconnectionStrategy.rejoin,
          ReconnectionNeededReason.stuck,
        ),
      ]);
      final records = tracer.take().snapshot;
      expect(records.single.tag, TraceTag.publisherConnectionCheckStalled);
      expect(records.single.data, {
        'iceState': rtc.RTCIceConnectionState.RTCIceConnectionStateNew
            .toString(),
        'timeoutSeconds': 15,
      });
      verifyNever(() => negotiator.negotiate(any()));
    });
  });

  test('a stalled local offer renegotiates and asks for nothing when that '
      'works', () {
    fakeAsync((async) {
      when(() => pc.signalingState).thenReturn(
        rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer,
      );

      watchdog.start();
      async.elapse(const Duration(seconds: 15));

      verify(() => negotiator.negotiate(publisher)).called(1);
      expect(reconnects, isEmpty);
      expect(traceData(), [
        {
          'signalingState': rtc
              .RTCSignalingState
              .RTCSignalingStateHaveLocalOffer
              .toString(),
          'timeoutSeconds': 15,
        },
      ]);
    });
  });

  test('a stalled local offer whose renegotiation fails asks for a fast '
      'reconnect', () {
    fakeAsync((async) {
      when(() => pc.signalingState).thenReturn(
        rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer,
      );
      when(() => negotiator.negotiate(any())).thenAnswer(
        (_) async => const Result.failure(StreamVideoException(message: 'no')),
      );

      watchdog.start();
      async.elapse(const Duration(seconds: 15));

      verify(() => negotiator.negotiate(publisher)).called(1);
      expect(reconnects, [
        (
          publisher,
          SfuReconnectionStrategy.fast,
          ReconnectionNeededReason.stuck,
        ),
      ]);
    });
  });

  test('a failed renegotiation after a close asks for nothing', () {
    fakeAsync((async) {
      when(() => pc.signalingState).thenReturn(
        rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer,
      );
      when(() => negotiator.negotiate(any())).thenAnswer((_) async {
        closed = true;
        return const Result.failure(StreamVideoException(message: 'no'));
      });

      watchdog.start();
      async.elapse(const Duration(seconds: 15));

      verify(() => negotiator.negotiate(publisher)).called(1);
      expect(reconnects, isEmpty);
    });
  });

  test('a connected publisher needs nothing', () {
    fakeAsync((async) {
      watchdog.start();
      async.elapse(const Duration(seconds: 20));

      expect(reconnects, isEmpty);
      verifyNever(() => negotiator.negotiate(any()));
      expect(traceTags(), isEmpty);
    });
  });

  test('a closed session is not checked', () {
    fakeAsync((async) {
      closed = true;

      watchdog.start();
      async.elapse(const Duration(seconds: 20));

      verifyNever(() => pc.iceConnectionState);
      verifyNever(() => negotiator.negotiate(any()));
      expect(reconnects, isEmpty);
    });
  });

  test('a session without a publisher is not checked', () {
    fakeAsync((async) {
      current = null;

      watchdog.start();
      async.elapse(const Duration(seconds: 20));

      verifyNever(() => pc.iceConnectionState);
      verifyNever(() => negotiator.negotiate(any()));
      expect(reconnects, isEmpty);
    });
  });

  test('cancel disarms the check', () {
    fakeAsync((async) {
      when(
        () => pc.iceConnectionState,
      ).thenReturn(rtc.RTCIceConnectionState.RTCIceConnectionStateNew);

      watchdog.start();
      expect(async.nonPeriodicTimerCount, 1);

      watchdog.cancel();
      expect(async.nonPeriodicTimerCount, 0);
      async.elapse(const Duration(seconds: 20));

      expect(reconnects, isEmpty);
    });
  });

  test('start rearms the check from now', () {
    fakeAsync((async) {
      when(
        () => pc.iceConnectionState,
      ).thenReturn(rtc.RTCIceConnectionState.RTCIceConnectionStateNew);

      watchdog.start();
      async.elapse(const Duration(seconds: 10));
      watchdog.start();
      expect(async.nonPeriodicTimerCount, 1);

      async.elapse(const Duration(seconds: 10));
      expect(reconnects, isEmpty);

      async.elapse(const Duration(seconds: 5));
      expect(reconnects, hasLength(1));
    });
  });
}
