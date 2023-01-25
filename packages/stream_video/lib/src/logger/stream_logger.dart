class StreamLog {}

abstract class StreamLogger {}

TaggedLogger taggedLogger({required String tag}) {
  return TaggedLogger(tag);
}

typedef MessageBuilder = String Function();

enum Priority { VERBOSE, DEBUG, INFO, WARNING, ERROR }

class TaggedLogger {
  const TaggedLogger(this.tag);
  final String tag;

  void v(MessageBuilder message) {
    print('🔍 (V/$tag): ${message()}');
  }

  void d(MessageBuilder message) {
    print('🔧 (D/$tag): ${message()}');
  }

  void i(MessageBuilder message) {
    print('ℹ️ (I/$tag): ${message()}');
  }

  void w(MessageBuilder message) {
    print('⚠️ (W/$tag): ${message()}');
  }

  void e(MessageBuilder message) {
    print('🚨 (E/$tag): ${message()}');
  }

  void _log(Priority priority, String Function() messageBuilder) {}
}
