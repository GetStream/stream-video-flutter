import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/audio/adm_microphone_mute.dart';
import 'package:stream_video/src/webrtc/media/capture_dimension.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/publisher/rtc_publisher.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../fixtures/rtc_manager_fakes.dart';

final _mic = publishOption(1, SfuTrackType.audio);

/// An offer naming [trackId] in an audio m-section with [mid].
String _offer({required String trackId, required String mid}) {
  return [
    'v=0',
    'o=- 1 2 IN IP4 127.0.0.1',
    's=-',
    't=0 0',
    'm=audio 9 UDP/TLS/RTP/SAVPF 111',
    'c=IN IP4 0.0.0.0',
    'a=sendonly',
    'a=msid:stream-id $trackId',
    'a=mid:$mid',
    '',
  ].join('\r\n');
}

void main() {
  setUpAll(registerRtcManagerFallbacks);

  late MockTracedPeerConnection pc;
  late MockPeerConnection nativePc;
  late List<FakeTransceiver> transceivers;
  late SfuAudioBitrateProfile bitrateProfile;
  late StreamAudioSettings audioSettings;

  setUp(() {
    pc = MockTracedPeerConnection();
    nativePc = MockPeerConnection();
    transceivers = [];
    bitrateProfile = SfuAudioBitrateProfile.voiceStandard;
    audioSettings = const StreamAudioSettings();

    when(() => pc.pc).thenReturn(nativePc);
    when(() => pc.isReconnecting).thenReturn(false);
    when(() => pc.onRenegotiationNeeded).thenReturn(null);
    when(pc.dispose).thenAnswer((_) async {});
    when(() => nativePc.removeTrack(any())).thenAnswer((_) async => true);
    when(
      () => pc.addAudioTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
      ),
    ).thenAnswer((invocation) async {
      final track = invocation.namedArguments[#track] as rtc.MediaStreamTrack;
      final transceiver = FakeTransceiver(FakeSender(track));
      transceivers.add(transceiver);
      return Result.success(transceiver);
    });
  });

  RtcPublisher publisher({
    bool withPc = true,
    List<SfuPublishOptions>? publishOptions,
  }) {
    return RtcPublisher(
      pc: withPc ? pc : null,
      publisherId: 'alice',
      publishOptions: publishOptions ?? [_mic],
      admMute: () => const NoAdmMicrophoneMute(),
      captureDimensionResolver: const CaptureDimensionResolver(),
      audioBitrateProfile: () => bitrateProfile,
      audioSettings: () => audioSettings,
      defaultAudioConstraints: () => const AudioConstraints(),
    );
  }

  RtcLocalAudioTrack localMic() => fakeLocalTrack(
    'mic',
    trackType: SfuTrackType.audio,
    constraints: const AudioConstraints(),
    kind: 'audio',
    trackIdPrefix: kLocalTrackIdPrefix,
  );

  group('publishAudioTrack', () {
    test(
      'keeps the track under the publisher id and sends a clone per option',
      () async {
        final rtcPublisher = publisher(
          publishOptions: [_mic, publishOption(2, SfuTrackType.audio)],
        );
        final published = <RtcLocalTrack>[];
        rtcPublisher.onLocalTrackPublished = published.add;

        final result = await rtcPublisher.publishAudioTrack(track: localMic());

        final track = result.getDataOrNull()!;
        expect(track.trackIdPrefix, 'alice');
        expect(rtcPublisher.tracks, {track.trackId: track});
        expect(published, [track]);
        expect(transceivers, hasLength(2));
        expect(track.clonedTracks, hasLength(2));
        expect(
          transceivers.map((it) => it.sender.track),
          track.clonedTracks,
        );
      },
    );

    test('records the audio bitrate profile of the call', () async {
      bitrateProfile = SfuAudioBitrateProfile.musicHighQuality;
      final rtcPublisher = publisher();

      await rtcPublisher.publishAudioTrack(track: localMic());

      expect(
        rtcPublisher.transceiversManager
            .get(_mic)!
            .trackPublishOptions
            .audioBitrateProfile,
        SfuAudioBitrateProfile.musicHighQuality,
      );
    });

    test('fails and keeps nothing without a peer connection', () async {
      final rtcPublisher = publisher(withPc: false);

      final result = await rtcPublisher.publishAudioTrack(track: localMic());

      expect(result.isFailure, isTrue);
      expect(rtcPublisher.tracks, isEmpty);
    });

    test('discards a publish still in flight once disposing', () async {
      final gate = Completer<void>();
      final mic = localMic();
      fakeMediaOf(mic).cloneGate = gate;
      final rtcPublisher = publisher();

      final publishing = rtcPublisher.publishAudioTrack(track: mic);
      rtcPublisher.beginDispose();
      gate.complete();

      expect((await publishing).isFailure, isTrue);
      expect(rtcPublisher.tracks, isEmpty);
    });
  });

  group('republishing on a reused sender', () {
    late List<StreamPeerConnection> renegotiations;
    late RtcPublisher rtcPublisher;

    setUp(() {
      renegotiations = [];
      when(() => pc.onRenegotiationNeeded).thenReturn(renegotiations.add);
      when(nativePc.getTransceivers).thenAnswer((_) async => []);
      rtcPublisher = publisher();
    });

    Future<RtcLocalTrack> publishMic() async {
      final result = await rtcPublisher.publishAudioTrack(track: localMic());
      return result.getDataOrNull()!;
    }

    test('forces a renegotiation the SFU never acknowledged', () async {
      await publishMic();
      expect(renegotiations, isEmpty);

      await publishMic();

      expect(renegotiations, [pc]);
    });

    test('does not renegotiate once the SFU acknowledged the sender', () async {
      final track = await publishMic();
      final announced = await rtcPublisher.getAnnouncedTracks(
        sdp: _offer(trackId: track.clonedTracks.single.id!, mid: '0'),
      );
      rtcPublisher.markNegotiated(announced!);

      await publishMic();

      expect(renegotiations, isEmpty);
    });

    test('does not renegotiate while the peer connection reconnects', () async {
      await publishMic();
      when(() => pc.isReconnecting).thenReturn(true);

      await publishMic();

      expect(renegotiations, isEmpty);
    });
  });

  group('unpublishTrack', () {
    test('stops the track and removes its senders', () async {
      final rtcPublisher = publisher();
      final track = (await rtcPublisher.publishAudioTrack(
        track: localMic(),
      )).getDataOrNull()!;

      expect(await rtcPublisher.unpublishTrack(trackId: track.trackId), isTrue);

      expect(rtcPublisher.tracks, isEmpty);
      expect(fakeMediaOf(track).stopped, isTrue);
      verify(
        () => nativePc.removeTrack(transceivers.single.sender),
      ).called(1);
    });

    test('is false for a track it does not hold', () async {
      expect(await publisher().unpublishTrack(trackId: 'unknown'), isFalse);
    });
  });

  group('mute', () {
    test('a track it does not hold is not found', () async {
      final rtcPublisher = publisher();

      for (final result in [
        await rtcPublisher.muteTrack(trackId: 'unknown'),
        await rtcPublisher.unmuteTrack(trackId: 'unknown'),
      ]) {
        expect(result.isFailure, isTrue);
        expect(result.getErrorOrNull()!.message, 'Track not found');
      }
    });

    test('reports a mute and an unmute of a track it holds', () async {
      final rtcPublisher = publisher();
      final track = (await rtcPublisher.publishAudioTrack(
        track: localMic(),
        stopTrackOnMute: false,
      )).getDataOrNull()!;
      final muted = <bool>[];
      rtcPublisher.onLocalTrackMuted = (_, isMuted) => muted.add(isMuted);

      await rtcPublisher.muteTrack(trackId: track.trackId);
      expect(fakeMediaOf(track).enabled, isFalse);
      await rtcPublisher.unmuteTrack(trackId: track.trackId);
      expect(fakeMediaOf(track).enabled, isTrue);

      expect(muted, [true, false]);
    });
  });

  test('announces audio with the audio settings of the call', () async {
    final rtcPublisher = publisher();
    audioSettings = const StreamAudioSettings(hifiAudioEnabled: true);
    when(nativePc.getTransceivers).thenAnswer((_) async => []);
    final track = (await rtcPublisher.publishAudioTrack(
      track: localMic(),
    )).getDataOrNull()!;

    final announced = await rtcPublisher.getAnnouncedTracks(
      sdp: _offer(trackId: track.clonedTracks.single.id!, mid: '0'),
    );

    expect(announced!.single.mid, '0');
    expect(announced.single.stereo, isTrue);
  });

  group('singleFlight', () {
    test(
      'joins the acquire-and-publish already in flight for the track type',
      () async {
        final rtcPublisher = publisher();
        final gate = Completer<Result<RtcLocalTrack>>();
        var creates = 0;
        Future<Result<RtcLocalTrack>> create() {
          creates++;
          return gate.future;
        }

        final first = rtcPublisher.singleFlight(SfuTrackType.video, create);
        final second = rtcPublisher.singleFlight(SfuTrackType.video, create);

        expect(creates, 1);
        expect(rtcPublisher.inFlight(SfuTrackType.video), isNotNull);
        expect(rtcPublisher.inFlight(SfuTrackType.audio), isNull);

        gate.complete(Result.success(fakeCameraTrack('cam')));
        expect(await first, same(await second));
        expect(rtcPublisher.inFlight(SfuTrackType.video), isNull);
      },
    );

    test('runs a new one once the last one finished', () async {
      final rtcPublisher = publisher();
      var creates = 0;
      Future<Result<RtcLocalTrack>> create() async {
        creates++;
        return Result.success(fakeCameraTrack('cam-$creates'));
      }

      await rtcPublisher.singleFlight(SfuTrackType.video, create);
      await rtcPublisher.singleFlight(SfuTrackType.video, create);

      expect(creates, 2);
    });

    test('keeps track types apart', () async {
      final rtcPublisher = publisher();
      final cameraGate = Completer<Result<RtcLocalTrack>>();
      final micGate = Completer<Result<RtcLocalTrack>>();

      final camera = rtcPublisher.singleFlight(
        SfuTrackType.video,
        () => cameraGate.future,
      );
      final mic = rtcPublisher.singleFlight(
        SfuTrackType.audio,
        () => micGate.future,
      );

      expect(rtcPublisher.inFlight(SfuTrackType.video), isNotNull);
      expect(rtcPublisher.inFlight(SfuTrackType.audio), isNotNull);

      cameraGate.complete(Result.success(fakeCameraTrack('cam')));
      micGate.complete(Result.success(fakeAudioTrack('mic')));
      expect((await camera).getDataOrNull(), isA<RtcLocalCameraTrack>());
      expect((await mic).getDataOrNull(), isA<RtcLocalAudioTrack>());
    });

    test('a failed one leaves the single flight', () async {
      final rtcPublisher = publisher();
      var creates = 0;
      Future<Result<RtcLocalTrack>> create() async {
        creates++;
        return failureWithError('camera busy');
      }

      expect(
        (await rtcPublisher.singleFlight(SfuTrackType.video, create)).isFailure,
        isTrue,
      );
      expect(rtcPublisher.inFlight(SfuTrackType.video), isNull);

      await rtcPublisher.singleFlight(SfuTrackType.video, create);
      expect(creates, 2);
    });
  });
}
