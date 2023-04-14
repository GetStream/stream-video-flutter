import 'dart:io';

import 'platform_detector.dart';

/// Version running on native systems
PlatformType get currentPlatform {
  if (Platform.isWindows) return PlatformType.windows;
  if (Platform.isFuchsia) return PlatformType.fuchsia;
  if (Platform.isMacOS) return PlatformType.macOS;
  if (Platform.isLinux) return PlatformType.linux;
  if (Platform.isIOS) return PlatformType.ios;
  return PlatformType.android;
}

/// True if the app is running in test environment.
bool get isFlutterTestEnvironment {
  return Platform.environment.containsKey('FLUTTER_TEST');
}
