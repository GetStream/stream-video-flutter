import 'package:stream_core/stream_core.dart';

/// Whether the camera track should be muted while the app is in the background.
///
/// iOS suspends camera capture in the background unless the device supports
/// multitasking camera access, which leaves the other participants looking at a
/// frozen frame. Muting the track shows them camera-off instead.
bool shouldMuteCameraInBackground({
  required bool isVideoEnabled,
  required bool muteVideoWhenInBackground,
  required bool multitaskingCameraAccessEnabled,
  required PlatformType platform,
}) {
  if (!isVideoEnabled) return false;
  if (muteVideoWhenInBackground) return true;

  return platform == PlatformType.ios && !multitaskingCameraAccessEnabled;
}
