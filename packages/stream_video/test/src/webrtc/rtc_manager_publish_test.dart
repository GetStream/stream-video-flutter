import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/codecs_helper.dart';
import 'package:stream_video/src/webrtc/media/capture_dimension.dart';
import 'package:stream_video/src/webrtc/model/rtc_audio_bitrate_preset.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

final _micOption = publishOption(1, SfuTrackType.audio);
final _vp8Option = publishOption(2, SfuTrackType.video);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  late FakeWebRtcPlatform platform;

  setUp(() {
    platform = FakeWebRtcPlatform()..install();
  });

  tearDown(() => platform.uninstall());

  group('publishAudioTrack failure cleanup', () {
    test(
      'a failed transceiver stops the clone and the source, drops the '
      'registered entry and returns the failure',
      () async {
        final fixture = RtcManagerFixture(publishOptions: [_micOption]);
        fixture.onAddAudioTransceiver = (_, _) async =>
            failureWithError('platform refused the transceiver');
        final mic = fakeAudioTrack('mic');

        final result = await fixture.manager.publishAudioTrack(track: mic);

        expect(result.isFailure, isTrue);
        expect(fixture.manager.tracks, isEmpty);
        final media = fakeMediaOf(mic);
        expect(media.stopped, isTrue);
        expect(media.clones.single.stopped, isTrue);
      },
    );

    test('a dispose that lands mid-publish discards the track', () async {
      final fixture = RtcManagerFixture(publishOptions: [_micOption]);
      final entered = Completer<void>();
      final gate = Completer<void>();
      fixture.onAddAudioTransceiver = (track, encodings) async {
        entered.complete();
        await gate.future;
        return Result.success(fixture.newTransceiver(track, encodings));
      };
      final mic = fakeAudioTrack('mic');

      final publishing = fixture.manager.publishAudioTrack(track: mic);
      await entered.future;

      final disposing = fixture.manager.dispose();
      gate.complete();

      final result = await publishing;
      await disposing;

      expect(result.isFailure, isTrue);
      expect(fixture.manager.tracks, isEmpty);
      final media = fakeMediaOf(mic);
      expect(media.stopped, isTrue);
      // Only the mid-publish discard stops the clone the publish made.
      expect(media.clones.single.stopped, isTrue);
    });
  });

  group('publishing without a matching publish option', () {
    test(
      'a video track fails, is not registered and has its source stopped',
      () async {
        final fixture = RtcManagerFixture(publishOptions: [_micOption]);
        final camera = fakeCameraTrack('cam');

        final result = await fixture.manager.publishVideoTrack(track: camera);

        expect(result.isFailure, isTrue);
        expect(fixture.manager.tracks, isEmpty);
        expect(fakeMediaOf(camera).stopped, isTrue);
        expect(fixture.transceivers, isEmpty);
      },
    );

    test(
      'an audio track succeeds and stays registered with no sender '
      '(bug 1 of FLU-1046, pinned as it behaves today; fixed in T13)',
      () async {
        final fixture = RtcManagerFixture(publishOptions: [_vp8Option]);
        final mic = fakeAudioTrack('mic');

        final result = await fixture.manager.publishAudioTrack(track: mic);

        expect(result.isSuccess, isTrue);
        expect(fixture.manager.tracks.keys, [mic.trackId]);
        expect(fixture.transceivers, isEmpty);
        // The microphone keeps capturing for a sender that does not exist.
        expect(fakeMediaOf(mic).stopped, isFalse);
      },
    );
  });

  group('audio bitrate profile', () {
    ({RtcManagerFixture fixture, MutableCallStateManager state}) build() {
      final state = MutableCallStateManager();
      final fixture = RtcManagerFixture(
        publishOptions: [_micOption],
        stateManager: state.mock,
      );
      return (fixture: fixture, state: state);
    }

    test(
      'republishing on a cached transceiver with a changed profile updates '
      'the first encoding’s max bitrate',
      () async {
        final wires = build();
        await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic'),
        );
        final sender = wires.fixture.transceivers.single.sender;
        expect(
          sender.parameters.encodings!.single.maxBitrate,
          AudioBitrate.voiceStandard,
        );

        wires.state.state = wires.state.state.copyWith(
          audioBitrateProfile: SfuAudioBitrateProfile.musicHighQuality,
        );
        await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic2'),
        );

        expect(wires.fixture.transceivers, hasLength(1));
        expect(
          sender.setParametersCalls.single.encodings!.single.maxBitrate,
          AudioBitrate.musicHighQuality,
        );
      },
    );

    test(
      'republishing on a cached transceiver with the same profile does not '
      'set parameters',
      () async {
        final wires = build();
        await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic'),
        );

        await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic2'),
        );

        final sender = wires.fixture.transceivers.single.sender;
        expect(sender.setParametersCalls, isEmpty);
      },
    );

    test(
      'unmuting a released track recreates it with the current profile',
      () async {
        final wires = build();
        final mic = (await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic'),
        )).getDataOrNull()!;
        await wires.fixture.manager.muteTrack(trackId: mic.trackId);

        wires.state.state = wires.state.state.copyWith(
          audioBitrateProfile: SfuAudioBitrateProfile.voiceHighQuality,
        );
        final unmuted = await wires.fixture.manager.unmuteTrack(
          trackId: mic.trackId,
        );

        expect(unmuted.isSuccess, isTrue);
        expect(platform.callsOf('getUserMedia'), hasLength(1));
        final sender = wires.fixture.transceivers.single.sender;
        expect(
          sender.setParametersCalls.single.encodings!.single.maxBitrate,
          AudioBitrate.voiceHighQuality,
        );
      },
    );

    test(
      'unmuting a released track with an unchanged profile does not set '
      'parameters',
      () async {
        final wires = build();
        final mic = (await wires.fixture.manager.publishAudioTrack(
          track: fakeAudioTrack('mic'),
        )).getDataOrNull()!;
        await wires.fixture.manager.muteTrack(trackId: mic.trackId);

        await wires.fixture.manager.unmuteTrack(trackId: mic.trackId);

        expect(platform.callsOf('getUserMedia'), hasLength(1));
        final sender = wires.fixture.transceivers.single.sender;
        expect(sender.setParametersCalls, isEmpty);
      },
    );
  });

  group('capture size', () {
    const screen = RtcVideoDimension(width: 1000, height: 500);
    final shareOption = publishOption(3, SfuTrackType.screenShare);

    RtcManagerFixture build() {
      return RtcManagerFixture(
        publishOptions: [shareOption],
        captureDimensionResolver: CaptureDimensionResolver(
          screenDimension: () => screen,
        ),
      );
    }

    test('the published track carries the resolved size', () async {
      final fixture = build();

      final result = await fixture.manager.publishVideoTrack(
        track: fakeScreenShareTrack('share'),
      );

      expect(result.getDataOrNull()!.videoDimension, screen);
    });

    test('the sender encodes at the resolved size', () async {
      final fixture = build();
      final sent = <RTCRtpEncodingWithDimensions>[];
      fixture.onAddVideoTransceiver = (track, encodings) async {
        sent.addAll(encodings.cast<RTCRtpEncodingWithDimensions>());
        return Result.success(fixture.newTransceiver(track, encodings));
      };

      await fixture.manager.publishVideoTrack(
        track: fakeScreenShareTrack('share'),
      );

      final top = sent.last;
      expect((top.width, top.height), (1000, 500));
    });

    test('the announce uses the resolved size', () async {
      final fixture = build();
      await fixture.manager.publishVideoTrack(
        track: fakeScreenShareTrack('share'),
      );
      final sentId = fixture.transceivers.single.sender.track!.id;

      final announced = await fixture.manager.getAnnouncedTracks(
        sdp: [
          'v=0',
          'o=- 1 2 IN IP4 127.0.0.1',
          's=-',
          't=0 0',
          'm=video 9 UDP/TLS/RTP/SAVPF 96',
          'c=IN IP4 0.0.0.0',
          'a=sendonly',
          'a=msid:stream-id $sentId',
          'a=mid:0',
          '',
        ].join('\r\n'),
      );

      expect(
        announced!.single.layers!.last.parameters.dimension,
        screen,
      );
    });
  });

  group('enabling a track', () {
    test('opens no device for a session without a publisher', () async {
      final fixture = RtcManagerFixture(
        publishOptions: [_vp8Option],
        withPublisher: false,
      );

      final result = await fixture.manager.setCameraEnabled();

      expect(result.isFailure, isTrue);
      expect(platform.callsOf('getUserMedia'), isEmpty);
    });

    test('publishes the microphone on an audio transceiver', () async {
      final fixture = RtcManagerFixture(publishOptions: [_micOption]);
      var audioTransceivers = 0;
      fixture.onAddAudioTransceiver = (track, encodings) async {
        audioTransceivers++;
        return Result.success(fixture.newTransceiver(track, encodings));
      };

      final result = await fixture.manager.setMicrophoneEnabled();

      expect(result.getDataOrNull(), isA<RtcLocalAudioTrack>());
      expect(audioTransceivers, 1);
    });

    test('publishes the screen share on a video transceiver', () async {
      final fixture = RtcManagerFixture(
        publishOptions: [publishOption(4, SfuTrackType.screenShare)],
      );

      final result = await fixture.manager.setScreenShareEnabled();

      expect(result.getDataOrNull(), isA<RtcLocalScreenShareTrack>());
      expect(platform.callsOf('getDisplayMedia'), hasLength(1));
      expect(fixture.transceivers, hasLength(1));
    });
  });
}
