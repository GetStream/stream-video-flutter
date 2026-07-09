import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_video/globals.dart';
import 'package:stream_video/stream_video.dart';
import 'package:system_info2/system_info2.dart';

/// [EnvironmentInfoProvider] backed by `device_info_plus`, `package_info_plus`
/// and `system_info2`, matching the native SDK's existing environment
/// collection behavior.
class FlutterEnvironmentInfoProvider implements EnvironmentInfoProvider {
  const FlutterEnvironmentInfoProvider();

  @override
  Future<VideoEnvironment> collect() async {
    String? appName;
    String? appVersion;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    } catch (_) {
      // Package info unavailable.
    }

    String? osVersion;
    String? osArchitecture;
    String? deviceModel;
    String? deviceVersion;
    String? browserName;
    String? browserVersion;

    try {
      if (CurrentPlatform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        osVersion = info.version.release;
        osArchitecture = SysInfo.rawKernelArchitecture;
        deviceModel = '${info.manufacturer} ${info.model}';
      } else if (CurrentPlatform.isIos) {
        final info = await DeviceInfoPlugin().iosInfo;
        osVersion = info.systemVersion;
        deviceModel = info.utsname.machine;
      } else if (CurrentPlatform.isMacOS) {
        final info = await DeviceInfoPlugin().macOsInfo;
        osVersion =
            '${info.majorVersion}.${info.minorVersion}.${info.patchVersion}';
        osArchitecture = info.arch;
        deviceModel = info.model;
        deviceVersion = info.osRelease;
      } else if (CurrentPlatform.isWindows) {
        final info = await DeviceInfoPlugin().windowsInfo;
        osVersion =
            '${info.majorVersion}.${info.minorVersion}.${info.buildNumber}';
        osArchitecture = info.buildLabEx;
      } else if (CurrentPlatform.isLinux) {
        final info = await DeviceInfoPlugin().linuxInfo;
        osVersion = '${info.name} ${info.version}';
      } else if (CurrentPlatform.isWeb) {
        final info = await DeviceInfoPlugin().webBrowserInfo;
        browserName = info.browserName.name;
        browserVersion = info.appVersion;
      }
    } catch (_) {
      // Platform info unavailable.
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
      webrtcVersion: switch (CurrentPlatform.type) {
        PlatformType.android => androidWebRTCVersion,
        PlatformType.ios => iosWebRTCVersion,
        _ => null,
      },
    );
  }
}
