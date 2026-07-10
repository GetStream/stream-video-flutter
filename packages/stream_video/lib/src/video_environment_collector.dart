import 'package:device_info_plus/device_info_plus.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_info2/system_info2.dart';

import '../globals.dart';
import 'logger/stream_log.dart';
import 'platform_detector/platform_detector.dart';
import 'video_environment.dart';

const _tag = 'SV:EnvCollector';

/// Collects platform and app info for [VideoEnvironment].
// ignore: avoid_classes_with_only_static_members
class VideoEnvironmentCollector {
  /// Override for testing. When set, replaces [collect] implementation.
  @visibleForTesting
  static Future<VideoEnvironment> Function()? override;

  /// Collects platform and app info and returns a fully-populated
  /// [VideoEnvironment].
  static Future<VideoEnvironment> collect() {
    return override?.call() ?? _collect();
  }

  static Future<VideoEnvironment> _collect() async {
    try {
      String? appName;
      String? appVersion;
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        appName = packageInfo.appName;
        appVersion = packageInfo.version;
      } catch (e, stk) {
        streamLog.e(
          _tag,
          () => '[collect] package info failed: $e\n$stk',
        );
      }

      String? osVersion;
      String? osArchitecture;
      String? deviceModel;
      String? deviceVersion;
      String? browserName;
      String? browserVersion;
      String? webrtcVersion;

      try {
        if (CurrentPlatform.isAndroid) {
          final info = await DeviceInfoPlugin().androidInfo;
          osVersion = info.version.release;
          osArchitecture = SysInfo.rawKernelArchitecture;
          deviceModel = '${info.manufacturer} ${info.model}';
          webrtcVersion = androidWebRTCVersion;
        } else if (CurrentPlatform.isIos) {
          final info = await DeviceInfoPlugin().iosInfo;
          osVersion = info.systemVersion;
          deviceModel = info.utsname.machine;
          webrtcVersion = iosWebRTCVersion;
        } else if (CurrentPlatform.isMacOS) {
          final info = await DeviceInfoPlugin().macOsInfo;
          osVersion =
              '${info.majorVersion}.${info.minorVersion}.${info.patchVersion}';
          osArchitecture = info.arch;
          deviceModel = info.model;
          deviceVersion = info.osRelease;
          webrtcVersion = macOsWebRTCVersion;
        } else if (CurrentPlatform.isWindows) {
          final info = await DeviceInfoPlugin().windowsInfo;
          osVersion =
              '${info.majorVersion}.${info.minorVersion}.${info.buildNumber}';
          osArchitecture = info.buildLabEx;
          webrtcVersion = windowsWebRTCVersion;
        } else if (CurrentPlatform.isLinux) {
          final info = await DeviceInfoPlugin().linuxInfo;
          osVersion = '${info.name} ${info.version}';
          webrtcVersion = linuxWebRTCVersion;
        } else if (CurrentPlatform.isWeb) {
          final info = await DeviceInfoPlugin().webBrowserInfo;
          browserName = info.browserName.name;
          browserVersion = info.appVersion;
        }
      } catch (e, stk) {
        streamLog.e(
          _tag,
          () => '[collect] platform info failed: $e\n$stk',
        );
      }

      return VideoEnvironment(
        sdkVersion: streamVideoVersion,
        osName: CurrentPlatform.name,
        appName: appName,
        appVersion: appVersion,
        osVersion: osVersion,
        osArchitecture: osArchitecture,
        deviceModel: deviceModel,
        deviceVersion: deviceVersion,
        browserName: browserName,
        browserVersion: browserVersion,
        webrtcVersion: webrtcVersion,
      );
    } catch (e, stk) {
      streamLog.e(
        _tag,
        () => '[collect] failed: $e\n$stk',
      );
      return VideoEnvironment(
        sdkVersion: streamVideoVersion,
        osName: CurrentPlatform.name,
      );
    }
  }
}
