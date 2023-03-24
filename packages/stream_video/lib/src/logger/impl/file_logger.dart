import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../utils/standard.dart';
import '../stream_logger.dart';

const int _defaultSize = 12 * 1024 * 1024;

const String _shareableFilePrefix = 'stream_log_';
const String _internalFile0 = 'internal_0.txt';
const String _internalFile1 = 'internal_1.txt';

final _timeFormat = DateFormat("yyyy-MM-dd HH:mm:ss''SSS");
final _dateFormat = DateFormat('yyMMddHHmm_ss');

class FileStreamLogger extends StreamLogger {
  FileStreamLogger(this.config);

  static final Finalizer<IOSink> _finalizer =
      Finalizer((ioSink) async => ioSink.close());

  final FileLogConfig config;

  String get filesDir => config.filesDir.path;

  String get pathSeparator => Platform.pathSeparator;

  late final file0 = File('$filesDir$pathSeparator$_internalFile0');
  late final file1 = File('$filesDir$pathSeparator$_internalFile1');
  late final files = [file0, file1];

  File? currentFile;
  IOSink? currentIO;

  @override
  Future<void> log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) async {
    _initIfNeeded();
    await _swapFiles();
    await currentIO?.log(priority, tag, message, error, stk);
  }

  void _initIfNeeded() {
    if (currentFile == null) {
      final File file;
      if (!file0.existsSync() || !file1.existsSync()) {
        file = file0;
      } else if (file0.lastModifiedSync().isAfter(file1.lastModifiedSync())) {
        file = file0;
      } else {
        file = file1;
      }
      currentFile = file;
      currentIO = file.openWrite(mode: FileMode.append).also((it) {
        _finalizer.attach(this, it, detach: this);
      });
    }
  }

  Future<void> _swapFiles() async {
    final curLen = await currentFile?.length() ?? 0;
    if (curLen >= config.maxLogSize / 2) {
      if (currentFile == file0) {
        currentFile = file1;
      } else {
        currentFile = file0;
      }
      await currentFile?.writeAsString('');
      await currentIO?.close();
      currentIO = currentFile?.openWrite(mode: FileMode.append);
    }
  }

  Future<void> clear() async {
    await file0.writeAsString('');
    await file1.writeAsString('');
  }

  Future<File> share() async {
    final filename = '$_shareableFilePrefix'
        '${_dateFormat.format(DateTime.now())}.txt';
    final out = File('${config.tempsDir}$pathSeparator$filename');

    IOSink? writer;
    try {
      writer = out.openWrite();
      files.sortBy((file) => file.lastModifiedSync());
      for (final file in files) {
        await writer.addStream(file.openRead());
      }
      await writer.flush();
    } finally {
      await writer?.close();
    }
    return out;
  }
}

class FileLogConfig {
  FileLogConfig({
    this.maxLogSize = _defaultSize,
    required this.filesDir,
    required this.tempsDir,
    required this.appVersion,
  });

  final int maxLogSize;
  final Directory filesDir;
  final Directory tempsDir;
  final String appVersion;
}

extension on IOSink {
  Future<void> log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) async {
    final formattedDateTime = _timeFormat.format(DateTime.now());
    final formattedPriority = priority.stringify();
    final formatterPrefix = '$formattedDateTime $formattedPriority [$tag]: ';

    write(formatterPrefix);
    writeln(message());
  }
}

extension on Priority {
  String stringify() {
    switch (this) {
      case Priority.verbose:
        return 'V';
      case Priority.debug:
        return 'D';
      case Priority.info:
        return 'I';
      case Priority.warning:
        return 'W';
      case Priority.error:
        return 'E';
      case Priority.none:
        return 'X';
    }
  }
}
