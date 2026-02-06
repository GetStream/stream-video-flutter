import '../../sdp.dart';
import 'sdp_munging_rule.dart';

// Temp SDP munging to add stereo=1 parameter before SFU switch is set for Flutter SDK
class SetOpusStereoEnabledRule extends SdpMungingRule {
  const SetOpusStereoEnabledRule({
    required this.enabled,
    super.platforms,
    super.types = const [SdpType.remoteOffer],
  });

  final bool enabled;

  @override
  String get key => 'set-opus-stereo-enabled';

  @override
  String toString() {
    return 'SetOpusStereoEnabledRule{enabled: $enabled, '
        'types: $types, platforms: $platforms}';
  }
}
