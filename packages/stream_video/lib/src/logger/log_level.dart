import 'stream_logger.dart' as log;

class LogLevel implements Comparable<LogLevel> {
  const LogLevel.atLeast(this.priority);

  static const LogLevel off = LogLevel.atLeast(log.Priority.none);
  static const LogLevel error = LogLevel.atLeast(log.Priority.error);
  static const LogLevel warning = LogLevel.atLeast(log.Priority.warning);
  static const LogLevel info = LogLevel.atLeast(log.Priority.info);
  static const LogLevel debug = LogLevel.atLeast(log.Priority.debug);
  static const LogLevel all = LogLevel.atLeast(log.Priority.verbose);

  final log.Priority priority;

  @override
  String toString() {
    return 'LogLevel{priority: $priority}';
  }

  @override
  int compareTo(LogLevel other) => priority.compareTo(other.priority);

  @override
  int get hashCode => priority.hashCode;

  @override
  bool operator ==(Object other) =>
      other is LogLevel && priority == other.priority;

  bool operator <(LogLevel other) => priority < other.priority;

  bool operator <=(LogLevel other) => priority <= other.priority;

  bool operator >(LogLevel other) => priority > other.priority;

  bool operator >=(LogLevel other) => priority >= other.priority;
}
