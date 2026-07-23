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
    if (appName case final name?) 'app=${_sanitizeHeaderValue(name)}',
    if (appVersion case final version?)
      'app_version=${_sanitizeHeaderValue(version)}',
    switch ((osName, osVersion)) {
      (final name, final version?) =>
        'os=${_sanitizeHeaderValue(name)} ${_sanitizeHeaderValue(version)}',
      (final name, null) => 'os=${_sanitizeHeaderValue(name)}',
    },
    if (deviceModel case final model?)
      'device_model=${_sanitizeHeaderValue(model)}',
    if (browserName case final name?) 'browser=${_sanitizeHeaderValue(name)}',
  ].join('|');

  /// Removes characters that are not valid in an HTTP header field value.
  ///
  /// Keeps printable US-ASCII characters (`0x20`–`0x7E`) and drops the `|`
  /// separator used to join the header segments so individual values cannot
  /// break the header structure.
  static String _sanitizeHeaderValue(String value) {
    final buffer = StringBuffer();
    for (final codeUnit in value.codeUnits) {
      if (codeUnit >= 0x20 && codeUnit <= 0x7E && codeUnit != 0x7C) {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString().trim();
  }
}
