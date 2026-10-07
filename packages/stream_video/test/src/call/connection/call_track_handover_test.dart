// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  int stopCallCount = 0;

  @override
  bool enabled = true;

  @override
  set onEnded(Function()? callback) {}

  @override
  Future<void> stop() async {
    stopCallCount++;
  }
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  @override
  Future<void> dispose() async {}
}

/// Pins how a session that replaces another takes over its live local
/// tracks, so the camera, microphone and screen share are published again
/// without being opened again.
///
/// Each migration and rejoin waits out the reconnect's three second network
/// stability window, so these tests run for several seconds.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
    registerFallbackValue(MockRtcLocalTrack());
  });

  late ConnectionHarness harness;

  tearDown(() => harness.dispose());

  RtcLocalTrack<T> liveTrack<T extends MediaConstraints>(
    SfuTrackType trackType,
    T constraints,
  ) {
    return RtcLocalTrack<T>(
      trackIdPrefix: kLocalTrackIdPrefix,
      trackType: trackType,
      mediaStream: _FakeMediaStream(),
      mediaTrack: _FakeMediaStreamTrack(),
      mediaConstraints: constraints,
    );
  }

  // The default mock never runs the callback that applies the connect
  // options, so each session hands it an rtc manager itself.
  void startInvokesRtcManagerCreated(
    MockCallSession session, {
    bool succeeds = true,
  }) {
    when(
      () => session.start(
        reconnectDetails: any(named: 'reconnectDetails'),
        onRtcManagerCreatedCallback: any(named: 'onRtcManagerCreatedCallback'),
        isAnonymousUser: any(named: 'isAnonymousUser'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
        clientEventRetryCount: any(named: 'clientEventRetryCount'),
      ),
    ).thenAnswer((invocation) async {
      final onCreated =
          invocation.namedArguments[#onRtcManagerCreatedCallback]
              as FutureOr<void> Function(RtcManager)?;
      await onCreated?.call(_MockRtcManager());

      if (!succeeds) {
        return const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        );
      }
      return Result.success((
        callState: createTestSfuCallState(),
        fastReconnectDeadline: Duration.zero,
      ));
    });
  }

  void stubDevices(MockCallSession session) {
    final published = MockRtcLocalTrack();
    when(() => published.mediaTrack).thenReturn(_FakeMediaStreamTrack());
    when(
      () => session.setCameraEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    ).thenAnswer((_) async => Result.success(published));
    when(
      () => session.setMicrophoneEnabled(
        any(),
        constraints: any(named: 'constraints'),
        stopTrackOnMute: any(named: 'stopTrackOnMute'),
      ),
    ).thenAnswer((_) async => Result.success(published));
    when(
      () => session.setScreenShareEnabled(
        any(),
        constraints: any(named: 'constraints'),
      ),
    ).thenAnswer((_) async => Result.success(published));
    when(
      () => session.setLocalTrack(any()),
    ).thenAnswer((_) async => const Result.success(none));
  }

  ConnectionHarness setUpHarness(int sessionCount) {
    harness = ConnectionHarness(sessionCount: sessionCount);
    for (final permission in CallPermission.values) {
      when(
        () => harness.permissionsManager.hasPermission(permission),
      ).thenReturn(true);
    }
    for (final session in harness.sessions) {
      startInvokesRtcManagerCreated(session);
      stubDevices(session);
    }
    return harness;
  }

  Future<void> goAway(MockCallSession session) {
    return harness.emitSfu(
      session,
      const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
    );
  }

  int stopCount(RtcLocalTrack track) {
    return (track.mediaTrack as _FakeMediaStreamTrack).stopCallCount;
  }

  /// Joins with [connectOptions], has `sessions.first` hand over [tracks],
  /// and migrates to the next session.
  Future<Call> migrateWith(
    List<RtcLocalTrack> tracks,
    CallConnectOptions connectOptions,
  ) async {
    when(harness.sessions.first.handOverLocalTracks).thenReturn(tracks);
    final call = harness.buildCall();
    await call.join(connectOptions: connectOptions);

    await goAway(harness.sessions.first);
    await waitUntil(() => harness.reconnectionCallbacks.length == 2);
    await waitUntil(() => call.state.value.status is CallStatusConnected);
    await pumpEventQueue();
    return call;
  }

  test(
    'a migration takes the old session\'s camera before the old one closes, '
    'and publishes it on the new one',
    () async {
      final [first, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      when(first.handOverLocalTracks).thenReturn([camera]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(camera: TrackOption.enabled()),
      );

      await goAway(first);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verifyInOrder([
        first.handOverLocalTracks,
        () => first.close(CloseCode.normalClosure),
      ]);
      verify(() => second.setLocalTrack(camera)).called(1);
      // Only unmutes the published track; a new one is never captured.
      verify(
        () => second.setCameraEnabled(
          true,
          constraints: any(named: 'constraints'),
        ),
      ).called(1);
      expect(stopCount(camera), 0);
      verifyNever(second.handOverLocalTracks);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'a rejoin takes the old session\'s tracks before the old one is '
    'disposed, and publishes them on the new one',
    () async {
      final [first, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final microphone = liveTrack(
        SfuTrackType.audio,
        const AudioConstraints(),
      );
      when(first.handOverLocalTracks).thenReturn([camera, microphone]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.enabled(),
          microphone: TrackOption.enabled(),
        ),
      );

      harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verifyInOrder([first.handOverLocalTracks, first.dispose]);
      verify(() => second.setLocalTrack(camera)).called(1);
      verify(() => second.setLocalTrack(microphone)).called(1);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'inherited tracks whose options are disabled are stopped, not published',
    () async {
      final [first, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final microphone = liveTrack(
        SfuTrackType.audio,
        const AudioConstraints(),
      );
      when(first.handOverLocalTracks).thenReturn([camera, microphone]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.disabled(),
          microphone: TrackOption.disabled(),
        ),
      );

      await goAway(first);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verifyNever(() => second.setLocalTrack(any()));
      expect(stopCount(camera), 1);
      expect(stopCount(microphone), 1);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'a live screen share is published again without capturing a new screen',
    () async {
      final [first, second] = setUpHarness(2).sessions;
      final screenShare = liveTrack(
        SfuTrackType.screenShare,
        const ScreenShareConstraints(),
      );
      when(first.handOverLocalTracks).thenReturn([screenShare]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(screenShare: TrackOption.enabled()),
      );

      await goAway(first);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verify(() => second.setLocalTrack(screenShare)).called(1);
      verifyNever(
        () => second.setScreenShareEnabled(
          any(),
          constraints: any(named: 'constraints'),
        ),
      );
      expect(call.connectOptions.screenShare, isA<TrackEnabled>());
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'a migration whose first attempt fails still takes the tracks from the '
    'session it started from',
    () async {
      final [first, second, third] = setUpHarness(3).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      when(first.handOverLocalTracks).thenReturn([camera]);
      harness.stubSessionStart(
        second,
        () async => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(camera: TrackOption.enabled()),
      );

      await goAway(first);
      await waitUntil(
        () => harness.reconnectionCallbacks.length == 3,
        timeout: const Duration(seconds: 15),
      );
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verify(() => third.setLocalTrack(camera)).called(1);
      verify(first.handOverLocalTracks).called(1);
      verify(second.handOverLocalTracks).called(1);
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );

  test(
    'an inherited track the new session fails to publish is stopped and its '
    'option turned off',
    () async {
      final [_, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      when(() => second.setLocalTrack(camera)).thenAnswer(
        (_) async => const Result.failure(
          StreamVideoException(message: 'Call not connected'),
        ),
      );

      final call = await migrateWith(
        [camera],
        CallConnectOptions(camera: TrackOption.enabled()),
      );

      expect(stopCount(camera), 1);
      expect(call.connectOptions.camera, isA<TrackDisabled>());
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'an inherited track the call may no longer send is stopped, not '
    'published',
    () async {
      final [first, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final screenShare = liveTrack(
        SfuTrackType.screenShare,
        const ScreenShareConstraints(),
      );
      when(first.handOverLocalTracks).thenReturn([camera, screenShare]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.enabled(),
          screenShare: TrackOption.enabled(),
        ),
      );
      for (final permission in [
        CallPermission.sendVideo,
        CallPermission.screenshare,
      ]) {
        when(
          () => harness.permissionsManager.hasPermission(permission),
        ).thenReturn(false);
      }

      await goAway(first);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verifyNever(() => second.setLocalTrack(any()));
      expect(stopCount(camera), 1);
      expect(stopCount(screenShare), 1);
      expect(call.connectOptions.camera, isA<TrackDisabled>());
      expect(call.connectOptions.screenShare, isA<TrackDisabled>());
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'a publish that throws still stops the inherited tracks not yet published',
    () async {
      final [_, second] = setUpHarness(2).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final microphone = liveTrack(
        SfuTrackType.audio,
        const AudioConstraints(),
      );
      when(
        () => second.setLocalTrack(camera),
      ).thenThrow(StateError('publisher closed'));

      await migrateWith(
        [camera, microphone],
        CallConnectOptions(
          camera: TrackOption.enabled(),
          microphone: TrackOption.enabled(),
        ),
      );

      expect(stopCount(camera), 1);
      expect(stopCount(microphone), 1);
      verifyNever(() => second.setLocalTrack(microphone));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'an inherited track is not published once the call has moved on to '
    'another session',
    () async {
      final [first, second, third] = setUpHarness(3).sessions;
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final microphone = liveTrack(
        SfuTrackType.audio,
        const AudioConstraints(),
      );
      when(first.handOverLocalTracks).thenReturn([camera, microphone]);
      final cameraPublished = Completer<Result<None>>();
      when(
        () => second.setLocalTrack(camera),
      ).thenAnswer((_) => cameraPublished.future);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(
          camera: TrackOption.enabled(),
          microphone: TrackOption.enabled(),
        ),
      );

      await goAway(first);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      harness.requestReconnect(1, SfuReconnectionStrategy.rejoin);
      await waitUntil(() => harness.reconnectionCallbacks.length == 3);
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      cameraPublished.complete(const Result.success(none));
      await pumpEventQueue();

      verifyNever(() => second.setLocalTrack(microphone));
      verifyNever(() => third.setLocalTrack(microphone));
      expect(stopCount(microphone), 1);
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );

  test(
    'a migration retried after a failed attempt that took the tracks takes '
    'them from that attempt\'s session',
    () async {
      final [first, second, third] = setUpHarness(3).sessions;
      startInvokesRtcManagerCreated(second, succeeds: false);
      final camera = liveTrack(SfuTrackType.video, const CameraConstraints());
      final cameraOnSecond = liveTrack(
        SfuTrackType.video,
        const CameraConstraints(),
      );
      var firstHandOvers = 0;
      when(first.handOverLocalTracks).thenAnswer(
        (_) => firstHandOvers++ == 0 ? [camera] : const [],
      );
      when(second.handOverLocalTracks).thenReturn([cameraOnSecond]);
      final call = harness.buildCall();
      await call.join(
        connectOptions: CallConnectOptions(camera: TrackOption.enabled()),
      );

      await goAway(first);
      await waitUntil(
        () => harness.reconnectionCallbacks.length == 3,
        timeout: const Duration(seconds: 15),
      );
      await waitUntil(() => call.state.value.status is CallStatusConnected);
      await pumpEventQueue();

      verify(() => second.setLocalTrack(camera)).called(1);
      verify(() => third.setLocalTrack(cameraOnSecond)).called(1);
      verifyNever(() => third.setLocalTrack(camera));
    },
    timeout: const Timeout(Duration(seconds: 40)),
  );
}
