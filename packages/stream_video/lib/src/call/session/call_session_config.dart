import '../../types/other.dart';

class CallSessionConfig {
  const CallSessionConfig({
    required this.sfuName,
    required this.sfuToken,
    required this.sfuUrl,
    required this.sfuWsEndpoint,
    required this.rtcConfig,
  });

  final String sfuName;
  final String sfuToken;
  final String sfuUrl;
  final String sfuWsEndpoint;
  final RTCConfiguration rtcConfig;

  @override
  String toString() {
    return 'CallSessionConfig{sfuName: $sfuName, sfuToken: $sfuToken, '
        'sfuUrl: $sfuUrl, sfuWsEndpoint: $sfuWsEndpoint, '
        'rtcConfig: $rtcConfig}';
  }
}
