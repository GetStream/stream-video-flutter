import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../utils/standard.dart';
import '../stream_logger.dart';

const String _tag = 'SV:FileLogger';
const int _defaultSize = 12 * 1024 * 1024;

const String _shareableFilePrefix = 'stream_log_';
const String _internalFile0 = 'internal_0.txt';
const String _internalFile1 = 'internal_1.txt';

typedef FileLogSender = Future<dynamic> Function(File);

final _timeFormat = DateFormat("yyyy-MM-dd HH:mm:ss''SSS");
final _dateFormat = DateFormat('yyMMddHHmm_ss');

class FileStreamLogger extends StreamLogger {
  FileStreamLogger(
    this.config, {
    this.sender,
    this.console,
  });

  static final Finalizer<IOSink> _finalizer =
      Finalizer((ioSink) async => ioSink.close());

  final FileLogConfig config;
  final FileLogSender? sender;
  final StreamLogger? console;

  String get pathSeparator => Platform.pathSeparator;

  late final Directory _filesDir;
  late final Directory _tempsDir;
  late final File _file0;
  late final File _file1;

  File? _currentFile;
  IOSink? _currentIO;

  @override
  Future<void> log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) async {
    await _initIfNeeded();
    await _swapFiles();
    try {
      _currentIO?.log(priority, tag, message, error, stk);
    } catch (e, stk) {
      _logE(() => '[log] failed: $e; $stk');
    }
  }

  Future<void> _initIfNeeded() async {
    try {
      if (_currentFile == null) {
        _logD(() => '[initIfNeeded] no args');
        _filesDir = await config.filesDir;
        _tempsDir = await config.tempsDir;
        _file0 = File('${_filesDir.path}$pathSeparator$_internalFile0')
          ..createSync(recursive: true);
        _file1 = File('${_filesDir.path}$pathSeparator$_internalFile1')
          ..createSync(recursive: true);
        final File currentFile;
        if (!_file0.existsSync() || !_file1.existsSync()) {
          currentFile = _file0;
        } else if (_file0
            .lastModifiedSync()
            .isAfter(_file1.lastModifiedSync())) {
          currentFile = _file0;
        } else {
          currentFile = _file1;
        }
        _currentFile = currentFile;
        _currentIO = currentFile.openWrite(mode: FileMode.append).also((it) {
          _finalizer.attach(this, it, detach: this);
        });
      }
    } catch (e, stk) {}
  }

  Future<void> _swapFiles() async {
    try {
      final curLen = _currentFile?.lengthSync() ?? 0;
      final maxLogSize = config.maxLogSize;
      if (curLen >= maxLogSize / 2) {
        _logD(() => '[swapFiles] no args');
        final currentIO = _currentIO;
        _currentIO = null;
        await currentIO?.close();
        File currentFile;
        if (_currentFile == _file0) {
          currentFile = _file1;
        } else {
          currentFile = _file0;
        }
        currentFile
          ..deleteSync()
          ..createSync(recursive: true);
        _currentFile = currentFile;
        _currentIO = currentFile.openWrite(mode: FileMode.append).also((it) {
          _finalizer.attach(this, it, detach: this);
        });
      }
    } catch (e, stk) {
      _logE(() => '[swapFiles] failed: $e; $stk');
    }
  }

  Future<void> clear() async {
    try {
      _logD(
        () => '[clear] before; file0: ${_file0.lengthSync()}, '
            'file1: ${_file1.lengthSync()}',
      );
      final currentIO = _currentIO;
      _currentIO = null;
      await currentIO?.close();

      _file0
        ..deleteSync()
        ..createSync(recursive: true);
      _file1
        ..deleteSync()
        ..createSync(recursive: true);

      _currentFile = _file0;
      _currentIO = _currentFile?.openWrite(mode: FileMode.append).also((it) {
        _finalizer.attach(this, it, detach: this);
      });
      _logV(
        () => '[clear] after; file0: ${_file0.lengthSync()}, '
            'file1: ${_file1.lengthSync()}',
      );
    } catch (e, stk) {
      _logE(() => '[clear] failed: $e; $stk');
      rethrow;
    }
  }

  Future<dynamic> share() async {
    _logD(() => '[share] no args');
    final sender = this.sender;
    if (sender == null) {
      _logW(() => '[share] rejected (sender is not provided)');
      throw const FileLoggerException('Sender is not provided');
    }
    try {
      final shareable = await prepareShareable();
      _logV(() => '[share] shareable: $shareable(${shareable.existsSync()})');
      return await sender.call(shareable);
    } catch (e, stk) {
      _logE(() => '[share] failed: $e; $stk');
      rethrow;
    }
  }

  Future<File> prepareShareable() async {
    final filename = '$_shareableFilePrefix'
        '${_dateFormat.format(DateTime.now())}.txt';
    final out = File('${_tempsDir.path}$pathSeparator$filename')
      ..createSync(recursive: true);
    _logD(() => '[prepareShareable] out: $out');

    IOSink? writer;
    try {
      writer = out.openWrite(mode: FileMode.append);
      writer.writeln(await _buildHeader());
      final filtered = [_file0, _file1]
          .where((file) => file.existsSync())
          .sortedBy((file) => file.lastModifiedSync());
      for (final file in filtered) {
        if (file.existsSync()) {
          await writer.addStream(file.openRead());
        }
      }
      await writer.flush();
    } catch (e, stk) {
      _logE(() => '[prepareShareable] failed: $e; $stk');
    } finally {
      await writer?.close();
    }
    return out;
  }

  Future<String> _buildHeader() async {
    final buffer = StringBuffer();
    buffer
      ..write('|=============================================================')
      ..write('\n')
      ..write('|Logs Collected: ')
      ..write(_timeFormat.format(DateTime.now()))
      ..write('\n')
      ..write('|App Version: ')
      ..write(await config.appVersion)
      ..write('\n')
      ..write('|Device Info: ');

    final deviceInfo = await config.deviceInfo;
    if (deviceInfo is Map) {
      buffer.write('\n');
      deviceInfo.forEach((key, value) {
        buffer
          ..write('|  ')
          ..write(key)
          ..write(':  ')
          ..write(value)
          ..write('\n');
      });
    } else {
      buffer
        ..write(deviceInfo)
        ..write('\n');
    }

    buffer
      ..write('|=============================================================')
      ..write('\n')
      ..write('|');

    return buffer.toString();
  }

  void _logV(MessageBuilder message) {
    console?.log(Priority.verbose, _tag, message);
  }

  void _logD(MessageBuilder message) {
    console?.log(Priority.debug, _tag, message);
  }

  void _logI(MessageBuilder message) {
    console?.log(Priority.info, _tag, message);
  }

  void _logW(MessageBuilder message) {
    console?.log(Priority.warning, _tag, message);
  }

  void _logE(MessageBuilder message) {
    console?.log(Priority.error, _tag, message);
  }
}

abstract class FileLogConfig {
  int get maxLogSize => _defaultSize;

  Future<Directory> get filesDir;

  Future<Directory> get tempsDir;

  Future<String> get appVersion;

  Future<dynamic> get deviceInfo;
}

extension on IOSink {
  void log(
    Priority priority,
    String tag,
    MessageBuilder message, [
    Object? error,
    StackTrace? stk,
  ]) {
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

class FileLoggerException implements Exception {
  const FileLoggerException([this.message]);

  final dynamic message;

  @override
  String toString() {
    final message = this.message;
    if (message == null) return 'FileLoggerException';
    return 'FileLoggerException: $message';
  }
}
