import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

/// Sends a log record to [webRtcLogHandler] under [tag].
class WebRtcLogger {
  const WebRtcLogger(this.tag);

  final String tag;

  void verbose(String message) => _log(WebRtcLogLevel.verbose, message);

  void info(String message) => _log(WebRtcLogLevel.info, message);

  void warning(String message) => _log(WebRtcLogLevel.warning, message);

  void _log(WebRtcLogLevel level, String message) {
    webRtcLogHandler?.call(level, tag, message);
  }
}
