// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class AppFileLogConfig extends FileLogConfig {
  AppFileLogConfig(String appVersion) : _appVersion = appVersion;

  final String _appVersion;

  late final deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Future<Directory> get filesDir async => getApplicationDocumentsDirectory();

  @override
  Future<Directory> get tempsDir async => getTemporaryDirectory();

  @override
  Future<String> get appVersion async => _appVersion;

  @override
  Future<dynamic> get deviceInfo async {
    try {
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      return deviceInfo.data;
    } catch (e, stk) {
      streamLog.e('SV:FileConfig', () => '[deviceInfo] failed: $e; $stk');
      return 'Failed to get device info';
    }
  }
}
