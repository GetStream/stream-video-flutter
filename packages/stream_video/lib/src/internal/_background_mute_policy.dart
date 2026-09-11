import 'package:stream_core/stream_core.dart';

/// Whether the camera track should be muted while the app is in the background.
///
/// iOS suspends camera capture in the background unless the capture session
/// supports multitasking camera access, which leaves the other participants
/// looking at a frozen frame. Muting the track shows them camera-off instead.
///
/// [multitaskingCameraAccessSupported] is `null` when it could not be read, in
/// which case the track is muted rather than risking the frozen frame.
bool shouldMuteCameraInBackground({
  required bool isVideoEnabled,
  required bool muteVideoWhenInBackground,
  required bool? multitaskingCameraAccessSupported,
  required PlatformType platform,
}) {
  if (!isVideoEnabled) return false;
  if (muteVideoWhenInBackground) return true;
  if (platform != PlatformType.ios) return false;

  return multitaskingCameraAccessSupported != true;
}
