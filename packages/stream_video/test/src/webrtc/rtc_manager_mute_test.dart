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
    when(
      () => pcFactory.isAppleAdmMicrophoneMuteSupported,
    ).thenReturn(true);
    when(
      () => pcFactory.setAppleAdmMicrophoneMuted(any()),
    ).thenAnswer((_) async {});
    when(
      () => pcFactory.isAppleAdmMicrophoneMuted(),
    ).thenAnswer((_) async => false);

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
    // The ADM-level mute path is gated on the factory reporting ADM support,
    // which is stubbed above so the branch runs on any host (including CI).
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
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
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
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(1);
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
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(false)).called(1);
        // No recreation happened — the original track was simply re-enabled.
        expect(mediaTrack.enabled, isTrue);
        expect(mediaTrack.stopCallCount, 0);
      });

      test('unmute lifts the ADM mute when a soft mute was followed by '
          'a hard mute', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        // A soft mute puts the ADM into the muted state...
        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(1);

        // ...and a hard mute (moderator mute, CallKit, backgrounding) then
        // stops the track without clearing it.
        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: true,
        );

        // Unmute now takes the recreate branch, which needs a real platform
        // getMedia. That part is not exercisable here and does not matter: what
        // matters is that the ADM mute is lifted whichever branch unmute takes.
        // Otherwise the recreated track ends up live and published with capture
        // still silenced inside the ADM, with no in-call way to recover.
        try {
          await rtcManager.unmuteTrack(trackId: track.trackId);
        } catch (_) {
          // Track recreation needs the platform plugin; ignore.
        }

        verify(() => pcFactory.setAppleAdmMicrophoneMuted(false)).called(1);
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

        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(2);
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
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
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
          verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(1);
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
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
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
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(false)).called(1);
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
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
      });

      test('reconcile restores a mute the ADM dropped', () async {
        // Anything that restarts capture (resumeAudio, an internal
        // StartRecording) clears the ADM mute without telling the SDK.
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );
        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );

        // ADM reports unmuted while the SDK considers the track muted.
        await rtcManager.reconcileAppleAdmMicrophoneMute();

        // Once for the mute itself, once for the re-assert.
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(2);
      });

      test('reconcile lifts an ADM mute left on a live track', () async {
        // Muting during an audio suspension and then resuming re-enables the
        // track from the pre-suspension snapshot, leaving the ADM muted while
        // the SDK reports the mic live — the direction where the user talks and
        // nobody hears them.
        when(
          () => pcFactory.isAppleAdmMicrophoneMuted(),
        ).thenAnswer((_) async => true);

        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );
        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );
        // Re-enabled outside of unmuteTrack, as the resume path does.
        mediaTrack.enabled = true;

        await rtcManager.reconcileAppleAdmMicrophoneMute();

        verify(() => pcFactory.setAppleAdmMicrophoneMuted(false)).called(1);
      });

      test('reconcile is a no-op when the ADM already matches', () async {
        when(
          () => pcFactory.isAppleAdmMicrophoneMuted(),
        ).thenAnswer((_) async => true);

        final track = addAudioTrack(
          mediaTrack: _FakeMediaStreamTrack(kind: 'audio'),
          mediaStream: _FakeMediaStream(),
        );
        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );

        await rtcManager.reconcileAppleAdmMicrophoneMute();

        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(1);
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(false));
      });

      test('reconcile leaves a stopped-on-mute track alone', () async {
        // The mute is expressed by stopping the track, so the ADM mute is not
        // the mechanism and has no desired value to enforce.
        when(
          () => pcFactory.isAppleAdmMicrophoneMuted(),
        ).thenAnswer((_) async => true);

        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio')
          ..enabled = false;
        addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        await rtcManager.reconcileAppleAdmMicrophoneMute();

        verifyNever(() => pcFactory.isAppleAdmMicrophoneMuted());
        verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
      });

      test('republishing preserves the ADM-level mute opt-in', () async {
        // publishAudioTrack defaults stopTrackOnMute to true; republishing an
        // existing track must not silently downgrade its mute strategy, or the
        // next mute would stop the track and kill speech detection.
        final track = RtcLocalAudioTrack(
          trackIdPrefix: 'test-publisher',
          trackType: SfuTrackType.audio,
          mediaStream: _FakeMediaStream(),
          mediaTrack: _FakeMediaStreamTrack(kind: 'audio'),
          mediaConstraints: const AudioConstraints(),
          stopTrackOnMute: false,
        );

        final result = await rtcManager.publishTrack(track);

        expect(result.isSuccess, isTrue);
        expect(result.getDataOrNull()!.stopTrackOnMute, isFalse);
      });

      test('switching microphone re-applies the ADM mute', () async {
        final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
        final track = addAudioTrack(
          mediaTrack: mediaTrack,
          mediaStream: _FakeMediaStream(),
        );

        await rtcManager.muteTrack(
          trackId: track.trackId,
          stopTrackOnMute: false,
        );

        // Selecting another input restarts capture, which drops the ADM mute.
        when(
          () => pcFactory.isAppleAdmMicrophoneMuted(),
        ).thenAnswer((_) async => false);

        try {
          await rtcManager.setAudioInputDevice(
            device: SampleCallData.defaultMediaDevice,
          );
        } catch (_) {
          // Selecting an input needs the platform plugin; the reconcile that
          // follows it is what this test is about.
        }

        // Without the reconcile the ADM stays unmuted and Apple's muted-talker
        // detection is disarmed for the rest of the mute.
        verify(() => pcFactory.setAppleAdmMicrophoneMuted(true)).called(2);
      });

      test(
        'changing audio constraints preserves the soft-mute opt-in',
        () async {
          final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
          final track = addAudioTrack(
            mediaTrack: mediaTrack,
            mediaStream: _FakeMediaStream(),
          );
          rtcManager.tracks[track.trackId] = track.copyWith(
            stopTrackOnMute: false,
          );

          // The cycle has to stop and recreate the track, so it forces
          // stopTrackOnMute — but only for the cycle.
          try {
            await rtcManager.changeDefaultAudioConstraints(
              const AudioConstraints(),
            );
          } catch (_) {
            // Track recreation needs the platform plugin.
          }

          expect(
            (rtcManager.tracks[track.trackId]! as RtcLocalAudioTrack)
                .stopTrackOnMute,
            isFalse,
            reason: 'a forced hard mute must not become the new preference',
          );
        },
      );

      test(
        'changing audio constraints leaves an already-muted track muted',
        () async {
          final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
          final track = addAudioTrack(
            mediaTrack: mediaTrack,
            mediaStream: _FakeMediaStream(),
          );

          await rtcManager.muteTrack(
            trackId: track.trackId,
            stopTrackOnMute: false,
          );
          clearInteractions(pcFactory);

          await rtcManager.changeDefaultAudioConstraints(
            const AudioConstraints(),
          );

          expect(
            mediaTrack.enabled,
            isFalse,
            reason: 'a muted user must not be put back on air by a profile '
                'change',
          );
          verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(false));
        },
      );

      test(
        'platforms without ADM-level mute stop the track even when '
        'stopTrackOnMute is false',
        () async {
          when(
            () => pcFactory.isAppleAdmMicrophoneMuteSupported,
          ).thenReturn(false);

          final mediaTrack = _FakeMediaStreamTrack(kind: 'audio');
          final track = addAudioTrack(
            mediaTrack: mediaTrack,
            mediaStream: _FakeMediaStream(),
          );

          await rtcManager.muteTrack(
            trackId: track.trackId,
            stopTrackOnMute: false,
          );

          verifyNever(() => pcFactory.setAppleAdmMicrophoneMuted(any()));
          expect(mediaTrack.enabled, isFalse);
          expect(
            mediaTrack.stopCallCount,
            0,
            reason: 'stopTrackOnMute: false still keeps the track alive; '
                'only the ADM leg is skipped',
          );
        },
      );

      test('ADM mute failure still leaves the track muted', () async {
        when(
          () => pcFactory.setAppleAdmMicrophoneMuted(any()),
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
