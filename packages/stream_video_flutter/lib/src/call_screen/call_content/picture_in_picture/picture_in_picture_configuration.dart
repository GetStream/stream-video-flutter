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
    this.androidPiPConfiguration = const AndroidPictureInPictureConfiguration(),
    this.iOSPiPConfiguration = const IOSPictureInPictureConfiguration(),
  });

  /// Whether to enable picture-in-picture mode.
  final bool enablePictureInPicture;

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

class IOSPictureInPictureConfiguration {
  const IOSPictureInPictureConfiguration({
    this.ignoreLocalParticipantVideo = true,
  });

  final bool ignoreLocalParticipantVideo;
}
