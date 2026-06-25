import '../globals.dart' show streamVideoVersion;
import '../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import 'platform_detector/platform_detector.dart';
import 'video_environment.dart';
import 'video_environment_collector.dart';

/// Manages the current [VideoEnvironment] and derives the header / proto objects from it.
class VideoEnvironmentManager {
  VideoEnvironmentManager({VideoEnvironment? environment})
    : _environment =
          environment ??
          VideoEnvironment(
            sdkVersion: streamVideoVersion,
            osName: CurrentPlatform.name,
          );

  VideoEnvironment _environment;

  VideoEnvironment get environment => _environment;

  // ignore: use_setters_to_change_properties
  void updateEnvironment(VideoEnvironment environment) {
    _environment = environment;
  }

  /// Collects platform info and updates the managed [VideoEnvironment].
  Future<void> collectAndUpdate() async {
    final environment = await VideoEnvironmentCollector.collect();
    updateEnvironment(environment);
  }

  /// The `X-Stream-Client` header value for the current environment.
  String get xStreamClientHeader => _environment.xStreamClientHeader;

  /// The SFU `ClientDetails` proto for the current environment.
  sfu_models.ClientDetails get clientDetails {
    final env = _environment;
    final versionParts = env.sdkVersion.split('.');

    sfu_models.Device? device;
    if (env.deviceModel case final model?) {
      device = sfu_models.Device(
        name: model,
        version: env.deviceVersion ?? '',
      );
    }

    sfu_models.Browser? browser;
    if (env.browserName case final name?) {
      browser = sfu_models.Browser(
        name: name,
        version: env.browserVersion,
      );
    }

    return sfu_models.ClientDetails(
      sdk: sfu_models.Sdk(
        type: sfu_models.SdkType.SDK_TYPE_FLUTTER,
        major: versionParts.isNotEmpty ? versionParts[0] : '0',
        minor: versionParts.length > 1 ? versionParts[1] : '0',
        patch: versionParts.length > 2 ? versionParts[2] : '0',
      ),
      os: sfu_models.OS(
        name: env.osName,
        version: env.osVersion ?? '',
        architecture: env.osArchitecture ?? '',
      ),
      device: device,
      browser: browser,
      webrtcVersion: env.webrtcVersion ?? '',
    );
  }
}
