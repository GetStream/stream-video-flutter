import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/audio/remote_audio_playback.dart';
import 'package:stream_video/src/sfu/data/models/sfu_track_type.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_remote_track.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockMediaStream extends Mock implements rtc.MediaStream {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockPlayback extends Mock implements RemoteAudioPlayback {}

void main() {
  group('RtcRemoteTrack copyWith', () {
    test('preserves the transceiver', () {
      final transceiver = _MockTransceiver();
      final track = RtcRemoteTrack(
        trackIdPrefix: 'prefix',
        trackType: SfuTrackType.audio,
        mediaStream: _MockMediaStream(),
        mediaTrack: _MockMediaStreamTrack(),
        transceiver: transceiver,
      );

      // `RtcManager.unpublishTrack` resolves the sender through this field, so
      // a copy that drops it silently changes teardown behaviour. Copies are
      // made whenever an audio output device is applied on web.
      final copy = track.copyWith(audioSinkId: 'device-1');

      expect(copy.transceiver, same(transceiver));
      expect(copy.audioSinkId, 'device-1');
    });
  });

  group('RtcRemoteTrack remote audio', () {
    late _MockPlayback playback;
    late _MockMediaStreamTrack mediaTrack;

    setUpAll(() => registerFallbackValue(_MockMediaStreamTrack()));

    setUp(() {
      playback = _MockPlayback();
      RemoteAudioPlayback.instance = playback;
      mediaTrack = _MockMediaStreamTrack();
      when(() => mediaTrack.enabled).thenReturn(true);
      when(
        () => playback.setSinkId(any(), any()),
      ).thenAnswer((_) async {});
    });

    tearDown(() => RemoteAudioPlayback.instance = null);

    RtcRemoteTrack audioTrack({String? audioSinkId}) => RtcRemoteTrack(
      trackIdPrefix: 'alice',
      trackType: SfuTrackType.audio,
      mediaStream: _MockMediaStream(),
      mediaTrack: mediaTrack,
      audioSinkId: audioSinkId,
    );

    test('start plays the track and restores its output', () async {
      final track = audioTrack(audioSinkId: 'speaker');

      await track.start();

      verify(() => playback.start(track.trackId, mediaTrack)).called(1);
      verify(() => playback.setSinkId(track.trackId, 'speaker')).called(1);
    });

    test('a failing output restore does not fail the start', () async {
      when(
        () => playback.setSinkId(any(), any()),
      ).thenThrow(UnsupportedError('no setSinkId'));

      await audioTrack(audioSinkId: 'speaker').start();

      verify(() => playback.start(any(), mediaTrack)).called(1);
    });

    test('stop releases the playback unless it is kept', () async {
      final track = audioTrack();

      await track.stop(disposeWebAudioPlayer: false);
      verifyNever(() => playback.stop(any(), any()));

      await track.stop();
      verify(() => playback.stop(track.trackId, mediaTrack)).called(1);
    });

    test('a video track does not play audio', () async {
      final track = RtcRemoteTrack(
        trackIdPrefix: 'alice',
        trackType: SfuTrackType.video,
        mediaStream: _MockMediaStream(),
        mediaTrack: mediaTrack,
      );

      await track.start();
      await track.stop();

      verifyZeroInteractions(playback);
    });
  });
}
