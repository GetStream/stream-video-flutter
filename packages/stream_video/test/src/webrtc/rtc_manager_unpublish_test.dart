import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

final _vp8Option = publishOption(1, SfuTrackType.video);
final _vp9Option = publishOption(2, SfuTrackType.video, codec: vp9Codec);
final _micOption = publishOption(3, SfuTrackType.audio);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  group('unpublishTrack', () {
    test(
      'an own local track is stopped with its clones and removed from every '
      'sender of its track type',
      () async {
        final fixture = RtcManagerFixture(
          publishOptions: [_vp8Option, _vp9Option, _micOption],
        );
        final camera = (await fixture.manager.publishVideoTrack(
          track: fakeCameraTrack('cam'),
        )).getDataOrNull()!;
        await fixture.manager.publishAudioTrack(track: fakeAudioTrack('mic'));
        final videoSenders = [
          for (final it in fixture.transceivers)
            if (it.sender.track?.kind == 'video') it.sender,
        ];
        expect(videoSenders, hasLength(2));

        await fixture.manager.unpublishTrack(trackId: camera.trackId);

        final media = fakeMediaOf(camera);
        expect(media.stopped, isTrue);
        expect(media.clones, hasLength(2));
        expect(media.clones.every((it) => it.stopped), isTrue);
        expect(fixture.manager.tracks.containsKey(camera.trackId), isFalse);

        // Both camera senders, and not the microphone's.
        expect(fixture.removedSenders, unorderedEquals(videoSenders));
      },
    );

    test(
      'a track handed over to the next session only stops its clones',
      () async {
        final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
        final camera = (await fixture.manager.publishVideoTrack(
          track: fakeCameraTrack('cam'),
        )).getDataOrNull()!;

        final handedOver = fixture.manager.handOverLocalTracks();
        expect(handedOver, hasLength(1));

        await fixture.manager.unpublishTrack(trackId: camera.trackId);

        final media = fakeMediaOf(camera);
        expect(media.stopped, isFalse, reason: 'the next session sends it');
        expect(media.clones.single.stopped, isTrue);
        expect(fixture.removedSenders, hasLength(1));
      },
    );

    test('a remote track is stopped without touching the publisher', () async {
      final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
      final remoteMedia = FakeMediaStreamTrack('remote', kind: 'video');
      final remote = RtcRemoteTrack(
        trackIdPrefix: 'other-participant',
        trackType: SfuTrackType.video,
        mediaStream: FakeMediaStream(),
        mediaTrack: remoteMedia,
      );
      fixture.manager.tracks[remote.trackId] = remote;

      await fixture.manager.unpublishTrack(trackId: remote.trackId);

      // A remote track's stop only disables it.
      expect(remoteMedia.enabled, isFalse);
      expect(remoteMedia.stopped, isFalse);
      expect(fixture.manager.tracks, isEmpty);
      verifyNever(() => fixture.pc.removeTrack(any()));
    });

    test('an unknown track id is ignored', () async {
      final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
      final camera = (await fixture.manager.publishVideoTrack(
        track: fakeCameraTrack('cam'),
      )).getDataOrNull()!;

      await fixture.manager.unpublishTrack(trackId: 'unknown');

      expect(fixture.manager.tracks.keys, [camera.trackId]);
      expect(fakeMediaOf(camera).stopped, isFalse);
      verifyNever(() => fixture.pc.removeTrack(any()));
    });

    test('a removeTrack that throws does not fail the unpublish', () async {
      final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
      final camera = (await fixture.manager.publishVideoTrack(
        track: fakeCameraTrack('cam'),
      )).getDataOrNull()!;
      when(
        () => fixture.pc.removeTrack(any()),
      ).thenThrow(StateError('peer connection is closed'));

      await fixture.manager.unpublishTrack(trackId: camera.trackId);

      expect(fixture.manager.tracks, isEmpty);
      expect(fakeMediaOf(camera).stopped, isTrue);
    });
  });
}
