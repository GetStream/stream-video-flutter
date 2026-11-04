import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/media/local_track_acquirer.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeWebRtcPlatform platform;

  setUp(() => platform = FakeWebRtcPlatform()..install());
  tearDown(() => platform.uninstall());

  LocalTrackAcquirer acquirer({String? publisherId = 'test-publisher'}) {
    return LocalTrackAcquirer(
      pcFactory: fakePcFactory(),
      publisherId: publisherId,
    );
  }

  group('singleFlight', () {
    test(
      'joins the acquisition already in flight for the track type',
      () async {
        final tracks = acquirer();
        final gate = Completer<Result<RtcLocalTrack>>();
        var creates = 0;
        Future<Result<RtcLocalTrack>> create() {
          creates++;
          return gate.future;
        }

        final first = tracks.singleFlight(SfuTrackType.video, create);
        final second = tracks.singleFlight(SfuTrackType.video, create);

        expect(creates, 1);
        expect(tracks.inFlight(SfuTrackType.video), isNotNull);
        expect(tracks.inFlight(SfuTrackType.audio), isNull);

        gate.complete(Result.success(fakeCameraTrack('cam')));
        expect(await first, same(await second));
        expect(tracks.inFlight(SfuTrackType.video), isNull);
      },
    );

    test('runs a new acquisition once the last one finished', () async {
      final tracks = acquirer();
      var creates = 0;
      Future<Result<RtcLocalTrack>> create() async {
        creates++;
        return Result.success(fakeCameraTrack('cam-$creates'));
      }

      await tracks.singleFlight(SfuTrackType.video, create);
      await tracks.singleFlight(SfuTrackType.video, create);

      expect(creates, 2);
    });

    test('keeps track types apart', () async {
      final tracks = acquirer();
      final cameraGate = Completer<Result<RtcLocalTrack>>();
      final micGate = Completer<Result<RtcLocalTrack>>();

      final camera = tracks.singleFlight(
        SfuTrackType.video,
        () => cameraGate.future,
      );
      final mic = tracks.singleFlight(SfuTrackType.audio, () => micGate.future);

      expect(tracks.inFlight(SfuTrackType.video), isNotNull);
      expect(tracks.inFlight(SfuTrackType.audio), isNotNull);

      cameraGate.complete(Result.success(fakeCameraTrack('cam')));
      micGate.complete(Result.success(fakeAudioTrack('mic')));
      expect((await camera).getDataOrNull(), isA<RtcLocalCameraTrack>());
      expect((await mic).getDataOrNull(), isA<RtcLocalAudioTrack>());
    });

    test('a failed acquisition leaves the single flight', () async {
      final tracks = acquirer();
      var creates = 0;
      Future<Result<RtcLocalTrack>> create() async {
        creates++;
        return failureWithError('camera busy');
      }

      expect(
        (await tracks.singleFlight(SfuTrackType.video, create)).isFailure,
        isTrue,
      );
      expect(tracks.inFlight(SfuTrackType.video), isNull);

      await tracks.singleFlight(SfuTrackType.video, create);
      expect(creates, 2);
    });
  });

  group('acquire', () {
    test('opens a track of each type with its defaults', () async {
      final tracks = acquirer();

      final camera = await tracks.acquire(trackType: SfuTrackType.video);
      final mic = await tracks.acquire(trackType: SfuTrackType.audio);
      final share = await tracks.acquire(trackType: SfuTrackType.screenShare);

      expect(camera.getDataOrNull(), isA<RtcLocalCameraTrack>());
      expect(mic.getDataOrNull(), isA<RtcLocalAudioTrack>());
      expect(share.getDataOrNull(), isA<RtcLocalScreenShareTrack>());
      expect(camera.getDataOrNull()!.trackIdPrefix, 'test-publisher');
      expect(platform.callsOf('getUserMedia'), hasLength(2));
      expect(platform.callsOf('getDisplayMedia'), hasLength(1));
    });

    test('opens the microphone with the default audio constraints', () async {
      const constraints = AudioConstraints(noiseSuppression: false);
      final tracks = acquirer()..defaultAudioConstraints = constraints;

      final mic = await tracks.acquire(trackType: SfuTrackType.audio);

      expect(
        (mic.getDataOrNull()! as RtcLocalAudioTrack).mediaConstraints,
        constraints,
      );
    });

    test('rejects constraints of another track type', () async {
      final tracks = acquirer();

      final camera = await tracks.acquire(
        trackType: SfuTrackType.video,
        constraints: const AudioConstraints(),
      );
      final mic = await tracks.acquire(
        trackType: SfuTrackType.audio,
        constraints: const CameraConstraints(),
      );
      final share = await tracks.acquire(
        trackType: SfuTrackType.screenShare,
        constraints: const CameraConstraints(),
      );

      expect([camera, mic, share].every((it) => it.isFailure), isTrue);
      expect(platform.calls, isEmpty);
    });

    test('rejects a track type that is not acquired', () async {
      final result = await acquirer().acquire(
        trackType: SfuTrackType.screenShareAudio,
      );

      expect(result.isFailure, isTrue);
    });

    test('opens nothing for a session that does not publish', () async {
      final tracks = acquirer(publisherId: null);

      final results = [
        await tracks.acquire(trackType: SfuTrackType.video),
        await tracks.acquire(trackType: SfuTrackType.audio),
        await tracks.acquire(trackType: SfuTrackType.screenShare),
      ];

      expect(results.every((it) => it.isFailure), isTrue);
      expect(platform.calls, isEmpty);
    });

    test('reports a failing getUserMedia as a failure', () async {
      platform.getUserMediaError = PlatformException(code: 'denied');

      final result = await acquirer().acquire(trackType: SfuTrackType.video);

      expect(result.isFailure, isTrue);
    });
  });
}
