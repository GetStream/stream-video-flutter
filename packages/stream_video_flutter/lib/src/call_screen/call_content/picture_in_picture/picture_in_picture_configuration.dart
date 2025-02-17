import 'package:flutter/material.dart';
import 'package:stream_video/stream_video.dart';

typedef CallPictureInPictureBuilder = Widget Function(
  BuildContext context,
  Call call,
  CallState callState,
);

/// Configuration for picture-in-picture mode.
class PictureInPictureConfiguration {
  const PictureInPictureConfiguration({
    this.enablePictureInPicture = false,
    this.disablePictureInPictureWhenScreenSharing = true,
    this.androidPiPConfiguration = const AndroidPictureInPictureConfiguration(),
    this.iOSPiPConfiguration = const IOSPictureInPictureConfiguration(),
  });

  /// Whether to enable picture-in-picture mode.
  final bool enablePictureInPicture;

  /// Whether to disable picture-in-picture mode during screen sharing on the device.
  final bool disablePictureInPictureWhenScreenSharing;

  /// Configuration for picture-in-picture mode on Android.
  final AndroidPictureInPictureConfiguration androidPiPConfiguration;

  /// Configuration for picture-in-picture mode on iOS.
  final IOSPictureInPictureConfiguration iOSPiPConfiguration;
}

class AndroidPictureInPictureConfiguration {
  const AndroidPictureInPictureConfiguration({
    this.callPictureInPictureBuilder,
  });

  /// Builder used to create a custom picture in picture mode. (available only on Android)
  final CallPictureInPictureBuilder? callPictureInPictureBuilder;
}

/// Configuration options for enabling Picture-in-Picture (PiP) mode on iOS.
///
/// On iOS, **multitasking camera access** must be enabled to allow the user's
/// camera to remain active while the app is in the background.
///
/// If multitasking camera access is enabled, setting `includeLocalParticipantVideo`
/// to `true` allows the local camera feed to be used in PiP mode (`true` by default).
///
/// For more details, visit:
/// https://getstream.io/video/docs/flutter/advanced/picture_in_picture/
class IOSPictureInPictureConfiguration {
  const IOSPictureInPictureConfiguration({
    this.includeLocalParticipantVideo = true,
  });

  final bool includeLocalParticipantVideo;
}
