import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

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

/// Keeps the warning and error messages logged through [StreamLog].
class RecordingStreamLogger extends StreamLogger {
  final warnings = <String>[];
  final errors = <String>[];

  @override
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
    switch (priority) {
      case Priority.warning:
        warnings.add(message());
      case Priority.error:
        errors.add(message());
      default:
    }
  }
}

/// Routes [StreamLog] to a [RecordingStreamLogger] for the current test.
RecordingStreamLogger installRecordingLogger() {
  final logger = RecordingStreamLogger();
  StreamLog()
    ..logger = logger
    ..priority = Priority.warning;
  addTearDown(() {
    StreamLog()
      ..logger = const SilentStreamLogger()
      ..priority = Priority.none;
  });
  return logger;
}
