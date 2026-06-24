/// Immutable snapshot of the environment in which the Stream Video SDK runs.
class VideoEnvironment {
  const VideoEnvironment({
    required this.sdkVersion,
    required this.osName,
    this.appName,
    this.appVersion,
    this.osVersion,
    this.osArchitecture,
    this.deviceModel,
    this.deviceVersion,
    this.browserName,
    this.browserVersion,
    this.webrtcVersion,
  });

  final String sdkVersion;
  final String osName;

  final String? appName;
  final String? appVersion;

  final String? osVersion;
  final String? osArchitecture;

  /// Device model name (mobile / desktop).
  final String? deviceModel;

  /// OS release string — populated on macOS only.
  final String? deviceVersion;

  /// Browser name / version — populated on web only.
  final String? browserName;
  final String? browserVersion;

  final String? webrtcVersion;

  VideoEnvironment copyWith({
    String? sdkVersion,
    String? osName,
    String? appName,
    String? appVersion,
    String? osVersion,
    String? osArchitecture,
    String? deviceModel,
    String? deviceVersion,
    String? browserName,
    String? browserVersion,
    String? webrtcVersion,
  }) {
    return VideoEnvironment(
      sdkVersion: sdkVersion ?? this.sdkVersion,
      osName: osName ?? this.osName,
      appName: appName ?? this.appName,
      appVersion: appVersion ?? this.appVersion,
      osVersion: osVersion ?? this.osVersion,
      osArchitecture: osArchitecture ?? this.osArchitecture,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceVersion: deviceVersion ?? this.deviceVersion,
      browserName: browserName ?? this.browserName,
      browserVersion: browserVersion ?? this.browserVersion,
      webrtcVersion: webrtcVersion ?? this.webrtcVersion,
    );
  }
}

extension VideoEnvironmentHeader on VideoEnvironment {
  /// Builds the `X-Stream-Client` header value.
  String get xStreamClientHeader => [
    'stream-video-flutter-v$sdkVersion',
    if (appName case final name?) 'app=$name',
    if (appVersion case final version?) 'app_version=$version',
    switch ((osName, osVersion)) {
      (final name, final version?) => 'os=$name $version',
      (final name, null) => 'os=$name',
    },
    if (deviceModel case final model?) 'device_model=$model',
    if (browserName case final name?) 'browser=$name',
  ].join('|');
}
