import '../stream_logger.dart';

class ConsoleStreamLogger extends StreamLogger {
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
