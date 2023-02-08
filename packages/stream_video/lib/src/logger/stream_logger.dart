import 'impl/tagged_logger.dart';

final _priorityEmojiMapper = {
  Priority.error: '🚨',
  Priority.warning: '⚠️',
  Priority.info: 'ℹ️',
  Priority.debug: '🔧',
  Priority.verbose: '🔍',
};

final _priorityNameMapper = {
  Priority.error: 'E',
  Priority.warning: 'W',
  Priority.info: 'I',
  Priority.debug: 'D',
  Priority.verbose: 'V',
};

abstract class StreamLogger {
  String emoji(Priority priority) => _priorityEmojiMapper[priority] ?? '📣';

  String name(Priority priority) => _priorityNameMapper[priority] ?? '*';

  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]);
}

typedef MessageBuilder = String Function();
typedef Tag = String;
typedef IsLoggableValidator = bool Function(Priority, Tag);

enum Priority { verbose, debug, info, warning, error }
