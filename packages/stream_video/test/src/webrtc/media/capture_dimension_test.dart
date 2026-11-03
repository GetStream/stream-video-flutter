import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/webrtc/media/capture_dimension.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/rtc_manager_fakes.dart';

const _landscape = {'width': 1280, 'height': 720};
const _portraitScreen = RtcVideoDimension(width: 1080, height: 2340);

/// A resolver that sees a screen of [screen].
CaptureDimensionResolver _resolver([RtcVideoDimension? screen]) {
  return CaptureDimensionResolver(screenDimension: () => screen);
}

RtcLocalCameraTrack _camera({Map<String, dynamic> settings = _landscape}) {
  final camera = fakeCameraTrack('cam');
  fakeMediaOf(camera).settings = settings;
  return camera;
}

void main() {
  tearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

  group('CaptureDimensionResolver', () {
    test('a screen share takes the size of the screen', () {
      final share = fakeScreenShareTrack('share');
      fakeMediaOf(share).settings = _landscape;

      expect(
        _resolver(_portraitScreen).resolve(share),
        _portraitScreen,
      );
    });

    test('a screen share keeps its capture size without a screen size', () {
      final share = fakeScreenShareTrack('share');
      fakeMediaOf(share).settings = _landscape;

      expect(
        _resolver().resolve(share),
        const RtcVideoDimension(width: 1280, height: 720),
      );
    });

    test(
      'a mobile camera without a frame-oriented size is announced in the '
      'orientation of the screen',
      () {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

        expect(
          _resolver(_portraitScreen).resolve(_camera()),
          const RtcVideoDimension(width: 720, height: 1280),
        );
      },
    );

    test(
      'a camera size marked with sensorOrientation is already oriented',
      () {
        CurrentPlatform.debugCurrentPlatformOverride = PlatformType.android;

        expect(
          _resolver(_portraitScreen).resolve(
            _camera(settings: {..._landscape, 'sensorOrientation': 90}),
          ),
          const RtcVideoDimension(width: 1280, height: 720),
        );
      },
    );

    test('a mobile camera keeps its capture size without a screen size', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.ios;

      expect(
        _resolver().resolve(_camera()),
        const RtcVideoDimension(width: 1280, height: 720),
      );
    });

    test('a desktop camera keeps its capture size', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.macOS;

      expect(
        _resolver(_portraitScreen).resolve(_camera()),
        const RtcVideoDimension(width: 1280, height: 720),
      );
    });

    test(
      'a clone without settings falls back to the size already resolved',
      () {
        final clone = _camera(settings: const {}).copyWith(
          videoDimension: const RtcVideoDimension(width: 1920, height: 1440),
        );

        expect(
          _resolver().resolve(clone),
          const RtcVideoDimension(width: 1920, height: 1440),
        );
      },
    );

    test('a failing getSettings falls back to the requested size', () {
      final camera = _camera();
      fakeMediaOf(camera).settingsError = Exception('getSettings');

      expect(
        _resolver().resolve(camera),
        const CameraConstraints().params.dimension,
      );
    });

    test('takes width and height separately from the settings', () {
      final camera = _camera(settings: const {'width': 640, 'height': 0});

      expect(
        _resolver().resolve(camera),
        RtcVideoDimension(
          width: 640,
          height: const CameraConstraints().params.dimension.height,
        ),
      );
    });
  });
}
