import '../../globals.dart' show streamVideoVersion;
import '../platform_detector/platform_detector.dart';
import '../video_environment.dart';

/// Collects platform/app info for [VideoEnvironment].
///
/// The default implementation returns a minimal environment (SDK version +
/// OS name only), which is correct for web/Jaspr where no device/package
/// plugins are available. `stream_video_flutter` registers a plugin-backed
/// implementation (device/package/system info) via
/// `StreamVideoFlutter.ensureInitialized()`.
abstract class EnvironmentInfoProvider {
  /// The active provider. Assign a platform-specific implementation to
  /// override the default (e.g. from `StreamVideoFlutter.ensureInitialized()`).
  static EnvironmentInfoProvider instance =
      const DefaultEnvironmentInfoProvider();

  Future<VideoEnvironment> collect();
}

class DefaultEnvironmentInfoProvider implements EnvironmentInfoProvider {
  const DefaultEnvironmentInfoProvider();

  @override
  Future<VideoEnvironment> collect() async {
    return VideoEnvironment(
      sdkVersion: streamVideoVersion,
      osName: CurrentPlatform.name,
    );
  }
}
