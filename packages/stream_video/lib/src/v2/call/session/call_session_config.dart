import '../../../types/other.dart';
import '../call_settings.dart';

class CallSessionConfig {
  CallSessionConfig({
    required this.sfuToken,
    required this.sfuUrl,
    required this.rtcConfig,
  });

  final String sfuToken;
  final String sfuUrl;
  final RTCConfiguration rtcConfig;

  @override
  String toString() {
    return 'CallSessionConfig{sfuToken: $sfuToken, sfuUrl: $sfuUrl, '
        'rtcConfig: $rtcConfig}';
  }
}
