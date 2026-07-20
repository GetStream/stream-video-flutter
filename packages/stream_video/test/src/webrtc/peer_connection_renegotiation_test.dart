import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/signal_rpc/signal.pb.dart'
    as sfu;
import 'package:stream_video/src/sfu/sfu_client.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import '../call/fixtures/data.dart';

/// Minimal fake of [rtc.RTCPeerConnection] that captures the callbacks
/// [StreamPeerConnection] wires up in its constructor. We only override the
/// setters the wiring touches; everything else falls back to the [Fake] mixin
/// (which throws if accidentally invoked).
class _FakeRtcPeerConnection extends Fake implements rtc.RTCPeerConnection {
  void Function(rtc.MediaStream)? capturedOnAddStream;
  void Function(rtc.MediaStream)? capturedOnRemoveStream;
  void Function(rtc.MediaStream, rtc.MediaStreamTrack)? capturedOnAddTrack;
  void Function(rtc.RTCTrackEvent)? capturedOnTrack;
  void Function(rtc.MediaStream, rtc.MediaStreamTrack)? capturedOnRemoveTrack;
  void Function(rtc.RTCIceCandidate)? capturedOnIceCandidate;
  void Function(rtc.RTCIceConnectionState)? capturedOnIceConnectionState;
  void Function(rtc.RTCPeerConnectionState)? capturedOnConnectionState;
  void Function()? capturedOnRenegotiationNeeded;

  @override
  set onAddStream(void Function(rtc.MediaStream)? cb) =>
      capturedOnAddStream = cb;

  @override
  set onRemoveStream(void Function(rtc.MediaStream)? cb) =>
      capturedOnRemoveStream = cb;

  @override
  set onAddTrack(void Function(rtc.MediaStream, rtc.MediaStreamTrack)? cb) =>
      capturedOnAddTrack = cb;

  @override
  set onTrack(void Function(rtc.RTCTrackEvent)? cb) => capturedOnTrack = cb;

  @override
  set onRemoveTrack(void Function(rtc.MediaStream, rtc.MediaStreamTrack)? cb) =>
      capturedOnRemoveTrack = cb;

  @override
  set onIceCandidate(void Function(rtc.RTCIceCandidate)? cb) =>
      capturedOnIceCandidate = cb;

  @override
  set onIceConnectionState(void Function(rtc.RTCIceConnectionState)? cb) =>
      capturedOnIceConnectionState = cb;

  @override
  set onConnectionState(void Function(rtc.RTCPeerConnectionState)? cb) =>
      capturedOnConnectionState = cb;

  @override
  set onRenegotiationNeeded(void Function()? cb) =>
      capturedOnRenegotiationNeeded = cb;

  // _dropRtcCallbacks also nulls these — accept the assignment so dispose()
  // doesn't blow up on un-overridden setters. We don't capture them because
  // _initRtcCallbacks never wires them in the first place.
  @override
  set onIceGatheringState(void Function(rtc.RTCIceGatheringState)? _) {}

  @override
  set onSignalingState(void Function(rtc.RTCSignalingState)? _) {}

  @override
  set onDataChannel(void Function(rtc.RTCDataChannel)? _) {}

  int restartIceCallCount = 0;
  int disposeCallCount = 0;

  @override
  Future<void> restartIce() async {
    restartIceCallCount++;
  }

  @override
  Future<void> dispose() async {
    disposeCallCount++;
  }

  rtc.RTCIceConnectionState? stubbedIceConnectionState;

  @override
  rtc.RTCIceConnectionState? get iceConnectionState =>
      stubbedIceConnectionState;
}

StreamPeerConnection _build({
  required _FakeRtcPeerConnection pc,
  required StreamPeerType type,
  SfuClient? sfuClient,
}) {
  return StreamPeerConnection(
    sfuClient: sfuClient ?? MockSfuClient(),
    sessionId: 'test-session',
    callCid: SampleCallData.defaultCid,
    type: type,
    pc: pc,
    sdpEditor: MockSdpEditor(),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(sfu.ICERestartRequest());
  });

  group('StreamPeerConnection.onRenegotiationNeeded', () {
    test(
      'forwards to the public onRenegotiationNeeded callback when not '
      'reconnecting',
      () {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);

        final invocations = <StreamPeerConnection>[];
        sp.onRenegotiationNeeded = invocations.add;

        // Sanity: the constructor wired the rtc-side callback.
        expect(pc.capturedOnRenegotiationNeeded, isNotNull);

        pc.capturedOnRenegotiationNeeded!();

        expect(invocations, hasLength(1));
        expect(invocations.single, same(sp));
      },
    );

    test(
      'suppresses the callback while setReconnecting(true) is in effect',
      () {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);

        var calls = 0;
        sp.onRenegotiationNeeded = (_) => calls++;

        sp.setReconnecting(true);

        pc.capturedOnRenegotiationNeeded!();

        expect(
          calls,
          0,
          reason:
              'Renegotiation requests during reconnect must be deferred; '
              'the session will renegotiate explicitly once reconnect '
              'completes.',
        );
      },
    );

    test(
      'resumes forwarding after setReconnecting(false)',
      () {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);

        var calls = 0;
        sp.onRenegotiationNeeded = (_) => calls++;

        sp.setReconnecting(true);
        pc.capturedOnRenegotiationNeeded!();
        expect(calls, 0);

        sp.setReconnecting(false);
        pc.capturedOnRenegotiationNeeded!();
        expect(calls, 1);
      },
    );

    test('is a no-op when no public callback is attached', () {
      final pc = _FakeRtcPeerConnection();
      _build(pc: pc, type: StreamPeerType.publisher);

      // onRenegotiationNeeded is null by default — must not throw.
      expect(pc.capturedOnRenegotiationNeeded, isA<void Function()>());
      expect(() => pc.capturedOnRenegotiationNeeded!(), returnsNormally);
    });
  });

  group('StreamPeerConnection.onConnectionState', () {
    test(
      'fires onReconnectionNeeded with fast when the peer enters Failed',
      () {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);

        final calls = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
        sp.onReconnectionNeeded = (peer, strategy) =>
            calls.add((peer, strategy));

        pc.capturedOnConnectionState!(
          rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed,
        );

        expect(calls, hasLength(1));
        expect(calls.single.$1, same(sp));
        expect(calls.single.$2, SfuReconnectionStrategy.fast);
      },
    );

    test('does not fire onReconnectionNeeded for non-Failed states', () {
      final pc = _FakeRtcPeerConnection();
      final sp = _build(pc: pc, type: StreamPeerType.publisher);

      var calls = 0;
      sp.onReconnectionNeeded = (_, __) => calls++;

      [
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateNew,
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected,
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected,
        rtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed,
      ].forEach(pc.capturedOnConnectionState!);

      expect(calls, 0);
    });
  });

  group('StreamPeerConnection ICE-restart on iceConnectionState changes', () {
    test(
      'publisher restartIce is called immediately on ICE Failed when not '
      'reconnecting',
      () {
        final pc = _FakeRtcPeerConnection();
        _build(pc: pc, type: StreamPeerType.publisher);

        pc.capturedOnIceConnectionState!(
          rtc.RTCIceConnectionState.RTCIceConnectionStateFailed,
        );

        // restartIce is async-chained through `.then(...)` — the fake's
        // counter increments synchronously the moment the future is awaited.
        expect(pc.restartIceCallCount, 1);
      },
    );

    test(
      'subscriber routes ICE-Failed through sfuClient.restartIce, not pc',
      () async {
        final pc = _FakeRtcPeerConnection();
        final sfuClient = MockSfuClient();
        when(() => sfuClient.restartIce(any())).thenAnswer(
          (_) async => Result.success(sfu.ICERestartResponse()),
        );

        _build(
          pc: pc,
          type: StreamPeerType.subscriber,
          sfuClient: sfuClient,
        );

        pc.capturedOnIceConnectionState!(
          rtc.RTCIceConnectionState.RTCIceConnectionStateFailed,
        );

        // Let the restartIce microtasks settle.
        await Future<void>.delayed(Duration.zero);

        verify(() => sfuClient.restartIce(any())).called(1);
        expect(
          pc.restartIceCallCount,
          0,
          reason: 'subscriber-side restart goes through SFU, not the PC',
        );
      },
    );

    test('publisher restartIce is suppressed during reconnect', () {
      final pc = _FakeRtcPeerConnection();
      final sp = _build(pc: pc, type: StreamPeerType.publisher);

      sp.setReconnecting(true);
      pc.capturedOnIceConnectionState!(
        rtc.RTCIceConnectionState.RTCIceConnectionStateFailed,
      );

      expect(
        pc.restartIceCallCount,
        0,
        reason: 'reconnect is owning the recovery flow',
      );
    });

    test(
      'ICE Disconnected schedules a deferred restart that runs after '
      'iceRestartDelay if the connection is still bad',
      () {
        fakeAsync((async) {
          final pc = _FakeRtcPeerConnection();
          _build(pc: pc, type: StreamPeerType.publisher);

          pc.stubbedIceConnectionState =
              rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected;
          pc.capturedOnIceConnectionState!(
            rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected,
          );

          // Default iceRestartDelay is 2500ms; before that no restart yet.
          async.elapse(const Duration(milliseconds: 2000));
          expect(pc.restartIceCallCount, 0);

          // Cross the deadline — still disconnected, so restartIce fires.
          async.elapse(const Duration(milliseconds: 600));
          expect(pc.restartIceCallCount, 1);
        });
      },
    );

    test(
      'ICE Disconnected → deferred restart is skipped if the peer has '
      'recovered to Connected before the delay elapses',
      () {
        fakeAsync((async) {
          final pc = _FakeRtcPeerConnection();
          _build(pc: pc, type: StreamPeerType.publisher);

          pc.stubbedIceConnectionState =
              rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected;
          pc.capturedOnIceConnectionState!(
            rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected,
          );

          // ICE recovers — Connected handler cancels the pending timer.
          pc.stubbedIceConnectionState =
              rtc.RTCIceConnectionState.RTCIceConnectionStateConnected;
          pc.capturedOnIceConnectionState!(
            rtc.RTCIceConnectionState.RTCIceConnectionStateConnected,
          );

          async.elapse(const Duration(seconds: 10));
          expect(pc.restartIceCallCount, 0);
        });
      },
    );

    test(
      'setReconnecting(true) cancels a pending ICE-Disconnected restart',
      () {
        fakeAsync((async) {
          final pc = _FakeRtcPeerConnection();
          final sp = _build(pc: pc, type: StreamPeerType.publisher);

          pc.stubbedIceConnectionState =
              rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected;
          pc.capturedOnIceConnectionState!(
            rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected,
          );

          sp.setReconnecting(true);

          async.elapse(const Duration(seconds: 10));
          expect(pc.restartIceCallCount, 0);
        });
      },
    );
  });

  group('StreamPeerConnection event forwarding', () {
    test(
      'onAddStream forwards to onStreamAdded with the same peer + stream',
      () {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);
        final fakeStream = _FakeMediaStream();

        final received = <(StreamPeerConnection, rtc.MediaStream)>[];
        sp.onStreamAdded = (peer, stream) => received.add((peer, stream));

        pc.capturedOnAddStream!(fakeStream);

        expect(received, hasLength(1));
        expect(received.single.$1, same(sp));
        expect(received.single.$2, same(fakeStream));
      },
    );

    test('onTrack forwards to public onTrack', () {
      final pc = _FakeRtcPeerConnection();
      final sp = _build(pc: pc, type: StreamPeerType.publisher);
      final event = _FakeTrackEvent();

      final received = <(StreamPeerConnection, rtc.RTCTrackEvent)>[];
      sp.onTrack = (peer, e) => received.add((peer, e));

      pc.capturedOnTrack!(event);

      expect(received.single.$1, same(sp));
      expect(received.single.$2, same(event));
    });

    test('onIceCandidate forwards to public onIceCandidate', () {
      final pc = _FakeRtcPeerConnection();
      final sp = _build(pc: pc, type: StreamPeerType.publisher);
      final candidate = rtc.RTCIceCandidate('cand', 'mid', 0);

      final received = <(StreamPeerConnection, rtc.RTCIceCandidate)>[];
      sp.onIceCandidate = (peer, c) => received.add((peer, c));

      pc.capturedOnIceCandidate!(candidate);

      expect(received.single.$1, same(sp));
      expect(received.single.$2, same(candidate));
    });
  });

  group('StreamPeerConnection.dispose', () {
    test(
      'drops every rtc-side callback and disposes the underlying pc',
      () async {
        final pc = _FakeRtcPeerConnection();
        final sp = _build(pc: pc, type: StreamPeerType.publisher);

        // Sanity: callbacks were wired by the ctor.
        expect(pc.capturedOnRenegotiationNeeded, isNotNull);

        await sp.dispose();

        expect(pc.capturedOnAddStream, isNull);
        expect(pc.capturedOnRemoveStream, isNull);
        expect(pc.capturedOnAddTrack, isNull);
        expect(pc.capturedOnTrack, isNull);
        expect(pc.capturedOnRemoveTrack, isNull);
        expect(pc.capturedOnIceCandidate, isNull);
        expect(pc.capturedOnIceConnectionState, isNull);
        expect(pc.capturedOnConnectionState, isNull);
        expect(pc.capturedOnRenegotiationNeeded, isNull);
        expect(
          pc.disposeCallCount,
          1,
          reason: 'StreamPeerConnection.dispose must dispose the underlying pc',
        );
      },
    );
  });
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  @override
  String get id => 'fake-stream-id';
}

class _FakeTrackEvent extends Fake implements rtc.RTCTrackEvent {}
