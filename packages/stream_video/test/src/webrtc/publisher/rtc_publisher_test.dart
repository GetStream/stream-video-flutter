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
final _camera = publishOption(2, SfuTrackType.video);

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

  /// Answers each `addAudioTransceiver` call, in order. The calls after the
  /// last answer succeed at once.
  late List<Future<Result<rtc.RTCRtpTransceiver>> Function(FakeTransceiver)>
  addAudioAnswers;
  late int addAudioCalls;

  setUp(() {
    addAudioAnswers = [];
    addAudioCalls = 0;
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
      final call = addAudioCalls++;
      final result = call < addAudioAnswers.length
          ? await addAudioAnswers[call](transceiver)
          : Result.success(transceiver);
      if (result.isSuccess) transceivers.add(transceiver);
      return result;
    });
  });

  RtcLocalVideoTrack localCamera() => fakeLocalTrack(
    'cam',
    trackType: SfuTrackType.video,
    constraints: const CameraConstraints(),
    kind: 'video',
    trackIdPrefix: kLocalTrackIdPrefix,
  );

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
      final rtcPublisher = publisher();
      bitrateProfile = SfuAudioBitrateProfile.musicHighQuality;

      await rtcPublisher.publishAudioTrack(track: localMic());

      expect(
        rtcPublisher.transceiversManager
            .get(_mic)!
            .trackPublishOptions
            .audioBitrateProfile,
        SfuAudioBitrateProfile.musicHighQuality,
      );
    });

    test(
      'a publish waiting on a claim reads the bitrate profile once it holds '
      'the key',
      () async {
        final gate = Completer<void>();
        addAudioAnswers = [
          (transceiver) async {
            await gate.future;
            return Result.success(transceiver);
          },
        ];
        final rtcPublisher = publisher();

        final first = rtcPublisher.publishAudioTrack(track: localMic());
        await pumpEventQueue();
        final second = rtcPublisher.publishAudioTrack(track: localMic());
        await pumpEventQueue();
        bitrateProfile = SfuAudioBitrateProfile.musicHighQuality;
        gate.complete();
        await Future.wait([first, second]);

        expect(addAudioCalls, 1);
        expect(
          rtcPublisher.transceiversManager
              .get(_mic)!
              .trackPublishOptions
              .audioBitrateProfile,
          SfuAudioBitrateProfile.musicHighQuality,
        );
      },
    );

    test(
      'when the claim holder fails, one waiter creates the sender and the '
      'other reuses it',
      () async {
        final gate = Completer<void>();
        addAudioAnswers = [
          (_) async {
            await gate.future;
            return failureWithError('platform refused');
          },
        ];
        final rtcPublisher = publisher();

        final a = rtcPublisher.publishAudioTrack(track: localMic());
        await pumpEventQueue();
        final b = rtcPublisher.publishAudioTrack(track: localMic());
        final c = rtcPublisher.publishAudioTrack(track: localMic());
        await pumpEventQueue();
        gate.complete();

        expect((await a).isFailure, isTrue);
        expect((await b).isSuccess, isTrue);
        expect((await c).isSuccess, isTrue);
        expect(addAudioCalls, 2);
        expect(rtcPublisher.transceiversManager.items(), hasLength(1));
        expect(transceivers.single.sender.replacedTracks, hasLength(1));
      },
    );

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

  group('isPublisherEmpty', () {
    test('is true until a publish claims a sender, and false after', () async {
      when(nativePc.getTransceivers).thenAnswer((_) async => []);
      final gate = Completer<void>();
      addAudioAnswers = [
        (transceiver) async {
          await gate.future;
          return Result.success(transceiver);
        },
      ];
      final rtcPublisher = publisher();

      expect(await rtcPublisher.isPublisherEmpty(), isTrue);

      final publishing = rtcPublisher.publishAudioTrack(track: localMic());
      await pumpEventQueue();
      expect(await rtcPublisher.isPublisherEmpty(), isFalse);

      gate.complete();
      await publishing;
      expect(await rtcPublisher.isPublisherEmpty(), isFalse);
    });

    test('is false while the peer connection reports a transceiver', () async {
      when(
        nativePc.getTransceivers,
      ).thenAnswer((_) async => [FakeTransceiver(FakeSender(null))]);

      expect(await publisher().isPublisherEmpty(), isFalse);
    });
  });

  group('audio and video share one publish path', () {
    setUp(() {
      when(
        () => pc.addVideoTransceiver(
          track: any(named: 'track'),
          encodings: any(named: 'encodings'),
          degradationPreference: any(named: 'degradationPreference'),
        ),
      ).thenAnswer((_) async => failureWithError('platform refused'));
      addAudioAnswers = [(_) async => failureWithError('platform refused')];
    });

    for (final (kind, publish) in [
      (
        'audio',
        (RtcPublisher p) =>
            p.publishTrack(localMic()).then((r) => (r, p.tracks)),
      ),
      (
        'video',
        (RtcPublisher p) =>
            p.publishTrack(localCamera()).then((r) => (r, p.tracks)),
      ),
    ]) {
      test('a failed $kind transceiver keeps nothing', () async {
        final rtcPublisher = publisher(publishOptions: [_mic, _camera]);
        final published = <RtcLocalTrack>[];
        rtcPublisher.onLocalTrackPublished = published.add;

        final (result, tracks) = await publish(rtcPublisher);

        expect(result.isFailure, isTrue);
        expect(tracks, isEmpty);
        expect(published, isEmpty);
        expect(rtcPublisher.transceiversManager.items(), isEmpty);
      });

      test('a $kind track without a publish option fails', () async {
        final rtcPublisher = publisher(publishOptions: []);

        final (result, tracks) = await publish(rtcPublisher);

        expect(result.isFailure, isTrue);
        expect(tracks, isEmpty);
      });
    }

    test('both stop the source and the clone of a failed publish', () async {
      final rtcPublisher = publisher(publishOptions: [_mic, _camera]);
      final mic = localMic();
      final camera = localCamera();

      await rtcPublisher.publishTrack(mic);
      await rtcPublisher.publishTrack(camera);

      for (final track in [mic, camera]) {
        final media = fakeMediaOf(track);
        expect(media.stopped, isTrue, reason: '${track.trackType}');
        expect(
          media.clones.single.stopped,
          isTrue,
          reason: '${track.trackType}',
        );
      }
    });
  });

  group('a track unpublished while it is recaptured', () {
    late FakeWebRtcPlatform platform;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      platform = FakeWebRtcPlatform()..install();
    });

    tearDown(() => platform.uninstall());

    test('is not brought back, and its new capture is stopped', () async {
      final rtcPublisher = publisher();
      final track = (await rtcPublisher.publishAudioTrack(
        track: localMic(),
      )).getDataOrNull()!;
      await rtcPublisher.muteTrack(trackId: track.trackId);
      platform.getUserMediaGate = Completer<void>();

      final unmuting = rtcPublisher.unmuteTrack(trackId: track.trackId);
      await pumpEventQueue();
      await rtcPublisher.unpublishTrack(trackId: track.trackId);
      platform.getUserMediaGate!.complete();

      expect((await unmuting).isFailure, isTrue);
      expect(rtcPublisher.tracks, isEmpty);
      expect(platform.disposedTrackIds, isNotEmpty);
    });

    test('keepIfHeld does not bring it back either', () async {
      final rtcPublisher = publisher();
      final track = (await rtcPublisher.publishAudioTrack(
        track: localMic(),
      )).getDataOrNull()!;
      await rtcPublisher.unpublishTrack(trackId: track.trackId);

      expect(rtcPublisher.keepIfHeld(track, track), isFalse);
      expect(rtcPublisher.tracks, isEmpty);
    });
  });

  test('republishing a video track keeps its stopTrackOnMute', () async {
    when(
      () => pc.addVideoTransceiver(
        track: any(named: 'track'),
        encodings: any(named: 'encodings'),
        degradationPreference: any(named: 'degradationPreference'),
      ),
    ).thenAnswer(
      (invocation) async => Result.success(
        FakeTransceiver(
          FakeSender(invocation.namedArguments[#track] as rtc.MediaStreamTrack),
        ),
      ),
    );
    final rtcPublisher = publisher(publishOptions: [_camera]);

    final result = await rtcPublisher.publishTrack(
      localCamera().copyWith(stopTrackOnMute: false),
    );

    expect(result.getDataOrNull()!.stopTrackOnMute, isFalse);
  });

  group('dispose', () {
    test(
      'stops the local tracks and closes the peer connection without taking '
      'them off their senders',
      () async {
        final rtcPublisher = publisher();
        final track = (await rtcPublisher.publishAudioTrack(
          track: localMic(),
        )).getDataOrNull()!;
        final published = <RtcLocalTrack>[];
        rtcPublisher.onLocalTrackPublished = published.add;

        await rtcPublisher.dispose();

        expect(rtcPublisher.tracks, isEmpty);
        expect(fakeMediaOf(track).stopped, isTrue);
        expect(rtcPublisher.onLocalTrackPublished, isNull);
        verifyNever(() => nativePc.removeTrack(any()));
        verify(pc.dispose).called(1);
      },
    );

    test('stops only the clones of a handed-over track', () async {
      final rtcPublisher = publisher();
      final track = (await rtcPublisher.publishAudioTrack(
        track: localMic(),
      )).getDataOrNull()!;
      rtcPublisher.handOverLocalTracks();

      await rtcPublisher.dispose();

      expect(fakeMediaOf(track).stopped, isFalse);
      expect(fakeMediaOf(track).clones.single.stopped, isTrue);
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
