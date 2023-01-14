import '../../../types/other.dart';
import '../call_settings.dart';

class CallSessionConfig {
  CallSessionConfig({
    required this.sfuToken,
    required this.sfuUrl,
    required this.rtcConfig,
    this.callSettings = const CallSettings(),
  });

  final String sfuToken;
  final String sfuUrl;
  final RTCConfiguration rtcConfig;
  final CallSettings callSettings;

  @override
  String toString() {
    return 'CallSessionConfig{sfuToken: $sfuToken, sfuUrl: $sfuUrl, '
        'rtcConfig: $rtcConfig, callOptions: $callSettings}';
  }
}
