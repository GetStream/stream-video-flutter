import '../stream_log.dart';
import '../stream_logger.dart';

TaggedLogger taggedLogger({required Tag tag}) {
  return TaggedLogger(tag);
}

class TaggedLogger {
  const TaggedLogger(this.tag);

  final Tag tag;

  void v(MessageBuilder message) {
    streamLog.v(tag, message);
  }

  void d(MessageBuilder message) {
    streamLog.d(tag, message);
  }

  void i(MessageBuilder message) {
    streamLog.i(tag, message);
  }

  void w(MessageBuilder message) {
    streamLog.w(tag, message);
  }

  void e(MessageBuilder message) {
    streamLog.e(tag, message);
  }

  void log(Priority priority, MessageBuilder message) {
    streamLog.log(priority, tag, message);
  }
}
