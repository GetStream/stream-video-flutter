import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  group('RtcManager track views', () {
    late RtcManagerFixture fixture;
    late RtcLocalAudioTrack local;
    late RtcRemoteTrack remote;

    setUp(() {
      fixture = RtcManagerFixture();
      local = fakeAudioTrack('mic');
      remote = RtcRemoteTrack(
        trackIdPrefix: 'other-participant',
        trackType: SfuTrackType.video,
        mediaStream: FakeMediaStream(),
        mediaTrack: FakeMediaStreamTrack('remote', kind: 'video'),
      );
      fixture.manager.tracks[local.trackId] = local;
      fixture.manager.rtcSubscriber.tracks[remote.trackId] = remote;
    });

    test('split the tracks into local and remote by track id', () {
      expect(fixture.manager.localTracks, {local.trackId: local});
      expect(fixture.manager.remoteTracks, {remote.trackId: remote});
    });

    test('are unmodifiable snapshots', () {
      final localTracks = fixture.manager.localTracks;

      expect(() => localTracks.remove(local.trackId), throwsUnsupportedError);

      fixture.manager.tracks.remove(local.trackId);
      expect(localTracks, {local.trackId: local});
      expect(fixture.manager.localTracks, isEmpty);
    });

    test('getTrack and getTracks find remote tracks too', () {
      expect(fixture.manager.getTrack(remote.trackId), same(remote));
      expect(fixture.manager.getTrack(local.trackId), same(local));
      expect(fixture.manager.getTracks('other-participant'), [remote]);
    });

    test('dispose stops remote tracks and forgets them', () async {
      await fixture.manager.dispose();

      expect(remote.mediaTrack.enabled, isFalse);
      expect(fixture.manager.rtcSubscriber.tracks, isEmpty);
      expect(fixture.manager.tracks, isEmpty);
    });

    test('a native output switch is recorded on remote audio tracks', () async {
      final platform = FakeWebRtcPlatform()..install();
      addTearDown(platform.uninstall);
      final remoteAudio = RtcRemoteTrack(
        trackIdPrefix: 'other-participant',
        trackType: SfuTrackType.audio,
        mediaStream: FakeMediaStream(),
        mediaTrack: FakeMediaStreamTrack('remote-audio', kind: 'audio'),
      );
      fixture.manager.rtcSubscriber.tracks[remoteAudio.trackId] = remoteAudio;

      final result = await fixture.manager.setAudioOutputDevice(
        device: const RtcMediaDevice(
          id: 'headset',
          label: 'Headset',
          kind: RtcMediaDeviceKind.audioOutput,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(
        fixture.manager.rtcSubscriber.tracks[remoteAudio.trackId]!.audioSinkId,
        'headset',
      );
      expect(platform.callsOf('selectAudioOutput'), hasLength(1));
    });
  });
}
