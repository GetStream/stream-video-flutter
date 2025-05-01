import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:webrtc_interface/webrtc_interface.dart' as rtc_interface;

import '../../call/stats/tracer.dart';
import '../../logger/stream_log.dart';
import 'screen_share_constraints.dart';

export 'audio_constraints.dart';
export 'camera_constraints.dart';
export 'constraints/camera_position.dart';
export 'constraints/facing_mode.dart';
export 'constraints/mirror_mode.dart';
export 'screen_share_constraints.dart';
export 'video_constraints.dart';

abstract class MediaConstraints {
  const MediaConstraints({this.deviceId});

  /// The deviceId of the capture device to use.
  /// Available deviceIds can be obtained through `flutter_webrtc`:
  /// <pre>
  /// import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
  ///
  /// List<MediaDeviceInfo> devices = await rtc.navigator.mediaDevices.enumerateDevices();
  /// </pre>
  final String? deviceId;

  // All subclasses must be able to report constraints
  // https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
  Map<String, dynamic> toMap();

  MediaConstraints copyWith();
}

final mediaDevicesTracer = Tracer(null)..setEnabled(false);

extension MediaDevices on rtc_interface.MediaDevices {
  Future<rtc.MediaStream> getMedia(MediaConstraints constraints) async {
    final constraintsMap = constraints.toMap();
    streamLog.i(
      'SV:MediaDevices',
      () =>
          '[getMedia] #${constraints.runtimeType}; constraintsMap: $constraintsMap',
    );

    late rtc.MediaStream stream;
    late String tag;
    int currentMark = 0;

    try {
      if (constraints is ScreenShareConstraints) {
        tag = 'navigator.mediaDevices.getDisplayMedia';
        mediaDevicesTracer.trace('$tag.$currentMark', constraintsMap);

        stream = await rtc.navigator.mediaDevices.getDisplayMedia(
          constraintsMap,
        );
      } else {
        tag = 'navigator.mediaDevices.getUserMedia';
        mediaDevicesTracer.trace('$tag.$currentMark', constraintsMap);

        stream = await rtc.navigator.mediaDevices.getUserMedia(
          constraintsMap,
        );
      }
    } catch (e) {
      mediaDevicesTracer.trace('${tag}OnFailure.$currentMark', e.toString());
      rethrow;
    }

    final straemDump = {
      'id': stream.id,
      'tracks': stream.getTracks().map((track) {
        return {
          'id': track.id,
          'kind': track.kind,
          'label': track.label,
          'enabled': track.enabled,
          'muted': track.muted,
          // 'readyState': track.readyState,
        };
      }).toList(),
    };

    mediaDevicesTracer.trace('${tag}OnSuccess.$currentMark', straemDump);
    return stream;
  }
}
