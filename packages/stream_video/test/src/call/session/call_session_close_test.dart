import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'fixtures/call_session_harness.dart';

void main() {
  setUpAll(registerCallSessionHarnessFallbacks);

  late CallSessionHarness harness;

  setUp(() async {
    harness = CallSessionHarness();
    final started = await harness.session.start();
    expect(started.isSuccess, isTrue);
  });

  test('disposes the stats reporter and the manager and clears both', () async {
    final statsReporter = harness.session.statsReporter!;

    await harness.session.close(CloseCode.normalClosure, closeReason: 'bye');

    expect(statsReporter.mounted, isFalse);
    expect(harness.session.statsReporter, isNull);
    expect(harness.session.rtcManager, isNull);
    verify(harness.rtcManager.dispose).called(1);
    verify(
      () =>
          harness.sfuWS.disconnect(CloseCode.normalClosure, 'dart-client: bye'),
    ).called(1);
  });

  test('does not wait for the socket to disconnect', () async {
    when(
      () => harness.sfuWS.disconnect(any(), any()),
    ).thenAnswer((_) => Completer<Result<None>>().future);

    await harness.session
        .close(CloseCode.normalClosure)
        .timeout(const Duration(seconds: 1));

    verify(harness.rtcManager.dispose).called(1);
  });

  test('a failing socket disconnect is swallowed', () async {
    when(
      () => harness.sfuWS.disconnect(any(), any()),
    ).thenAnswer((_) => Future.error(StateError('disconnect failed')));

    await harness.session.close(CloseCode.normalClosure);
    await pumpEventQueue();

    expect(harness.session.rtcManager, isNull);
  });

  test('a failing manager dispose still clears the manager', () async {
    when(
      harness.rtcManager.dispose,
    ).thenAnswer((_) async => throw StateError('dispose failed'));

    await harness.session.close(CloseCode.normalClosure);

    expect(harness.session.rtcManager, isNull);
  });

  test('stops handling SFU events', () async {
    await harness.session.close(CloseCode.normalClosure);

    harness.events.emit(
      SfuParticipantJoinedEvent(
        callCid: 'cid',
        participant: harnessSfuParticipant(),
      ),
    );
    await pumpEventQueue();

    verifyNever(() => harness.stateManager.sfuParticipantJoined(any()));
  });

  test('stops tracing network changes and drops the trace', () async {
    harness.networkStatus.add(InternetStatus.disconnected);
    await pumpEventQueue();
    expect(harness.takeTraceTags(), contains(TraceTag.networkChanged));

    harness.session.trace('before-close', null);
    await harness.session.close(CloseCode.normalClosure);
    harness.networkStatus.add(InternetStatus.connected);
    await pumpEventQueue();

    expect(harness.takeTraceTags(), isEmpty);
  });

  test('forgets the joined manager, so a reconnect on it after a close is '
      'not a reuse', () async {
    await harness.session.debugHandleSfuEvent(
      SfuJoinResponseEvent(callState: harnessSfuCallState()),
    );
    await harness.session.close(CloseCode.normalClosure);

    harness.session.rtcManager = harness.rtcManager;
    await harness.session.debugHandleSfuEvent(
      SfuJoinResponseEvent(
        callState: harnessSfuCallState(),
        isReconnected: true,
      ),
    );

    final flags = verify(
      () => harness.stateManager.sfuJoinResponse(
        any(),
        subscriberReused: captureAny(named: 'subscriberReused'),
      ),
    ).captured;
    expect(flags.last, isFalse);
  });

  test('cancels the publisher connection check', () {
    fakeAsync((async) {
      final harness = CallSessionHarness();
      harness.session.rtcManager = harness.rtcManager;
      when(
        () => harness.publisherPc.iceConnectionState,
      ).thenReturn(rtc.RTCIceConnectionState.RTCIceConnectionStateNew);

      harness.session.startPublisherConnectionCheck();
      final timers = async.nonPeriodicTimerCount;
      unawaited(harness.session.close(CloseCode.normalClosure));
      async.flushMicrotasks();
      expect(async.nonPeriodicTimerCount, timers - 1);
      async.elapse(const Duration(seconds: 20));

      expect(harness.reconnects, isEmpty);
      verifyNever(() => harness.publisherPc.iceConnectionState);
    });
  });

  // Bug 3 of FLU-1060, pinned as it behaves today: only the next `start`
  // closes the subject. CS9 closes it in `close`.
  test('leaves the rtcManager subject open', () async {
    expect(harness.session.debugIsRtcManagerSubjectClosed, isFalse);

    await harness.session.close(CloseCode.normalClosure);

    expect(harness.session.debugIsRtcManagerSubjectClosed, isFalse);
  });
}
