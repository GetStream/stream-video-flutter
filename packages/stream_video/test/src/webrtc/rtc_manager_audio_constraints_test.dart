import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

final _micOption = publishOption(1, SfuTrackType.audio);

const _newConstraints = AudioConstraints(noiseSuppression: false);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  late FakeWebRtcPlatform platform;
  late RtcManagerFixture fixture;
  late List<(String, bool)> muteEvents;

  setUp(() {
    platform = FakeWebRtcPlatform()..install();
    fixture = RtcManagerFixture(publishOptions: [_micOption]);
    muteEvents = [];
    fixture.manager.onLocalTrackMuted = (track, muted) {
      muteEvents.add((track.trackId, muted));
    };
  });

  tearDown(() => platform.uninstall());

  Future<RtcLocalAudioTrack> publishMic({required bool stopTrackOnMute}) async {
    final result = await fixture.manager.publishAudioTrack(
      track: fakeAudioTrack('mic'),
      stopTrackOnMute: stopTrackOnMute,
    );
    return result.getDataOrNull()!;
  }

  RtcLocalAudioTrack stored(String trackId) {
    return fixture.manager.tracks[trackId]! as RtcLocalAudioTrack;
  }

  group('changeDefaultAudioConstraints', () {
    test(
      'a live track is muted with stopTrackOnMute forced on, recreated with '
      'the new constraints, and keeps its own stopTrackOnMute',
      () async {
        final mic = await publishMic(stopTrackOnMute: false);

        await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

        // Forced: the source was stopped and acquired again.
        expect(fakeMediaOf(mic).stopped, isTrue);
        expect(platform.callsOf('getUserMedia'), hasLength(1));

        final after = stored(mic.trackId);
        expect(after.mediaConstraints, _newConstraints);
        expect(after.mediaTrack.enabled, isTrue);
        expect(after.stopTrackOnMute, isFalse);
      },
    );

    test(
      'onLocalTrackMuted fires twice per live track (bug 2 of FLU-1046, '
      'pinned as it behaves today; fixed in T13)',
      () async {
        final mic = await publishMic(stopTrackOnMute: true);

        await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

        expect(muteEvents, [(mic.trackId, true), (mic.trackId, false)]);
      },
    );

    test('a muted track is left muted', () async {
      final mic = await publishMic(stopTrackOnMute: false);
      await fixture.manager.muteTrack(trackId: mic.trackId);
      muteEvents.clear();

      await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

      expect(muteEvents, isEmpty);
      expect(platform.callsOf('getUserMedia'), isEmpty);
      expect(stored(mic.trackId).mediaTrack.enabled, isFalse);

      // It picks the new constraints up when it is unmuted.
      await fixture.manager.unmuteTrack(trackId: mic.trackId);

      expect(platform.callsOf('getUserMedia'), hasLength(1));
      expect(stored(mic.trackId).mediaConstraints, _newConstraints);
    });

    test(
      'the original stopTrackOnMute is restored when the cycle throws',
      () async {
        final mic = await publishMic(stopTrackOnMute: false);
        platform.getUserMediaError = PlatformException(code: 'denied');

        await expectLater(
          fixture.manager.changeDefaultAudioConstraints(_newConstraints),
          throwsA(startsWith('Unable to getUserMedia')),
        );

        expect(stored(mic.trackId).stopTrackOnMute, isFalse);
      },
    );
  });
}
