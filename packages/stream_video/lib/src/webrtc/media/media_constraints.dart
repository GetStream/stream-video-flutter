import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:webrtc_interface/webrtc_interface.dart' as rtc_interface;

import '../../logger/stream_log.dart';
import 'screen_share_constraints.dart';

export 'audio_constraints.dart';
export 'camera_constraints.dart';
export 'constraints/camera_position.dart';
export 'constraints/facing_mode.dart';
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
  // https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
  Map<String, dynamic> toMap();

  MediaConstraints copyWith();
}

extension MediaDevices on rtc_interface.MediaDevices {
  Future<rtc.MediaStream> getMedia(MediaConstraints constraints) {
    final constraintsMap = constraints.toMap();
    streamLog.i(
        'SV:MediaDevices',
        () =>
            '[getMedia] #${constraints.runtimeType}; constraintsMap: $constraintsMap');
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
