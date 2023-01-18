import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:webrtc_interface/webrtc_interface.dart' as rtc_interface;

import 'screen_share_constraints.dart';

export 'audio_constraints.dart';
export 'camera_constraints.dart';
export 'screen_share_constraints.dart';
export 'video_constraints.dart';

abstract class MediaConstraints {
  const MediaConstraints({this.deviceId});

  /// The deviceId of the capture device to use.
  /// Available deviceIds can be obtained through `flutter_webrtc`:
  /// <pre>
  /// import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
  ///
  /// List<MediaDeviceInfo> devices = await rtc.navigator.mediaDevices.enumerateDevices();
  /// </pre>
  final String? deviceId;

  // All subclasses must be able to report constraints
  Map<String, dynamic> toMap();

  MediaConstraints copyWith();
}

extension MediaDevices on rtc_interface.MediaDevices {
  Future<rtc.MediaStream> getMedia(MediaConstraints constraints) {
    final constraintsMap = constraints.toMap();
    if (constraints is ScreenShareConstraints) {
      return rtc.navigator.mediaDevices.getDisplayMedia(
        constraintsMap,
      );
    } else {
      return rtc.navigator.mediaDevices.getUserMedia(
        constraintsMap,
      );
    }
  }
}
