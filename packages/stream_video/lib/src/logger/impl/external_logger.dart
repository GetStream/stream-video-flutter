import '../stream_logger.dart';

typedef ExternalFunction = void Function(
  Priority priority,
  String tag,
  MessageBuilder message, [
  Object? error,
  StackTrace? stk,
]);

class ExternalStreamLogger extends StreamLogger {
  const ExternalStreamLogger(this.external);

  final ExternalFunction external;

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    return external.call(priority, tag, message, error, stk);
  }
}
