import 'package:flutter_test/flutter_test.dart';
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
  });
}
