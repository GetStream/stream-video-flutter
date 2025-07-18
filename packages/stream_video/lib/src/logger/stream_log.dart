import 'stream_logger.dart';

StreamLog get streamLog => StreamLog();

class StreamLog {
  factory StreamLog() {
    return _instance;
  }

  StreamLog._();

  static final StreamLog _instance = StreamLog._();

  StreamLogger _logger = const SilentStreamLogger();
  IsLoggableValidator _validator = (Priority priority, Tag tag) => false;
  Finder _finder = _defaultFinder;
  Priority _priority = Priority.none;

  static StreamLog get instance => _instance;
  static List<String> excludeTags = <String>[];
  static List<String> includeOnlyTags = <String>[];

  set logger(StreamLogger logger) {
    _logger = logger;
  }

  set priority(Priority priority) {
    _priority = priority;
    _validator = (logPriority, tag) {
      if (excludeTags.isNotEmpty && excludeTags.contains(tag)) {
        return false;
      }

      if (includeOnlyTags.isNotEmpty && !includeOnlyTags.contains(tag)) {
        return false;
      }

      return logPriority.index >= priority.index;
    };
  }

  set validator(IsLoggableValidator validator) {
    _validator = validator;
  }

  set finder(Finder finder) {
    _finder = finder;
  }

  T? find<T extends StreamLogger>([dynamic criteria]) {
    return _finder.call(criteria);
  }

  void v(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.verbose, tag, message);
    }
  }

  void d(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.debug, tag)) {
      _logger.log(Priority.debug, tag, message);
    }
  }

  void i(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.info, tag)) {
      _logger.log(Priority.info, tag, message);
    }
  }

  void w(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.warning, tag)) {
      _logger.log(Priority.warning, tag, message);
    }
  }

  void e(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.error, tag)) {
      _logger.log(Priority.error, tag, message);
    }
  }

  void log(Priority priority, Tag tag, MessageBuilder message) {
    if (_validator.call(priority, tag)) {
      _logger.log(priority, tag, message);
    }
  }

  void logConditional(
    Tag tag,
    String? Function(Priority priority) messageBuilder,
  ) {
    final message = messageBuilder(_priority);
    if (message != null && message.isNotEmpty) {
      _logger.log(
        _priority,
        tag,
        () => message,
      );
    }
  }

  static T? _defaultFinder<T extends StreamLogger>([dynamic criteria]) {
    final logger = _instance._logger;
    if (logger is T) return logger;

    if (logger is CompositeStreamLogger) {
      for (final child in logger.children) {
        if (child is T) return child;
      }
    }
    return null;
  }
}

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
