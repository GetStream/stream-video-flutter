import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/logger/webrtc_log_bridge.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

class _RecordingLogger extends StreamLogger {
  final records = <String>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    records.add('$priority|$tag|${message()}');
  }
}

void main() {
  group('installWebRtcLogBridge', () {
    late _RecordingLogger logger;

    setUp(() {
      logger = _RecordingLogger();
      StreamLog().logger = logger;
      StreamLog().priority = Priority.info;
    });

    tearDown(() {
      webRtcLogHandler = null;
      StreamLog().logger = const SilentStreamLogger();
      StreamLog().priority = Priority.none;
    });

    test('forwards WebRTC records at the logger priority', () {
      installWebRtcLogBridge();

      webRtcLogHandler!(WebRtcLogLevel.warning, 'Watchdog', 'stalled');
      webRtcLogHandler!(WebRtcLogLevel.info, 'Watchdog', 'unblocked');
      webRtcLogHandler!(WebRtcLogLevel.verbose, 'Watchdog', 'skipped');

      expect(logger.records, [
        '${Priority.warning}|SV:WebRTC:Watchdog|stalled',
        '${Priority.info}|SV:WebRTC:Watchdog|unblocked',
      ]);
    });
  });
}
