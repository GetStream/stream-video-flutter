import 'package:flutter/foundation.dart';
import 'package:stream_core/stream_core.dart';

class ConsoleStreamLogger extends StreamLogger {
  const ConsoleStreamLogger();

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    final emoji = super.emoji(priority);
    final name = super.name(priority);
    debugPrint('${DateTime.now()} $emoji ($name/$tag): ${message()}');
  }
}
