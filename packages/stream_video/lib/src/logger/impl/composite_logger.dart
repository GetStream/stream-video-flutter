import '../stream_logger.dart';

class CompositeStreamLogger extends StreamLogger {
  const CompositeStreamLogger(this.children);

  final List<StreamLogger> children;

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    for (final child in children) {
      child.log(priority, tag, message, error, stk);
    }
  }
}
