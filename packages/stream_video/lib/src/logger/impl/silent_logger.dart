import '../stream_logger.dart';

class SilentStreamLogger extends StreamLogger {
  const SilentStreamLogger();

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    /* no-op */
  }
}
