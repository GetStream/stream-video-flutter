import '../../types/other.dart';

class CallSessionConfig {
  const CallSessionConfig({
    required this.sfuToken,
    required this.sfuUrl,
    required this.sfuWsEndpoint,
    required this.rtcConfig,
  });

  final String sfuToken;
  final String sfuUrl;
  final String sfuWsEndpoint;
  final RTCConfiguration rtcConfig;

  @override
  String toString() {
    return 'CallSessionConfig{sfuToken: $sfuToken, sfuUrl: $sfuUrl, '
        'sfuWsEndpoint: $sfuWsEndpoint, rtcConfig: $rtcConfig}';
  }
}
