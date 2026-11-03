import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

final _vp8Option = publishOption(1, SfuTrackType.video);
final _vp9Option = publishOption(2, SfuTrackType.video, codec: vp9Codec);

const _frontCamera = {
  'deviceId': 'front-camera',
  'groupId': 'camera',
  'kind': 'videoinput',
  'label': 'Front Camera',
};

const _backCamera = {
  'deviceId': 'back-camera',
  'groupId': 'camera',
  'kind': 'videoinput',
  'label': 'Back Camera',
};

const _otherCamera = RtcMediaDevice(
  id: 'usb-camera',
  label: 'USB Camera',
  kind: RtcMediaDeviceKind.videoInput,
);

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerRtcManagerFallbacks();
  });

  late FakeWebRtcPlatform platform;
  late RtcManagerFixture fixture;

  setUp(() {
    platform = FakeWebRtcPlatform()
      ..sources = const [_frontCamera, _backCamera]
      ..install();
    fixture = RtcManagerFixture(publishOptions: [_vp8Option, _vp9Option]);
  });

  tearDown(() => platform.uninstall());

  Future<RtcLocalCameraTrack> publishCamera() async {
    final result = await fixture.manager.publishVideoTrack(
      track: fakeCameraTrack('cam'),
    );
    return result.getDataOrNull()! as RtcLocalCameraTrack;
  }

  RtcLocalCameraTrack stored(String trackId) {
    return fixture.manager.tracks[trackId]! as RtcLocalCameraTrack;
  }

  /// Checks that [camera] was recreated: its source stopped, every sender
  /// moved to a clone of the new source, and the stored track holds it.
  void expectRecreated(RtcLocalCameraTrack camera) {
    final before = fakeMediaOf(camera);
    expect(before.stopped, isTrue);
    expect(before.clones, hasLength(2));
    expect(before.clones.every((it) => it.stopped), isTrue);
    expect(platform.callsOf('getUserMedia'), hasLength(1));

    final after = stored(camera.trackId);
    expect(after.mediaTrack.id, isNot(camera.mediaTrack.id));
    expect(fixture.transceivers, hasLength(2));
    for (final transceiver in fixture.transceivers) {
      expect(
        transceiver.sender.track!.id,
        startsWith('${after.mediaTrack.id}-clone-'),
      );
    }
    expect(after.clonedTracks, hasLength(2));
  }

  /// Registers a video track that is not a camera track.
  void registerNonCameraVideoTrack() {
    final track = fakeLocalTrack(
      'not-a-camera',
      trackType: SfuTrackType.video,
      constraints: const ScreenShareConstraints(),
      kind: 'video',
    );
    fixture.manager.tracks[track.trackId] = track;
  }

  group('setTrackFacingMode', () {
    test('recreates the camera facing the other way', () async {
      final camera = await publishCamera();

      final result = await fixture.manager.setTrackFacingMode(
        facingMode: FacingMode.environment,
      );

      expect(result.isSuccess, isTrue);
      expectRecreated(camera);
      expect(
        stored(camera.trackId).mediaConstraints.facingMode,
        FacingMode.environment,
      );
    });

    test('fails without a camera track', () async {
      final missing = await fixture.manager.setTrackFacingMode(
        facingMode: FacingMode.environment,
      );
      expect(missing.isFailure, isTrue);

      registerNonCameraVideoTrack();
      final notCamera = await fixture.manager.setTrackFacingMode(
        facingMode: FacingMode.environment,
      );
      expect(notCamera.isFailure, isTrue);
      expect(platform.callsOf('getUserMedia'), isEmpty);
    });
  });

  group('setCameraVideoParameters', () {
    test('recreates the camera with the new dimension', () async {
      final camera = await publishCamera();

      final result = await fixture.manager.setCameraVideoParameters(
        params: RtcVideoParametersPresets.h360_16x9,
      );

      expect(result.isSuccess, isTrue);
      expectRecreated(camera);
      expect(
        stored(camera.trackId).mediaConstraints.params.dimension,
        RtcVideoParametersPresets.h360_16x9.dimension,
      );
    });

    test('fails without a camera track', () async {
      final missing = await fixture.manager.setCameraVideoParameters(
        params: RtcVideoParametersPresets.h360_16x9,
      );
      expect(missing.isFailure, isTrue);

      registerNonCameraVideoTrack();
      final notCamera = await fixture.manager.setCameraVideoParameters(
        params: RtcVideoParametersPresets.h360_16x9,
      );
      expect(notCamera.isFailure, isTrue);
      expect(platform.callsOf('getUserMedia'), isEmpty);
    });
  });

  group('setVideoInputDevice', () {
    test('recreates the camera on the selected device', () async {
      final camera = await publishCamera();

      final result = await fixture.manager.setVideoInputDevice(
        device: _otherCamera,
      );

      expect(result.isSuccess, isTrue);
      expectRecreated(camera);
      expect(stored(camera.trackId).mediaConstraints.deviceId, 'usb-camera');
    });

    test('takes the facing mode from the device label', () async {
      await publishCamera();
      final back = RtcMediaDevice(
        id: _backCamera['deviceId']!,
        label: _backCamera['label']!,
        kind: RtcMediaDeviceKind.videoInput,
      );

      final result = await fixture.manager.setVideoInputDevice(device: back);

      expect(
        result.getDataOrNull()!.mediaConstraints.facingMode,
        FacingMode.environment,
      );
    });

    test('prefers the facing mode the capture reports', () async {
      final camera = await publishCamera();
      platform.trackSettings = const {'facingMode': 'user'};
      final back = RtcMediaDevice(
        id: _backCamera['deviceId']!,
        label: _backCamera['label']!,
        kind: RtcMediaDeviceKind.videoInput,
      );

      await fixture.manager.setVideoInputDevice(device: back);

      expect(
        stored(camera.trackId).mediaConstraints.facingMode,
        FacingMode.user,
      );
    });

    test(
      'a camera unpublished during the switch is not brought back and its '
      'new capture is stopped',
      () async {
        final camera = await publishCamera();
        platform.getUserMediaGate = Completer<void>();

        final switching = fixture.manager.setVideoInputDevice(
          device: _otherCamera,
        );
        await pumpEventQueue();
        await fixture.manager.unpublishTrack(trackId: camera.trackId);
        platform.getUserMediaGate!.complete();

        expect((await switching).isFailure, isTrue);
        expect(fixture.manager.tracks, isEmpty);
        expect(platform.disposedTrackIds, isNotEmpty);
      },
    );

    test(
      'a camera published again during the switch keeps the new one',
      () async {
        final camera = await publishCamera();
        platform.getUserMediaGate = Completer<void>();

        final switching = fixture.manager.setVideoInputDevice(
          device: _otherCamera,
        );
        await pumpEventQueue();
        await fixture.manager.unpublishTrack(trackId: camera.trackId);
        final republished = await publishCamera();
        platform.getUserMediaGate!.complete();

        expect((await switching).isFailure, isTrue);
        expect(
          stored(camera.trackId).mediaTrack,
          same(republished.mediaTrack),
        );
      },
    );

    test('keeps the camera when the device is already selected', () async {
      await publishCamera();
      await fixture.manager.setVideoInputDevice(device: _otherCamera);

      final again = await fixture.manager.setVideoInputDevice(
        device: _otherCamera,
      );

      expect(again.isSuccess, isTrue);
      expect(platform.callsOf('getUserMedia'), hasLength(1));
    });

    test('fails without a camera track', () async {
      final missing = await fixture.manager.setVideoInputDevice(
        device: _otherCamera,
      );
      expect(missing.isFailure, isTrue);

      registerNonCameraVideoTrack();
      final notCamera = await fixture.manager.setVideoInputDevice(
        device: _otherCamera,
      );
      expect(notCamera.isFailure, isTrue);
      expect(platform.callsOf('getUserMedia'), isEmpty);
    });
  });

  group('flipCamera', () {
    test(
      'switches the camera in place and stores the new facing mode and device',
      () async {
        final camera = await publishCamera();
        platform.switchesToFrontCamera = false;

        final result = await fixture.manager.flipCamera();

        expect(result.isSuccess, isTrue);
        expect(platform.callsOf('mediaStreamTrackSwitchCamera'), hasLength(1));
        // Flipped on the same source: nothing is recreated.
        expect(platform.callsOf('getUserMedia'), isEmpty);
        expect(fakeMediaOf(camera).stopped, isFalse);
        expect(camera.mediaTrack.enabled, isTrue);

        final after = stored(camera.trackId);
        expect(after.mediaTrack, same(camera.mediaTrack));
        expect(after.mediaConstraints.facingMode, FacingMode.environment);
        expect(after.mediaConstraints.deviceId, 'back-camera');
      },
    );

    test('fails without a camera track', () async {
      final missing = await fixture.manager.flipCamera();
      expect(missing.isFailure, isTrue);

      registerNonCameraVideoTrack();
      final notCamera = await fixture.manager.flipCamera();
      expect(notCamera.isFailure, isTrue);
      expect(platform.callsOf('mediaStreamTrackSwitchCamera'), isEmpty);
    });
  });
}
