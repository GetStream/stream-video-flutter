import 'dart:async';

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
      'a live track is recaptured with the new constraints and keeps its own '
      'stopTrackOnMute',
      () async {
        final mic = await publishMic(stopTrackOnMute: false);

        await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

        // The source was stopped and acquired again.
        expect(fakeMediaOf(mic).stopped, isTrue);
        expect(platform.callsOf('getUserMedia'), hasLength(1));

        final after = stored(mic.trackId);
        expect(after.mediaConstraints, _newConstraints);
        expect(after.mediaTrack.enabled, isTrue);
        expect(after.stopTrackOnMute, isFalse);
      },
    );

    test('a live track is not muted and unmuted along the way', () async {
      final mic = await publishMic(stopTrackOnMute: true);

      await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

      expect(muteEvents, isEmpty);
      expect(stored(mic.trackId).mediaTrack.enabled, isTrue);
    });

    test("the new capture is sent on the track's sender", () async {
      final mic = await publishMic(stopTrackOnMute: true);
      final sender = fixture.transceivers.single.sender;

      await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

      expect(sender.replacedTracks, hasLength(1));
      expect(stored(mic.trackId).clonedTracks, [sender.track]);
    });

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
      'a failed recapture reports the microphone muted, and unmuting '
      'captures it with the new constraints',
      () async {
        final mic = await publishMic(stopTrackOnMute: false);
        platform.getUserMediaError = PlatformException(code: 'denied');

        await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

        expect(muteEvents, [(mic.trackId, true)]);
        expect(stored(mic.trackId).stopTrackOnMute, isFalse);

        platform.getUserMediaError = null;
        await fixture.manager.unmuteTrack(trackId: mic.trackId);

        expect(stored(mic.trackId).mediaConstraints, _newConstraints);
        expect(stored(mic.trackId).mediaTrack.enabled, isTrue);
      },
    );

    test(
      'a microphone published again during the recapture is not reported '
      'muted',
      () async {
        final mic = await publishMic(stopTrackOnMute: true);
        platform.getUserMediaGate = Completer<void>();

        final changing = fixture.manager.changeDefaultAudioConstraints(
          _newConstraints,
        );
        await pumpEventQueue();
        await fixture.manager.unpublishTrack(trackId: mic.trackId);
        final again = await publishMic(stopTrackOnMute: true);
        platform.getUserMediaGate!.complete();
        await changing;

        expect(muteEvents, isEmpty);
        expect(stored(mic.trackId).mediaTrack, same(again.mediaTrack));
        expect(stored(mic.trackId).mediaTrack.enabled, isTrue);
      },
    );

    test(
      'a change made while a recapture is running is applied after it',
      () async {
        final mic = await publishMic(stopTrackOnMute: true);
        platform.getUserMediaGate = Completer<void>();

        final first = fixture.manager.changeDefaultAudioConstraints(
          _newConstraints,
        );
        await pumpEventQueue();
        final second = fixture.manager.changeDefaultAudioConstraints(
          const AudioConstraints(),
        );
        await pumpEventQueue();
        platform.getUserMediaGate!.complete();
        await Future.wait([first, second]);

        expect(platform.callsOf('getUserMedia'), hasLength(2));
        expect(stored(mic.trackId).mediaConstraints, const AudioConstraints());
        expect(stored(mic.trackId).mediaTrack.enabled, isTrue);
        expect(muteEvents, isEmpty);
      },
    );

    test('a mute while a recapture is running skips the next one', () async {
      final mic = await publishMic(stopTrackOnMute: false);
      platform.getUserMediaGate = Completer<void>();

      final first = fixture.manager.changeDefaultAudioConstraints(
        _newConstraints,
      );
      await pumpEventQueue();
      final muting = fixture.manager.muteTrack(trackId: mic.trackId);
      final second = fixture.manager.changeDefaultAudioConstraints(
        const AudioConstraints(),
      );
      await pumpEventQueue();
      platform.getUserMediaGate!.complete();
      await Future.wait([first, muting, second]);

      expect(platform.callsOf('getUserMedia'), hasLength(1));
      expect(stored(mic.trackId).mediaTrack.enabled, isFalse);
    });

    test('screen share audio is left alone', () async {
      final fixture = RtcManagerFixture(
        publishOptions: [
          _micOption,
          publishOption(2, SfuTrackType.screenShareAudio),
        ],
      );
      final shareAudio = fakeLocalTrack(
        'share-audio',
        trackType: SfuTrackType.screenShareAudio,
        constraints: const AudioConstraints(),
        kind: 'audio',
      );
      await fixture.manager.publishAudioTrack(track: shareAudio);
      await fixture.manager.publishAudioTrack(track: fakeAudioTrack('mic'));

      await fixture.manager.changeDefaultAudioConstraints(_newConstraints);

      expect(platform.callsOf('getUserMedia'), hasLength(1));
      expect(fakeMediaOf(shareAudio).stopped, isFalse);
    });
  });
}
