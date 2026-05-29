// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

class MockRtcManager extends Mock implements RtcManager {}

/// Minimal [RtcTrack] implementation that records which lifecycle methods were
/// called without requiring a real native media stack.
class _FakeAudioTrack implements RtcTrack {
  bool enabled = true;
  bool startCalled = false;
  bool stopCalled = false;

  @override
  String get trackIdPrefix => 'fake';

  @override
  SfuTrackType get trackType => SfuTrackType.audio;

  @override
  rtc.MediaStream get mediaStream => throw UnimplementedError();

  @override
  rtc.MediaStreamTrack get mediaTrack => throw UnimplementedError();

  @override
  RtcVideoDimension? get videoDimension => null;

  @override
  String get trackId => '$trackIdPrefix:$trackType';

  @override
  bool get isAudioTrack => true;

  @override
  bool get isVideoTrack => false;

  @override
  bool get isScreenShareTrack => false;

  @override
  void enable() => enabled = true;

  @override
  void disable() => enabled = false;

  @override
  Future<void> start() async => startCalled = true;

  @override
  Future<void> stop() async => stopCalled = true;

  @override
  RtcTrack copyWith() => this;

  @override
  Future<ByteBuffer?> captureScreenshot() async => null;
}

class _FakeVideoTrack implements RtcTrack {
  bool startCalled = false;

  @override
  String get trackIdPrefix => 'fake-video';

  @override
  SfuTrackType get trackType => SfuTrackType.video;

  @override
  rtc.MediaStream get mediaStream => throw UnimplementedError();

  @override
  rtc.MediaStreamTrack get mediaTrack => throw UnimplementedError();

  @override
  RtcVideoDimension? get videoDimension => null;

  @override
  String get trackId => '$trackIdPrefix:$trackType';

  @override
  bool get isAudioTrack => false;

  @override
  bool get isVideoTrack => true;

  @override
  bool get isScreenShareTrack => false;

  @override
  void enable() {}

  @override
  void disable() {}

  @override
  Future<void> start() async => startCalled = true;

  @override
  Future<void> stop() async {}

  @override
  RtcTrack copyWith() => this;

  @override
  Future<ByteBuffer?> captureScreenshot() async => null;
}

MockStreamVideo _buildMockStreamVideo() {
  final mock = setupMockStreamVideo();
  when(() => mock.apiKey).thenReturn('test-api-key');
  return mock;
}

CallSession _buildTestSession({
  void Function(String)? onSuspendedAudioTrackRecorded,
}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();

  return CallSession(
    callCid: callCid,
    sessionSeq: 0,
    sessionId: 'test-session',
    config: const CallSessionConfig(
      sfuName: 'test-sfu',
      sfuToken: 'test-token',
      sfuUrl: 'https://test.example.com',
      sfuWsEndpoint: 'wss://test.example.com/ws',
      rtcConfig: RTCConfiguration(),
    ),
    stateManager: stateManager,
    dynascaleManager: DynascaleManager(stateManager: stateManager),
    onReconnectionNeeded: (_, __) {},
    onSuspendedAudioTrackRecorded: onSuspendedAudioTrackRecorded ?? (_) {},
    sdpEditor: MockSdpEditor(),
    networkMonitor: setupMockInternetConnection(),
    statsOptions: StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    streamVideo: _buildMockStreamVideo(),
    tracer: Tracer(null),
    pcFactory: StreamPeerConnectionFactory(callCid: callCid),
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('CallSession.resumeSuspendedAudioTracks', () {
    test('calls enable() on wasEnabled audio tracks', () async {
      final session = _buildTestSession();
      final mockRtcManager = MockRtcManager();
      final track = _FakeAudioTrack()..enabled = false;
      const trackKey = 'prefix:audio';

      when(() => mockRtcManager.tracks).thenReturn({trackKey: track});
      session.rtcManager = mockRtcManager;

      await session.resumeSuspendedAudioTracks({
        trackKey: SuspendedTrackState.wasEnabled,
      });

      expect(track.enabled, isTrue);
      expect(track.startCalled, isFalse, reason: 'enable() only, not start()');
    });

    test('calls start() on neverStarted audio tracks', () async {
      final session = _buildTestSession();
      final mockRtcManager = MockRtcManager();
      final track = _FakeAudioTrack();
      const trackKey = 'prefix:audio';

      when(() => mockRtcManager.tracks).thenReturn({trackKey: track});
      session.rtcManager = mockRtcManager;

      await session.resumeSuspendedAudioTracks({
        trackKey: SuspendedTrackState.neverStarted,
      });

      expect(track.startCalled, isTrue);
    });

    test('does not touch wasDisabled audio tracks', () async {
      final session = _buildTestSession();
      final mockRtcManager = MockRtcManager();
      final track = _FakeAudioTrack()..enabled = false;
      const trackKey = 'prefix:audio';

      when(() => mockRtcManager.tracks).thenReturn({trackKey: track});
      session.rtcManager = mockRtcManager;

      await session.resumeSuspendedAudioTracks({
        trackKey: SuspendedTrackState.wasDisabled,
      });

      expect(track.enabled, isFalse, reason: 'disabled before, stay disabled');
      expect(track.startCalled, isFalse);
    });

    test('skips audio tracks not present in priorStates', () async {
      final session = _buildTestSession();
      final mockRtcManager = MockRtcManager();
      final track = _FakeAudioTrack()..enabled = false;

      // Track is in the rtcManager but NOT in priorStates.
      when(() => mockRtcManager.tracks).thenReturn({'prefix:audio': track});
      session.rtcManager = mockRtcManager;

      await session.resumeSuspendedAudioTracks({}); // empty prior states

      expect(track.enabled, isFalse);
      expect(track.startCalled, isFalse);
    });

    test(
      'skips video tracks even when their id appears in priorStates',
      () async {
        final session = _buildTestSession();
        final mockRtcManager = MockRtcManager();
        final videoTrack = _FakeVideoTrack();
        const trackKey = 'fake-video:video';

        when(() => mockRtcManager.tracks).thenReturn({trackKey: videoTrack});
        session.rtcManager = mockRtcManager;

        await session.resumeSuspendedAudioTracks({
          trackKey: SuspendedTrackState.wasEnabled,
        });

        expect(
          videoTrack.startCalled,
          isFalse,
          reason: 'video tracks must not be touched by audio resume',
        );
      },
    );

    test('does nothing when rtcManager is null', () async {
      final session = _buildTestSession();
      // rtcManager is null by default (start() was never called).

      await expectLater(
        session.resumeSuspendedAudioTracks({
          'any:audio': SuspendedTrackState.wasEnabled,
        }),
        completes,
      );
    });

    test('handles multiple tracks with mixed states', () async {
      final session = _buildTestSession();
      final mockRtcManager = MockRtcManager();

      final wasEnabledTrack = _FakeAudioTrack()..enabled = false;
      final neverStartedTrack = _FakeAudioTrack();
      final wasDisabledTrack = _FakeAudioTrack()..enabled = false;
      final ignoredTrack = _FakeAudioTrack()
        ..enabled = false; // not in priorStates

      when(() => mockRtcManager.tracks).thenReturn({
        'track1:audio': wasEnabledTrack,
        'track2:audio': neverStartedTrack,
        'track3:audio': wasDisabledTrack,
        'track4:audio': ignoredTrack,
      });
      session.rtcManager = mockRtcManager;

      await session.resumeSuspendedAudioTracks({
        'track1:audio': SuspendedTrackState.wasEnabled,
        'track2:audio': SuspendedTrackState.neverStarted,
        'track3:audio': SuspendedTrackState.wasDisabled,
        // track4 intentionally omitted
      });

      expect(wasEnabledTrack.enabled, isTrue);
      expect(neverStartedTrack.startCalled, isTrue);
      expect(wasDisabledTrack.enabled, isFalse);
      expect(wasDisabledTrack.startCalled, isFalse);
      expect(
        ignoredTrack.enabled,
        isFalse,
        reason: 'not in priorStates, unchanged',
      );
      expect(ignoredTrack.startCalled, isFalse);
    });
  });

  group('CallSession onSuspendedAudioTrackRecorded callback', () {
    // This callback is invoked by the session when a track arrives while audio
    // is suspended. We verify that the session was constructed with the
    // callback and that it's callable, exercising the wiring without triggering
    // the full SFU event flow.
    test('callback is stored and invokable', () async {
      final recorded = <String>[];
      final session = _buildTestSession(
        onSuspendedAudioTrackRecorded: recorded.add,
      );

      // Directly invoke the callback via the public field to verify wiring.
      session.onSuspendedAudioTrackRecorded('test-track-id');

      expect(recorded, equals(['test-track-id']));
    });

    test('multiple invocations accumulate', () async {
      final recorded = <String>[];
      final session = _buildTestSession(
        onSuspendedAudioTrackRecorded: recorded.add,
      );

      session.onSuspendedAudioTrackRecorded('track-a');
      session.onSuspendedAudioTrackRecorded('track-b');

      expect(recorded, equals(['track-a', 'track-b']));
    });
  });
}
