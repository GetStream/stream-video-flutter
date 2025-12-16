import 'package:flutter/material.dart';

import '../../../../stream_video_flutter.dart';

typedef CallPictureInPictureBuilder =
    Widget Function(
      BuildContext context,
      Call call,
      CallState callState,
    );

enum PipTrackPriority { screenShare, camera }

/// Configuration for picture-in-picture mode.
class PictureInPictureConfiguration {
  const PictureInPictureConfiguration({
    this.enablePictureInPicture = false,
    this.disablePictureInPictureWhenScreenSharing = true,
    this.pipTrackPriority = PipTrackPriority.screenShare,
    this.sort,
    this.androidPiPConfiguration = const AndroidPictureInPictureConfiguration(),
    this.iOSPiPConfiguration = const IOSPictureInPictureConfiguration(),
  });

  /// Whether to enable picture-in-picture mode.
  final bool enablePictureInPicture;

  /// Whether to disable picture-in-picture mode during screen sharing on the device.
  final bool disablePictureInPictureWhenScreenSharing;

  /// Determines which video track to prioritise in the PiP view.
  ///
  /// If [PipTrackPriority.screenShare], the screen sharing track will be
  /// displayed in the PiP view if available for the first participant
  /// determined by the sorting function.
  ///
  /// If [PipTrackPriority.camera], the camera track will be preferred.
  /// However, if the camera track is disabled and screen sharing is available,
  /// the screen share will be shown as a fallback.
  final PipTrackPriority pipTrackPriority;

  /// Sorting function for participants in picture-in-picture mode.
  /// The first participant will be displayed in the PiP view.
  /// If not provided, the default sorting prioritising speaker / screen sharer will be used.
  final Comparator<CallParticipantState>? sort;

  /// Configuration for picture-in-picture mode on Android.
  final AndroidPictureInPictureConfiguration androidPiPConfiguration;

  /// Configuration for picture-in-picture mode on iOS.
  final IOSPictureInPictureConfiguration iOSPiPConfiguration;
}

class AndroidPictureInPictureConfiguration {
  const AndroidPictureInPictureConfiguration({
    this.callPictureInPictureWidgetBuilder,
  });

  /// Builder used to create a custom picture in picture mode. (available only on Android)
  final CallWidgetBuilder? callPictureInPictureWidgetBuilder;
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
    this.showParticipantName = true,
    this.showMicrophoneIndicator = true,
    this.showConnectionQualityIndicator = true,
  });

  final bool includeLocalParticipantVideo;
  final bool showParticipantName;
  final bool showMicrophoneIndicator;
  final bool showConnectionQualityIndicator;
}
