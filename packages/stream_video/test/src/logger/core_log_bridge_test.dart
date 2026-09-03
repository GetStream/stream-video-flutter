import 'package:flutter_test/flutter_test.dart';
import 'package:stream_core/stream_core.dart' as core;
import 'package:stream_video/src/logger/core_log_bridge.dart';
import 'package:stream_video/stream_video.dart';

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
  group('installCoreLogBridge', () {
    late _RecordingLogger logger;

    setUp(() {
      logger = _RecordingLogger();
      StreamLog().logger = logger;
      StreamLog().priority = Priority.verbose;
    });

    tearDown(() {
      core.StreamLogger.reset();
      StreamLog().logger = const SilentStreamLogger();
      StreamLog().priority = Priority.none;
    });

    test('forwards core records to the video logger', () {
      installCoreLogBridge(Priority.debug);

      const coreLogger = core.StreamLogger('SV:CoordinatorWS:Engine');
      coreLogger.i(() => 'socket open');

      expect(logger.records, ['info|SV:CoordinatorWS:Engine|socket open']);
    });

    test('admits records at the installed priority and above only', () {
      installCoreLogBridge(Priority.warning);

      const coreLogger = core.StreamLogger('SV:CoordinatorWS');
      coreLogger
        ..d(() => 'dropped')
        ..w(() => 'kept');

      expect(logger.records, ['warning|SV:CoordinatorWS|kept']);
    });

    test('appends the error to the message', () {
      // StreamLog takes no error arguments, so a record's error and stack trace
      // would be lost if they were not part of the message.
      installCoreLogBridge(Priority.error);

      const core.StreamLogger('SV:SfuWs-1').e(
        () => 'socket failed',
        error: 'boom',
      );

      expect(logger.records.single, contains('socket failed; error: boom'));
    });
  });
}
