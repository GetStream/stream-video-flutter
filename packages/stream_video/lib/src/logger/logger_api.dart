/// The logging API of the Stream Video SDK.
///
/// Vendored from stream_core, which replaced this API with the
/// StreamLogger/StreamLogHandler pair. The Video SDK keeps exposing these
/// types (`Priority`, `MessageBuilder`, `StreamLogger`) as its public
/// logging surface.
library;

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
  const StreamLogger();

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
typedef Finder = T? Function<T extends StreamLogger>([dynamic criteria]);

enum Priority implements Comparable<Priority> {
  verbose(level: 2),
  debug(level: 3),
  info(level: 4),
  warning(level: 5),
  error(level: 6),
  none(level: 7);

  const Priority({required this.level});

  final int level;

  @override
  String toString() => name;

  @override
  int compareTo(Priority other) => level.compareTo(other.level);

  bool operator <(Priority other) => level < other.level;

  bool operator <=(Priority other) => level <= other.level;

  bool operator >(Priority other) => level > other.level;

  bool operator >=(Priority other) => level >= other.level;
}
