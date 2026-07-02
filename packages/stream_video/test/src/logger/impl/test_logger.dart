import 'package:flutter/material.dart';
import 'package:stream_core/stream_core.dart';

class TestStreamLogger extends StreamLogger {
  int startTimeMs = DateTime.now().millisecondsSinceEpoch;

  int get nowMs => DateTime.now().millisecondsSinceEpoch;

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    final elapsed = Duration(milliseconds: nowMs - startTimeMs);
    final emoji = super.emoji(priority);
    final name = super.name(priority);

    debugPrint('$elapsed $emoji ($name/$tag): ${message()}');
  }
}
