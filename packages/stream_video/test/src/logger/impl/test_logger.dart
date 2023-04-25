import 'package:stream_video/src/logger/stream_logger.dart';

class TestStreamLogger extends StreamLogger {
  int startTimeMs = DateTime.now().millisecondsSinceEpoch;

  int get nowMs => DateTime.now().millisecondsSinceEpoch;

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    final elapsed = Duration(milliseconds: nowMs - startTimeMs);
    final emoji = super.emoji(priority);
    final name = super.name(priority);
    print('$elapsed $emoji ($name/$tag): ${message()}');
  }
}
