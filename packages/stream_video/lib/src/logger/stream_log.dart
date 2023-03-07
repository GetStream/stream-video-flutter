import 'impl/silent_logger.dart';
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

  static StreamLog get instance => _instance;

  set logger(StreamLogger logger) {
    _logger = logger;
  }

  set validator(IsLoggableValidator validator) {
    _validator = validator;
  }

  void v(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.verbose, tag, message);
    }
  }

  void d(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.debug, tag, message);
    }
  }

  void i(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.info, tag, message);
    }
  }

  void w(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.warning, tag, message);
    }
  }

  void e(Tag tag, MessageBuilder message) {
    if (_validator.call(Priority.verbose, tag)) {
      _logger.log(Priority.error, tag, message);
    }
  }
}
