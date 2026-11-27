import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import 'logger_api.dart';
import 'stream_log.dart';

/// Forwards the log records of the WebRTC packages, such as the playback
/// warnings of a browser's remote audio, into the video logger.
void installWebRtcLogBridge() {
  webRtcLogHandler = (level, tag, message) => StreamLog().log(
    switch (level) {
      WebRtcLogLevel.verbose => Priority.verbose,
      WebRtcLogLevel.info => Priority.info,
      WebRtcLogLevel.warning => Priority.warning,
    },
    'SV:WebRTC:$tag',
    () => message,
  );
}
