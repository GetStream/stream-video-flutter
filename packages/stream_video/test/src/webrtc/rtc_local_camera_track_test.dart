import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/rtc_manager_fakes.dart';

const _usbCamera = RtcMediaDevice(
  id: 'usb-camera',
  label: 'USB Camera',
  kind: RtcMediaDeviceKind.videoInput,
);

void main() {
  group('withFacingModeOf', () {
    test('reads the facing mode from the captured track', () {
      final camera = fakeCameraTrack('cam');
      final captured = fakeMediaOf(camera)
        ..settings = const {'facingMode': 'user'};
      // A filter output, such as a canvas stream, reports no facing mode.
      final filtered = FakeMediaStreamTrack('filtered', kind: 'video');
      final track = camera.withMedia(
        stream: FakeMediaStream([filtered]),
        track: filtered,
        capturedStream: FakeMediaStream([captured]),
      );

      final updated = track.withFacingModeOf(
        _usbCamera,
        fallback: FacingMode.environment,
      );

      expect(updated.mediaConstraints.facingMode, FacingMode.user);
    });
  });
}
