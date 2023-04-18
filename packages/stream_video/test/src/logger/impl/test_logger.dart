import 'package:stream_video/src/logger/stream_logger.dart';

class TestStreamLogger extends StreamLogger {
  const TestStreamLogger();

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    final emoji = super.emoji(priority);
    final name = super.name(priority);
    print('${DateTime.now()} $emoji ($name/$tag): ${message()}');
  }
}
