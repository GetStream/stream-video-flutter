import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../test_helpers.dart';
import '../call/fixtures/data.dart';

class _MockTracedPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockStreamPeerConnectionFactory extends Mock
    implements StreamPeerConnectionFactory {}

class _FakeMediaStreamTrack extends Fake implements rtc.MediaStreamTrack {
  _FakeMediaStreamTrack({required this.kind});

  @override
  final String? kind;

  int stopCallCount = 0;

  @override
  bool enabled = true;

  @override
  Future<void> stop() async {
    stopCallCount++;
  }
}

class _FakeMediaStream extends Fake implements rtc.MediaStream {
  int disposeCallCount = 0;

  @override
  Future<void> dispose() async {
    disposeCallCount++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockStreamPeerConnectionFactory pcFactory;
  late RtcManager rtcManager;

  setUp(() {
    pcFactory = _MockStreamPeerConnectionFactory();
    when(() => pcFactory.setMicrophoneMuted(any())).thenAnswer((_) async {});

    final streamVideo = MockStreamVideo();
    when(() => streamVideo.options).thenReturn(
      StreamVideoOptions(clientEventsReportingEnabled: false),
    );

    rtcManager = RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: 'test-publisher',
      publisher: null,
      subscriber: _MockTracedPeerConnection(),
      publishOptions: [],
      stateManager: MockCallStateNotifier(),
      streamVideo: streamVideo,
      pcFactory: pcFactory,
    );
  });

  RtcLocalAudioTrack addAudioTrack({
    required _FakeMediaStreamTrack mediaTrack,
    required _FakeMediaStream mediaStream,
  }) {
    final track = RtcLocalAudioTrack(
      trackIdPrefix: 'test-publisher',
      trackType: SfuTrackType.audio,
      mediaStream: mediaStream,
      mediaTrack: mediaTrack,
      mediaConstraints: const AudioConstraints(),
    );
    rtcManager.tracks[track.trackId] = track;
    return track;
  }

  group(
    'RtcManager audio mute on Apple platforms (ADM-level mute)',
    // The ADM-level mute path is gated on CurrentPlatform.isIos/isMacOS;
    // running the suite on a macOS host exercises the same branch iOS takes.
    skip: !Platform.isMacOS
        ? 'ADM-level mute branch only runs on Apple platforms'
        : false,
    () {
      test('default mute keeps the legacy stop-and-release behavior', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final mediaStream = _FakeMediaStream();
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: mediaStream,
        );

        final result = await rtcManager.muteTrack(trackId: track.trackId);

        expect(result.isSuccess, isTrue);
        verifyNever(() => pcFactory.setMicrophoneMuted(any()));
        expect(mediaTrack.stopCallCount, greaterThan(0));
        expect(mediaStream.disposeCallCount, greaterThan(0));
      });

      test('soft mute (stopTrackOnMute: false) mutes via the ADM '
          'and keeps the track alive', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final mediaStream = _FakeMediaStream();
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: mediaStream,
        );

        final result = await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );

        expect(result.isSuccess, isTrue);
        verify(() => pcFactory.setMicrophoneMuted(true)).called(1);
        // The capture keeps running — muted inside the ADM, not stopped.
        expect(mediaTrack.stopCallCount, 0);
        expect(mediaStream.disposeCallCount, 0);
        expect(mediaTrack.enabled, isFalse);

        // The stored track must not be flagged for recreation on unmute.
        final storedTrack = rtcManager.tracks[track.trackId];
        expect((storedTrack! as RtcLocalTrack).stopTrackOnMute, isFalse);
      });

      test('unmute lifts the ADM mute and re-enables the track', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );
        final result = await rtcManager.unmuteTrack(trackId: track.trackId);

        expect(result.isSuccess, isTrue);
        verify(() => pcFactory.setMicrophoneMuted(false)).called(1);
        // No recreation happened — the original track was simply re-enabled.
        expect(mediaTrack.enabled, isTrue);
        expect(mediaTrack.stopCallCount, 0);
      });

      test('soft-mute behavior sticks for subsequent default mutes', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );
        await rtcManager.unmuteTrack(trackId: track.trackId);

        // No explicit argument — the track keeps its soft-mute flag.
        await rtcManager.muteTrack(trackId: track.trackId);

        verify(() => pcFactory.setMicrophoneMuted(true)).called(2);
        expect(mediaTrack.stopCallCount, 0);
      });

      test('explicit stopTrackOnMute: true stops the track', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final mediaStream = _FakeMediaStream();
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: mediaStream,
        );

        final result = await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: true,
        );

        expect(result.isSuccess, isTrue);
        verifyNever(() => pcFactory.setMicrophoneMuted(any()));
        expect(mediaTrack.stopCallCount, greaterThan(0));
        expect(mediaStream.disposeCallCount, greaterThan(0));
      });

      test(
        'setMicrophoneEnabled threads stopTrackOnMute down to the mute',
        () async {
          final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
          final track = addAudioTrack(
            mediaTrack: mediaTrack,
            mediaStream: _FakeMediaStream(),
          );

          final result = await rtcManager.setMicrophoneEnabled(
            enabled: false,
            stopTrackOnMute: false,
          );

          expect(result.isSuccess, isTrue);
          verify(() => pcFactory.setMicrophoneMuted(true)).called(1);
          expect(mediaTrack.stopCallCount, 0);
          expect(rtcManager.tracks[track.trackId], isNotNull);
        },
      );

      test('video tracks are not muted through the ADM', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'video');
        final mediaStream = _FakeMediaStream();
        final track = RtcLocalCameraTrack(
          trackIdPrefix: 'test-publisher',
          trackType: SfuTrackType.video,
          mediaStream: mediaStream,
          mediaTrack: mediaTrack,
          mediaConstraints: const CameraConstraints(),
        );
        rtcManager.tracks[track.trackId] = track;

        final result = await rtcManager.muteTrack(trackId: track.trackId);

        expect(result.isSuccess, isTrue);
        verifyNever(() => pcFactory.setMicrophoneMuted(any()));
        // Default video behavior is unchanged: stop-and-release.
        expect(mediaTrack.stopCallCount, greaterThan(0));
      });

      test('publishing a live audio track lifts a leftover ADM mute', () async {
        // The ADM belongs to the per-call factory and outlives sessions.
        // After mute → rejoin → unmute, the new session publishes a fresh
        // track instead of running unmuteTrack — the leftover ADM mute must
        // be lifted or the microphone stays silent.
        final track = RtcLocalAudioTrack(
          trackIdPrefix: 'test-publisher',
          trackType: SfuTrackType.audio,
          mediaStream: _FakeMediaStream(),
          mediaTrack: _FakeMediaStreamTrack(kind: 'audio'),
          mediaConstraints: const AudioConstraints(),
        );

        final result = await rtcManager.publishAudioTrack(track: track);

        expect(result.isSuccess, isTrue);
        verify(() => pcFactory.setMicrophoneMuted(false)).called(1);
      });

      test('publishing a disabled audio track keeps the ADM mute', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio')
          ..enabled = false;
        final track = RtcLocalAudioTrack(
          trackIdPrefix: 'test-publisher',
          trackType: SfuTrackType.audio,
          mediaStream: _FakeMediaStream(),
          mediaTrack: mediaTrack,
          mediaConstraints: const AudioConstraints(),
        );

        final result = await rtcManager.publishAudioTrack(track: track);

        expect(result.isSuccess, isTrue);
        verifyNever(() => pcFactory.setMicrophoneMuted(any()));
      });

      test('ADM mute failure still leaves the track muted', () async {
        when(
          () => pcFactory.setMicrophoneMuted(any()),
        ).thenThrow(Exception('method channel unavailable'));

        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        final result = await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );

        expect(result.isSuccess, isTrue);
        expect(mediaTrack.enabled, isFalse);
      });
    },
  );
}
